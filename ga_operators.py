# ============================================
# GA Operators - Selection, Crossover, Mutation
# ============================================

import numpy as np
from typing import List, Tuple
from config import *


class GAOperators:
    """Genetik Algoritma operatörleri"""
    
    def __init__(self):
        pass
    
    @staticmethod
    def tournament_selection(population: List[np.ndarray], 
                            fitness_scores: List[float], 
                            tournament_size: int = GA_TOURNAMENT_SIZE) -> np.ndarray:
        """
        Tournament selection: k adet random individual seç, en iyi olanı döndür
        
        Args:
            population: Population (individual list)
            fitness_scores: Her individual için fitness score
            tournament_size: Tournament'e katılan birey sayısı
        
        Returns:
            Seçilen individual
        """
        
        pop_size = len(population)
        tournament_indices = np.random.choice(pop_size, size=tournament_size, replace=False)
        
        # En düşük fitness'i (en iyi) seç
        best_tournament_idx = tournament_indices[
            np.argmin([fitness_scores[i] for i in tournament_indices])
        ]
        
        return population[best_tournament_idx].copy()
    
    @staticmethod
    def order_crossover(parent1: np.ndarray, parent2: np.ndarray, 
                       path_section_end: int) -> np.ndarray:
        """
        Order Crossover (OX): Path permutatonları için
        
        Args:
            parent1, parent2: Parent chromosomes
            path_section_end: Path genes kaç index'e kadar
        
        Returns:
            Child chromosome
        """
        
        child = parent1.copy()
        
        # Yol kısmında OX yap
        path_length = path_section_end
        
        # Random crossover points seç
        point1 = np.random.randint(0, path_length // 2)
        point2 = np.random.randint(path_length // 2, path_length)
        
        # Parent2'nin middle segment'ini al
        middle_segment = parent2[point1:point2].copy()
        
        # Parent1'den middle'ı kaldır, parent2'nin geri kalanını ekle
        for i in range(len(middle_segment)):
            child[point1 + i] = middle_segment[i]
        
        return child
    
    @staticmethod
    def uniform_crossover(parent1: np.ndarray, parent2: np.ndarray, 
                         start_idx: int, probability: float = 0.5) -> np.ndarray:
        """
        Uniform crossover: Güç seviyeleri ve topology için
        
        Args:
            parent1, parent2: Parent chromosomes
            start_idx: Crossover'ı nerede başlatacağız
            probability: Her pozisyonda parent2'den alma olasılığı
        
        Returns:
            Child chromosome
        """
        
        child = parent1.copy()
        
        for i in range(start_idx, len(parent1)):
            if np.random.random() < probability:
                child[i] = parent2[i]
        
        return child
    
    @staticmethod
    def crossover(parent1: np.ndarray, parent2: np.ndarray,
                 num_agents: int, num_waypoints: int) -> np.ndarray:
        """
        Hibrid crossover: Path'ler için OX, güç/topology için Uniform
        
        Args:
            parent1, parent2: Parent chromosomes
            num_agents: Agent sayısı
            num_waypoints: Waypoint sayısı
        
        Returns:
            Child chromosome
        """
        
        path_section_end = num_agents * num_waypoints
        power_section_end = path_section_end + num_agents
        
        # OX for paths
        child = GAOperators.order_crossover(parent1, parent2, path_section_end)
        
        # Uniform for power levels
        child[path_section_end:power_section_end] = np.where(
            np.random.random(num_agents) < 0.5,
            parent1[path_section_end:power_section_end],
            parent2[path_section_end:power_section_end]
        )
        
        # Uniform for topology
        child[power_section_end:] = np.where(
            np.random.random(len(parent1) - power_section_end) < 0.5,
            parent1[power_section_end:],
            parent2[power_section_end:]
        )
        
        return child
    
    @staticmethod
    def swap_mutation(chromosome: np.ndarray, 
                     path_section_end: int,
                     rate: float = 0.1) -> np.ndarray:
        """
        Swap mutation: Path genes'te iki pozisyonu swap et
        
        Args:
            chromosome: Chromosome to mutate
            path_section_end: Path genes kaç index'e kadar
            rate: Mutation olasılığı
        
        Returns:
            Mutated chromosome
        """
        
        mutated = chromosome.copy()
        
        if np.random.random() < rate:
            # Rasgele 2 pozisyon seç
            idx1 = np.random.randint(0, path_section_end)
            idx2 = np.random.randint(0, path_section_end)
            
            mutated[idx1], mutated[idx2] = mutated[idx2], mutated[idx1]
        
        return mutated
    
    @staticmethod
    def gaussian_mutation(chromosome: np.ndarray,
                         start_idx: int,
                         end_idx: int,
                         rate: float = 0.1,
                         std: float = 0.1) -> np.ndarray:
        """
        Gaussian mutation: Güç seviyelerine Gaussian noise ekle
        
        Args:
            chromosome: Chromosome to mutate
            start_idx: Güç section başlangıcı
            end_idx: Güç section sonu
            rate: Mutation olasılığı
            std: Gaussian standard deviation
        
        Returns:
            Mutated chromosome
        """
        
        mutated = chromosome.copy()
        
        if np.random.random() < rate:
            noise = np.random.normal(0, std, size=end_idx - start_idx)
            mutated[start_idx:end_idx] += noise
            
            # Clip to [0, 1] for power levels
            mutated[start_idx:end_idx] = np.clip(mutated[start_idx:end_idx], 0.0, 1.0)
        
        return mutated
    
    @staticmethod
    def bit_flip_mutation(chromosome: np.ndarray,
                         start_idx: int,
                         rate: float = 0.1,
                         flip_strength: float = 0.5) -> np.ndarray:
        """
        Bit flip mutation: Topology genes'te değerler toggle et
        
        Args:
            chromosome: Chromosome to mutate
            start_idx: Topology section başlangıcı
            rate: Mutation olasılığı
            flip_strength: Flip etme gücü (0-1)
        
        Returns:
            Mutated chromosome
        """
        
        mutated = chromosome.copy()
        
        if np.random.random() < rate:
            # Rasgele bir topology gene'i seç ve flip et
            topology_length = len(chromosome) - start_idx
            if topology_length > 0:
                idx = np.random.randint(0, topology_length)
                mutated[start_idx + idx] = 1.0 - mutated[start_idx + idx]
        
        return mutated
    
    @staticmethod
    def mutate(chromosome: np.ndarray,
              num_agents: int,
              num_waypoints: int,
              rate: float = GA_MUTATION_RATE) -> np.ndarray:
        """
        Hybrid mutation: Tüm bölümlere farklı mutation operatörleri uygula
        
        Args:
            chromosome: Chromosome to mutate
            num_agents: Agent sayısı
            num_waypoints: Waypoint sayısı
            rate: Global mutation rate
        
        Returns:
            Mutated chromosome
        """
        
        path_section_end = num_agents * num_waypoints
        power_section_end = path_section_end + num_agents
        
        # Apply different mutations to different sections
        mutated = chromosome.copy()
        
        # Swap mutation for paths
        mutated = GAOperators.swap_mutation(mutated, path_section_end, rate=rate)
        
        # Gaussian mutation for power levels
        mutated = GAOperators.gaussian_mutation(
            mutated, 
            path_section_end, 
            power_section_end,
            rate=rate,
            std=0.1
        )
        
        # Bit flip mutation for topology
        mutated = GAOperators.bit_flip_mutation(
            mutated,
            power_section_end,
            rate=rate
        )
        
        return mutated


# Test GA operators
if __name__ == "__main__":
    # Create test chromosomes
    chrom_size = NUM_AGENTS * NUM_WAYPOINTS + NUM_AGENTS + NUM_AGENTS * (NUM_AGENTS - 1) // 2
    parent1 = np.random.rand(chrom_size)
    parent2 = np.random.rand(chrom_size)
    
    # Test crossover
    child = GAOperators.crossover(parent1, parent2, NUM_AGENTS, NUM_WAYPOINTS)
    print(f"Crossover test: parent1 len={len(parent1)}, child len={len(child)}")
    
    # Test mutations
    mutated = GAOperators.mutate(child, NUM_AGENTS, NUM_WAYPOINTS, rate=0.5)
    print(f"Mutation test: child len={len(child)}, mutated len={len(mutated)}")
    print("GA Operators test passed!")
