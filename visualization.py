# ============================================
# Visualization - 2D Animation & Plots
# ============================================

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.animation import FuncAnimation
import json
import os
from typing import List, Tuple
from config import *
from simulator import SwarmSimulator


class SwarmVisualizer:
    """Sürü simülasyonunu görselleştir"""
    
    def __init__(self, waypoint_positions: List[Tuple[float, float]]):
        self.waypoint_positions = waypoint_positions
        self.simulator = SwarmSimulator(NUM_AGENTS, waypoint_positions)
    
    def visualize_solution(self, agent_paths: List[List[int]], 
                          power_levels: List[float],
                          comm_topology: List[Tuple[int, int]],
                          save_path: str = None):
        """
        Çözümü statik olarak görselleştir (harita + path)
        
        Args:
            agent_paths: Her agent için waypoint sırası
            power_levels: Her agent için güç seviyesi
            comm_topology: Haberleşme bağlantıları
            save_path: Kaydedilecek dosya path'i
        """
        
        fig, ax = plt.subplots(1, 1, figsize=FIGURE_SIZE, dpi=FIGURE_DPI)
        
        # World background
        ax.set_xlim(-50, WORLD_SIZE + 50)
        ax.set_ylim(-50, WORLD_SIZE + 50)
        ax.set_aspect('equal')
        ax.grid(True, alpha=0.3)
        ax.set_xlabel('X (meter)', fontsize=12)
        ax.set_ylabel('Y (meter)', fontsize=12)
        ax.set_title('Optimal Swarm Configuration', fontsize=14, fontweight='bold')
        
        # Draw waypoints
        colors = ['red', 'green', 'blue', 'orange', 'purple']
        for wp_id, (x, y) in enumerate(self.waypoint_positions):
            circle = patches.Circle((x, y), 15, color=colors[wp_id], alpha=0.3, zorder=1)
            ax.add_patch(circle)
            ax.plot(x, y, 'o', color=colors[wp_id], markersize=10, zorder=2)
            ax.text(x + 20, y + 20, f'WP{wp_id}', fontsize=10, fontweight='bold')
        
        # Draw agent paths
        agent_colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#FFA07A', '#98D8C8']
        for agent_id, path in enumerate(agent_paths):
            color = agent_colors[agent_id % len(agent_colors)]
            
            # Get waypoint coordinates for this path
            path_coords = [self.waypoint_positions[wp_id] for wp_id in path]
            path_coords = np.array(path_coords)
            
            # Draw path
            ax.plot(path_coords[:, 0], path_coords[:, 1], 
                   'o-', color=color, linewidth=2, markersize=8, 
                   alpha=0.7, label=f'Agent {agent_id} (Power: {power_levels[agent_id]:.2f})')
            
            # Draw agent start position
            ax.plot(self.waypoint_positions[path[0]][0], 
                   self.waypoint_positions[path[0]][1],
                   '*', color=color, markersize=20, zorder=3)
        
        # Draw communication topology (sample)
        for i, (sender, receiver) in enumerate(comm_topology[:5]):  # Show first 5
            # Simulate positions at center
            start = self.waypoint_positions[2]  # Approximate
            end = self.waypoint_positions[3]
            ax.annotate('', xy=end, xytext=start,
                       arrowprops=dict(arrowstyle='->', 
                                     connectionstyle='arc3,rad=0.2',
                                     color='gray', alpha=0.3, lw=0.5))
        
        ax.legend(loc='upper right', fontsize=10)
        
        if save_path:
            plt.savefig(save_path, dpi=FIGURE_DPI, bbox_inches='tight')
            print(f"✓ Saved visualization to {save_path}")
        
        plt.tight_layout()
        return fig, ax
    
    def plot_fitness_history(self, best_fitness_history: List[float],
                            avg_fitness_history: List[float],
                            save_path: str = None):
        """
        Fitness history grafiği
        
        Args:
            best_fitness_history: Best fitness her jenerasyon
            avg_fitness_history: Average fitness her jenerasyon
            save_path: Kaydedilecek dosya path'i
        """
        
        fig, ax = plt.subplots(1, 1, figsize=(12, 6), dpi=FIGURE_DPI)
        
        generations = range(len(best_fitness_history))
        
        ax.plot(generations, best_fitness_history, 'b-', linewidth=2, label='Best Fitness')
        ax.plot(generations, avg_fitness_history, 'r--', linewidth=2, label='Average Fitness')
        ax.fill_between(generations, best_fitness_history, avg_fitness_history, 
                        alpha=0.2, color='blue')
        
        ax.set_xlabel('Generation', fontsize=12)
        ax.set_ylabel('Fitness Score', fontsize=12)
        ax.set_title('GA Convergence - Fitness Over Generations', fontsize=14, fontweight='bold')
        ax.legend(fontsize=11)
        ax.grid(True, alpha=0.3)
        
        if save_path:
            plt.savefig(save_path, dpi=FIGURE_DPI, bbox_inches='tight')
            print(f"✓ Saved fitness plot to {save_path}")
        
        plt.tight_layout()
        return fig, ax


def visualize_results():
    """Kaydedilen sonuçları görselleştir"""
    
    # Load best individual
    best_ind_file = os.path.join(OUTPUT_DIR, 'best_individual.json')
    if not os.path.exists(best_ind_file):
        print(f"Error: {best_ind_file} not found. Run main.py first!")
        return
    
    with open(best_ind_file, 'r') as f:
        data = json.load(f)
    
    best_fitness = data['best_fitness']
    best_individual = np.array(data['best_individual'])
    
    # Decode chromosome
    from fitness import FitnessEvaluator
    evaluator = FitnessEvaluator()
    paths, power, topology = evaluator._decode_chromosome(best_individual)
    
    # Create visualizer
    visualizer = SwarmVisualizer(WAYPOINT_POSITIONS)
    
    # Plot solution
    sol_fig, sol_ax = visualizer.visualize_solution(
        paths, power, topology,
        save_path=os.path.join(OUTPUT_DIR, 'solution_visualization.png')
    )
    
    # Plot fitness history
    import csv
    history_file = os.path.join(OUTPUT_DIR, 'fitness_history.csv')
    generations = []
    best_fitness_list = []
    avg_fitness_list = []
    
    if os.path.exists(history_file):
        with open(history_file, 'r') as f:
            reader = csv.DictReader(f)
            for row in reader:
                generations.append(int(row['Generation']))
                best_fitness_list.append(float(row['Best_Fitness']))
                avg_fitness_list.append(float(row['Avg_Fitness']))
        
        hist_fig, hist_ax = visualizer.plot_fitness_history(
            best_fitness_list, avg_fitness_list,
            save_path=os.path.join(OUTPUT_DIR, 'fitness_convergence.png')
        )
    
    # Print summary
    print("\n" + "=" * 60)
    print("VISUALIZATION SUMMARY")
    print("=" * 60)
    print(f"Best Fitness: {best_fitness:.4f}")
    print(f"Agent Paths:")
    for agent_id, path in enumerate(paths):
        print(f"  Agent {agent_id}: {' → '.join(map(str, path))}")
    print(f"Power Levels: {[f'{p:.2f}' for p in power]}")
    print(f"Comm Topology Links: {len(topology)}")
    print("=" * 60)
    
    plt.show()


if __name__ == "__main__":
    visualize_results()
