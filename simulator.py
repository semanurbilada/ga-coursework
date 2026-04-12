# ============================================
# Simulator - Drone & Communication Physics
# ============================================

import numpy as np
from typing import List, Tuple
from config import *


class DroneAgent:
    """Bir drone agentn temsil eder"""
    
    def __init__(self, agent_id: int, start_pos: Tuple[float, float], max_speed: float = AGENT_MAX_SPEED):
        self.id = agent_id
        self.pos = np.array(start_pos, dtype=float)
        self.max_speed = max_speed
        self.velocity = np.array([0.0, 0.0])
        self.energy_consumed = 0.0
        self.total_distance = 0.0
        self.communication_latencies = []
        self.communication_failures = 0
    
    def move_toward(self, target: Tuple[float, float], power_level: float, dt: float = 1.0) -> float:
        """
        Target konumuna doğru hareket et
        
        Args:
            target: Hedef konum (x, y)
            power_level: Güç seviyesi [0, 1]
            dt: Zaman adımı
        
        Returns:
            Harcanan enerji miktarı
        """
        target = np.array(target, dtype=float)
        direction = target - self.pos
        distance_to_target = np.linalg.norm(direction)
        
        if distance_to_target < 1.0:  # Hedefe ulaştı
            return 0.0
        
        # Normalize direction
        direction_normalized = direction / distance_to_target
        
        # Actual speed based on power level
        actual_speed = power_level * self.max_speed
        
        # Move
        displacement = direction_normalized * actual_speed * dt
        self.pos += displacement
        self.total_distance += np.linalg.norm(displacement)
        
        # Energy consumption: power_level * distance
        energy = power_level * np.linalg.norm(displacement)
        self.energy_consumed += energy
        
        return energy
    
    def reset(self):
        """Drone'u sıfırla"""
        self.energy_consumed = 0.0
        self.total_distance = 0.0
        self.communication_latencies = []
        self.communication_failures = 0
    
    def get_state(self) -> dict:
        """Drone durumunu döndür"""
        return {
            'id': self.id,
            'pos': self.pos.copy(),
            'energy_consumed': self.energy_consumed,
            'total_distance': self.total_distance,
            'comm_failures': self.communication_failures,
        }


class SwarmSimulator:
    """Tüm sürüyü simüle eden sınıf"""
    
    def __init__(self, num_agents: int, waypoint_positions: List[Tuple[float, float]]):
        self.num_agents = num_agents
        self.waypoint_positions = waypoint_positions
        
        # Initialize agents at first waypoint
        self.agents = [
            DroneAgent(i, waypoint_positions[0])
            for i in range(num_agents)
        ]
        
        self.current_time = 0
        self.history = []
    
    def simulate(self, 
                 agent_paths: List[List[int]], 
                 power_levels: List[float], 
                 comm_topology: List[Tuple[int, int]],
                 max_time: int = MAX_SIMULATION_TIME) -> dict:
        """
        Sürüyü simüle et
        
        Args:
            agent_paths: Her agent için waypoint sırası [[0,3,1,4,2], [0,2,4,1,3], ...]
            power_levels: Her agent için güç seviyesi [0.8, 0.6, 0.9, ...]
            comm_topology: Haberleşme bağlantıları [(0,1), (1,2), ...]
            max_time: Simulasyon süresi
        
        Returns:
            Simulasyon metrikleri (zaman, enerji, gecikme, başarısızlık)
        """
        
        # Reset all agents
        for agent in self.agents:
            agent.reset()
        
        # Waypoint progress tracker
        agent_waypoint_idx = [1 for _ in range(self.num_agents)]  # Start from waypoint 1
        
        metrics = {
            'total_time': 0,
            'total_energy': 0,
            'total_latency': 0,
            'total_comm_failures': 0,
        }
        
        # Simulation loop
        for t in range(max_time):
            # Phase 1: Agent movement
            for agent_id in range(self.num_agents):
                path = agent_paths[agent_id]
                
                # Check if agent reached all waypoints
                if agent_waypoint_idx[agent_id] >= len(path):
                    continue
                
                # Get current target waypoint
                target_waypoint_id = path[agent_waypoint_idx[agent_id]]
                target_pos = self.waypoint_positions[target_waypoint_id]
                
                # Move toward target
                distance_to_target = np.linalg.norm(
                    np.array(target_pos) - self.agents[agent_id].pos
                )
                
                energy = self.agents[agent_id].move_toward(
                    target_pos, 
                    power_levels[agent_id], 
                    dt=1.0
                )
                
                # Check if reached waypoint (distance < threshold)
                if distance_to_target < 5.0:
                    agent_waypoint_idx[agent_id] += 1
            
            # Phase 2: Communication simulation
            latency, failures = self._simulate_communication(comm_topology)
            metrics['total_latency'] += latency
            metrics['total_comm_failures'] += failures
            
            # Update time
            self.current_time = t
        
        # Aggregate metrics
        metrics['total_time'] = max_time  # Sabit süresi
        metrics['total_energy'] = sum(agent.energy_consumed for agent in self.agents)
        metrics['total_comm_failures'] += sum(
            agent.communication_failures for agent in self.agents
        )
        
        return metrics
    
    def _simulate_communication(self, topology: List[Tuple[int, int]]) -> Tuple[float, int]:
        """
        Haberleşmeyi simüle et (UDP model)
        
        Returns:
            (toplam_gecikme, paket_kaybı_sayısı)
        """
        total_latency = 0.0
        total_failures = 0
        
        for sender_id, receiver_id in topology:
            sender = self.agents[sender_id]
            receiver = self.agents[receiver_id]
            
            # Calculate distance between agents
            distance = np.linalg.norm(receiver.pos - sender.pos)
            
            # Check communication range
            if distance > MAX_COMMUNICATION_RANGE:
                total_failures += 1
                continue
            
            # Calculate latency: distance/speed_of_light + processing delay
            # Simplified: latency = 1ms + (distance in meters / 300000 km/s) * 1000 ms/s + processing
            # Further simplified for easier computation:
            latency = 1.0 + (distance / MAX_COMMUNICATION_RANGE) * 5.0 + COMMUNICATION_PROCESSING_DELAY
            total_latency += latency
            
            # Packet loss probability based on distance
            loss_probability = BASE_PACKET_LOSS + (distance / MAX_COMMUNICATION_RANGE) * 0.1
            
            if np.random.random() < loss_probability:
                total_failures += 1
                receiver.communication_failures += 1
        
        return total_latency, total_failures
    
    def get_agent_states(self) -> List[dict]:
        """Tüm agentlerin durumunu döndür"""
        return [agent.get_state() for agent in self.agents]


# Test simulator
if __name__ == "__main__":
    sim = SwarmSimulator(NUM_AGENTS, WAYPOINT_POSITIONS)
    
    # Test paths: her agent tüm waypoint'leri ziyaret etsin
    test_paths = [[0, 1, 2, 3, 4] for _ in range(NUM_AGENTS)]
    test_power = [0.8, 0.7, 0.9]
    test_topology = [(0, 1), (1, 2), (2, 0)]
    
    metrics = sim.simulate(test_paths, test_power, test_topology)
    print("Test Simulation Results:")
    print(f"  Total Time: {metrics['total_time']}")
    print(f"  Total Energy: {metrics['total_energy']:.2f}")
    print(f"  Total Latency: {metrics['total_latency']:.2f}")
    print(f"  Comm Failures: {metrics['total_comm_failures']}")
