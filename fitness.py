# ============================================
# Fitness Function - Evaluate Chromosomes
# ============================================

import numpy as np
from typing import List, Tuple
from simulator import SwarmSimulator
from config import *


class FitnessEvaluator:
    """Chromosom'u fitness'e dönüştür"""
    
    def __init__(self):
        self.simulator = SwarmSimulator(NUM_AGENTS, WAYPOINT_POSITIONS)
        self.evaluation_count = 0
    
    def evaluate(self, chromosome: np.ndarray) -> float:
        """
        Chromosom'u değerlendir ve fitness döndür (minimize etmek istiyoruz!)
        
        Chromosome structure:
        - [0:NUM_AGENTS*NUM_WAYPOINTS]: Path indices for each agent
        - [NUM_AGENTS*NUM_WAYPOINTS : NUM_AGENTS*NUM_WAYPOINTS + NUM_AGENTS]: Power levels
        - [NUM_AGENTS*NUM_WAYPOINTS + NUM_AGENTS : end]: Communication topology (binary)
        
        Args:
            chromosome: Chromosom vektörü (float array)
        
        Returns:
            Fitness score (düşük = daha iyi)
        """
        
        # Decode chromosome
        agent_paths, power_levels, comm_topology = self._decode_chromosome(chromosome)
        
        # Validate paths (all waypoints must be visited exactly once)
        if not self._validate_paths(agent_paths):
            return float('inf')  # Invalid solution
        
        # Run simulation
        metrics = self.simulator.simulate(agent_paths, power_levels, comm_topology)
        
        # Calculate fitness (weighted sum of metrics)
        fitness = (
            W_TIME * metrics['total_time'] +
            W_ENERGY * metrics['total_energy'] +
            W_LATENCY * metrics['total_latency'] +
            W_COMM_FAILURES * metrics['total_comm_failures'] * 100  # Penalize failures heavily
        )
        
        self.evaluation_count += 1
        
        return fitness
    
    def _decode_chromosome(self, chromosome: np.ndarray) -> Tuple[List[List[int]], List[float], List[Tuple[int, int]]]:
        """
        Chromosom'u decode et → paths, power_levels, topology
        
        Args:
            chromosome: Chromosom vektörü
        
        Returns:
            (agent_paths, power_levels, comm_topology)
        """
        
        # Part 1: Paths (permutatons of waypoints)
        # Her agent için NUM_WAYPOINTS uzunluğunda path
        path_length = NUM_AGENTS * NUM_WAYPOINTS
        path_genes = chromosome[:path_length]
        
        # Convert to permutations
        agent_paths = []
        for agent_id in range(NUM_AGENTS):
            start_idx = agent_id * NUM_WAYPOINTS
            end_idx = start_idx + NUM_WAYPOINTS
            
            # Get path genes and create permutation
            path_genes_agent = path_genes[start_idx:end_idx]
            
            # Create permutation from genes
            # Simple approach: use argsort for pseudo-permutation
            path = list(np.argsort(path_genes_agent))
            
            # Ensure it's a valid permutation of [0, 1, ..., NUM_WAYPOINTS-1]
            if len(set(path)) != NUM_WAYPOINTS:
                path = list(range(NUM_WAYPOINTS))
            
            agent_paths.append(path)
        
        # Part 2: Power levels [0, 1]
        power_start = path_length
        power_end = power_start + NUM_AGENTS
        power_genes = chromosome[power_start:power_end]
        
        # Clip to [0, 1]
        power_levels = np.clip(power_genes, 0.0, 1.0).tolist()
        
        # Part 3: Communication topology (binary - which pairs communicate)
        topology_start = power_end
        topology_genes = chromosome[topology_start:]
        
        # Create all possible edges and filter based on genes
        max_possible_edges = NUM_AGENTS * (NUM_AGENTS - 1) // 2
        topology_genes = topology_genes[:max_possible_edges]
        
        comm_topology = []
        edge_idx = 0
        for i in range(NUM_AGENTS):
            for j in range(i + 1, NUM_AGENTS):
                if edge_idx < len(topology_genes):
                    if topology_genes[edge_idx] > 0.5:  # Threshold at 0.5
                        comm_topology.append((i, j))
                        comm_topology.append((j, i))  # Bidirectional
                edge_idx += 1
        
        # Ensure at least one communication link
        if not comm_topology:
            comm_topology = [(0, 1), (1, 2), (2, 0)]
        
        return agent_paths, power_levels, comm_topology
    
    def _validate_paths(self, agent_paths: List[List[int]]) -> bool:
        """
        Check if paths are valid (should contain all waypoints 0 to NUM_WAYPOINTS-1)
        """
        for path in agent_paths:
            if len(path) != NUM_WAYPOINTS:
                return False
            if set(path) != set(range(NUM_WAYPOINTS)):
                return False
        return True


# Test fitness evaluator
if __name__ == "__main__":
    evaluator = FitnessEvaluator()
    
    # Create a test chromosome
    test_chromosome = np.random.rand(
        NUM_AGENTS * NUM_WAYPOINTS +  # Paths
        NUM_AGENTS +  # Power levels
        NUM_AGENTS * (NUM_AGENTS - 1) // 2  # Topology
    )
    
    fitness = evaluator.evaluate(test_chromosome)
    print(f"Test Chromosome Fitness: {fitness:.2f}")
    print(f"Evaluations so far: {evaluator.evaluation_count}")
