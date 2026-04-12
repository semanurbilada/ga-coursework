# ============================================
# Main GA - Genetic Algorithm Implementation
# ============================================

import numpy as np
import json
import csv
import os
from typing import List, Tuple
from config import *
from fitness import FitnessEvaluator
from ga_operators import GAOperators


class GeneticAlgorithm:
    """Genetik Algoritma implementasyonu"""
    
    def __init__(self, population_size: int = GA_POPULATION_SIZE,
                 generations: int = GA_GENERATIONS,
                 mutation_rate: float = GA_MUTATION_RATE):
        
        self.population_size = population_size
        self.generations = generations
        self.mutation_rate = mutation_rate
        
        # Chromosome size calculation
        self.path_genes = NUM_AGENTS * NUM_WAYPOINTS
        self.power_genes = NUM_AGENTS
        self.topology_genes = NUM_AGENTS * (NUM_AGENTS - 1) // 2
        self.chromosome_size = self.path_genes + self.power_genes + self.topology_genes
        
        # Initialize fitness evaluator
        self.fitness_evaluator = FitnessEvaluator()
        
        # Population & stats
        self.population = None
        self.fitness_scores = None
        self.best_individual = None
        self.best_fitness = float('inf')
        
        self.generation_history = []
        self.best_fitness_history = []
        self.avg_fitness_history = []
        
        # Ensure output directory exists
        os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    def initialize_population(self) -> np.ndarray:
        """
        Random popülasyon oluştur
        
        Returns:
            Population (population_size x chromosome_size)
        """
        population = np.random.rand(self.population_size, self.chromosome_size)
        return population
    
    def evaluate_population(self, population: np.ndarray) -> np.ndarray:
        """
        Popülasyondaki tüm bireyleri değerlendir
        
        Args:
            population: Population array
        
        Returns:
            Fitness scores array
        """
        fitness_scores = np.zeros(len(population))
        
        for i, individual in enumerate(population):
            fitness_scores[i] = self.fitness_evaluator.evaluate(individual)
        
        return fitness_scores
    
    def select_best(self, population: np.ndarray, 
                   fitness_scores: np.ndarray,
                   elite_size: int = GA_ELITE_SIZE) -> Tuple[np.ndarray, np.ndarray]:
        """
        En iyi bireyleri seç (elitism)
        
        Args:
            population: Population array
            fitness_scores: Fitness scores
            elite_size: Kaç tane en iyi birey saklayalım
        
        Returns:
            (best_individuals, best_fitness_scores)
        """
        best_indices = np.argsort(fitness_scores)[:elite_size]
        return population[best_indices], fitness_scores[best_indices]
    
    def create_offspring(self, population: np.ndarray,
                        fitness_scores: np.ndarray,
                        num_offspring: int) -> np.ndarray:
        """
        Crossover ve mutation ile offspring oluştur
        
        Args:
            population: Current population
            fitness_scores: Fitness scores
            num_offspring: Kaç offspring oluşturmalıyız
        
        Returns:
            Offspring population
        """
        offspring = []
        
        for _ in range(num_offspring):
            # Selection (tournament)
            parent1 = GAOperators.tournament_selection(
                population, 
                fitness_scores, 
                GA_TOURNAMENT_SIZE
            )
            parent2 = GAOperators.tournament_selection(
                population, 
                fitness_scores, 
                GA_TOURNAMENT_SIZE
            )
            
            # Crossover
            child = GAOperators.crossover(
                parent1, parent2,
                NUM_AGENTS, NUM_WAYPOINTS
            )
            
            # Mutation
            child = GAOperators.mutate(
                child,
                NUM_AGENTS, NUM_WAYPOINTS,
                rate=self.mutation_rate
            )
            
            offspring.append(child)
        
        return np.array(offspring)
    
    def run(self) -> dict:
        """
        GA'yı çalıştır
        
        Returns:
            Best solution and statistics
        """
        
        print("=" * 60)
        print(f"Swarm GA Optimization - Starting")
        print(f"Population: {self.population_size}")
        print(f"Generations: {self.generations}")
        print(f"Chromosome Size: {self.chromosome_size}")
        print("=" * 60)
        
        # Initialize population
        self.population = self.initialize_population()
        print(f"\n[Init] Created population of {self.population_size} individuals")
        
        # Main GA loop
        for generation in range(self.generations):
            # Evaluate
            self.fitness_scores = self.evaluate_population(self.population)
            
            # Track best
            best_idx = np.argmin(self.fitness_scores)
            best_fitness = self.fitness_scores[best_idx]
            avg_fitness = np.mean(self.fitness_scores)
            
            if best_fitness < self.best_fitness:
                self.best_fitness = best_fitness
                self.best_individual = self.population[best_idx].copy()
            
            # Log
            self.best_fitness_history.append(self.best_fitness)
            self.avg_fitness_history.append(avg_fitness)
            self.generation_history.append(generation)
            
            if (generation + 1) % 10 == 0 or generation == 0:
                print(f"[Gen {generation:3d}] Best: {self.best_fitness:.4f} | "
                      f"Current: {best_fitness:.4f} | Avg: {avg_fitness:.4f}")
            
            # Selection (elitism)
            elite_pop, elite_fitness = self.select_best(
                self.population, 
                self.fitness_scores, 
                GA_ELITE_SIZE
            )
            
            # Create offspring
            num_offspring = self.population_size - GA_ELITE_SIZE
            offspring = self.create_offspring(
                self.population, 
                self.fitness_scores, 
                num_offspring
            )
            
            # Create new population
            self.population = np.vstack([elite_pop, offspring])
        
        # Final evaluation
        self.fitness_scores = self.evaluate_population(self.population)
        best_idx = np.argmin(self.fitness_scores)
        if self.fitness_scores[best_idx] < self.best_fitness:
            self.best_fitness = self.fitness_scores[best_idx]
            self.best_individual = self.population[best_idx].copy()
        
        print("\n" + "=" * 60)
        print(f"GA Completed! Best Fitness: {self.best_fitness:.4f}")
        print(f"Total Evaluations: {self.fitness_evaluator.evaluation_count}")
        print("=" * 60)
        
        return {
            'best_individual': self.best_individual,
            'best_fitness': self.best_fitness,
            'best_fitness_history': self.best_fitness_history,
            'avg_fitness_history': self.avg_fitness_history,
            'generation_history': self.generation_history,
        }
    
    def save_results(self, results: dict):
        """
        Sonuçları dosyaya kaydet
        
        Args:
            results: GA results dictionary
        """
        
        # Save best individual
        best_ind_file = os.path.join(OUTPUT_DIR, 'best_individual.json')
        with open(best_ind_file, 'w') as f:
            json.dump({
                'best_fitness': float(results['best_fitness']),
                'best_individual': results['best_individual'].tolist(),
                'chromosome_size': self.chromosome_size,
            }, f, indent=2)
        print(f"✓ Saved best individual to {best_ind_file}")
        
        # Save fitness history
        history_file = os.path.join(OUTPUT_DIR, 'fitness_history.csv')
        with open(history_file, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['Generation', 'Best_Fitness', 'Avg_Fitness'])
            for gen, best, avg in zip(
                results['generation_history'],
                results['best_fitness_history'],
                results['avg_fitness_history']
            ):
                writer.writerow([gen, f"{best:.4f}", f"{avg:.4f}"])
        print(f"✓ Saved fitness history to {history_file}")
    
    def get_best_solution_info(self) -> dict:
        """
        En iyi çözümü decode et ve bilgi döndür
        """
        from fitness import FitnessEvaluator
        
        evaluator = FitnessEvaluator()
        paths, power, topology = evaluator._decode_chromosome(self.best_individual)
        
        return {
            'fitness': float(self.best_fitness),
            'agent_paths': paths,
            'power_levels': [float(p) for p in power],
            'comm_topology': topology,
        }


