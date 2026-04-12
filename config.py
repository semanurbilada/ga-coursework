# ============================================
# Configuration - Tüm Hyperparametreler
# ============================================

# GA Parameters
GA_POPULATION_SIZE = 50
GA_GENERATIONS = 100
GA_MUTATION_RATE = 0.2
GA_TOURNAMENT_SIZE = 3
GA_ELITE_SIZE = 5  # Elitism: en iyi 5'i sonraki nesilye taşı

# Swarm Parameters
NUM_AGENTS = 3  # Drone sayısı
NUM_WAYPOINTS = 5  # Ziyaret edilecek waypoint sayısı
MAX_SIMULATION_TIME = 100  # Simulasyon süresi (zaman adımı)
AGENT_MAX_SPEED = 10.0  # Maksimum drone hızı

# Communication Parameters
MAX_COMMUNICATION_RANGE = 200.0  # Haberleşme menzili (meter)
BASE_PACKET_LOSS = 0.01  # Taban paket kaybı oranı
COMMUNICATION_PROCESSING_DELAY = 1.0  # İşlem gecikmesi (ms)

# Fitness Weights (Multi-objective)
W_TIME = 0.3  # Seyahat süresi ağırlığı
W_ENERGY = 0.3  # Enerji tüketimi ağırlığı
W_LATENCY = 0.2  # Haberleşme gecikmesi ağırlığı
W_COMM_FAILURES = 0.2  # Haberleşme başarısızlığı ağırlığı

# World Parameters
WORLD_SIZE = 500  # Dünya boyutu (500x500 grid)
WAYPOINT_POSITIONS = [
    (50, 50),    # Waypoint 0
    (450, 50),   # Waypoint 1
    (450, 450),  # Waypoint 2
    (50, 450),   # Waypoint 3
    (250, 250),  # Waypoint 4 (merkez)
]

# Visualization Parameters
ANIMATION_INTERVAL = 100  # ms (animasyon frame hızı)
FIGURE_DPI = 100
FIGURE_SIZE = (12, 8)

# Random seed (reproduktivite için)
RANDOM_SEED = 42

# Output
OUTPUT_DIR = "results"