# Main execution
if __name__ == "__main__":
    import random
    
    # Set random seed for reproducibility
    random.seed(RANDOM_SEED)
    np.random.seed(RANDOM_SEED)
    
    # Create and run GA
    ga = GeneticAlgorithm(
        population_size=GA_POPULATION_SIZE,
        generations=GA_GENERATIONS,
        mutation_rate=GA_MUTATION_RATE
    )
    
    results = ga.run()
    ga.save_results(results)
    
    # Print best solution info
    best_info = ga.get_best_solution_info()
    print("\n" + "=" * 60)
    print("BEST SOLUTION DETAILS")
    print("=" * 60)
    print(f"Fitness Score: {best_info['fitness']:.4f}")
    print(f"\nAgent Paths:")
    for agent_id, path in enumerate(best_info['agent_paths']):
        print(f"  Agent {agent_id}: {' → '.join(map(str, path))}")
    print(f"\nPower Levels:")
    for agent_id, power in enumerate(best_info['power_levels']):
        print(f"  Agent {agent_id}: {power:.3f}")
    print(f"\nCommunication Topology:")
    for link in best_info['comm_topology'][:5]:  # Show first 5
        print(f"  {link[0]} ↔ {link[1]}")
    if len(best_info['comm_topology']) > 5:
        print(f"  ... and {len(best_info['comm_topology']) - 5} more links")
    print("=" * 60)
