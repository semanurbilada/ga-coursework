# Swarm Network Optimization using Genetic Algorithm (SNOG)

Master tezi için genetik algoritma tabanlı sürü robot optimizasyonu projesi.

## Proje Özeti

Bu proje N drone'un sürü halinde haberleşmesini, yol planlamasını ve enerji tüketimini **aynı anda optimize** etmektedir:

- **Problem:** 3 drone 5 waypoint'i ziyaret edecek, haberleşme kalitesi korunmalı, enerji minimal
- **Çözüm:** Genetik Algoritma (GA) ile multi-objective optimization
- **Sonuç:** Optimal yol planı + haberleşme topolojisi + enerji seviyeleri

## Proje Yapısı

```
swarm-ga-optimization/
├── config.py              # Hyperparametreler ve ayarlar
├── simulator.py           # Drone fiziği + haberleşme simülasyonu
├── fitness.py             # Chromosom → fitness fonksiyonu
├── ga_operators.py        # Selection, Crossover, Mutation
├── main.py                # GA ana döngüsü (ÇEKİRDEK)
├── visualization.py       # 2D animasyon ve grafikler
├── results/               # Çıktı dosyaları
│   ├── best_individual.json
│   ├── fitness_history.csv
│   ├── solution_visualization.png
│   └── fitness_convergence.png
└── README.md
```

## Kurulum

### 1. Gerekli Kütüphaneler
```bash
pip install numpy matplotlib --break-system-packages
```

### 2. Projeyi Klonla/İndir
```bash
cd swarm-ga-optimization
```

## Kullanım

### Başlangıç (GA'yı Çalıştır)
```bash
python main.py
```

**Beklenen çıktı:**
```
============================================================
Swarm GA Optimization - Starting
Population: 50
Generations: 100
Chromosome Size: 33
============================================================

[Init] Created population of 50 individuals
[Gen   0] Best: 85.2345 | Current: 85.2345 | Avg: 125.4532
[Gen  10] Best: 72.5432 | Current: 78.1234 | Avg: 98.3421
[Gen  20] Best: 65.4321 | Current: 66.7890 | Avg: 85.2134
...
[Gen  99] Best: 45.1234 | Current: 47.5678 | Avg: 62.3456

============================================================
GA Completed! Best Fitness: 45.1234
Total Evaluations: 5050
============================================================

BEST SOLUTION DETAILS
============================================================
Fitness Score: 45.1234

Agent Paths:
  Agent 0: 0 → 1 → 2 → 3 → 4
  Agent 1: 0 → 2 → 4 → 1 → 3
  Agent 2: 0 → 3 → 1 → 4 → 2

Power Levels:
  Agent 0: 0.825
  Agent 1: 0.673
  Agent 2: 0.921

Communication Topology:
  0 ↔ 1
  1 ↔ 2
  2 ↔ 0
  ... and 2 more links
============================================================
```

### Sonuçları Görselleştir
```bash
python visualization.py
```

**Çıktılar:**
- `results/solution_visualization.png` - Drone yolları + waypoint'ler
- `results/fitness_convergence.png` - GA convergence grafiği

## Chromosom Yapısı

Çözüm şu şekilde kodlanır:

```
Chromosome = [Path_Genes | Power_Genes | Topology_Genes]

Path_Genes:        (15 değer) 3 agent × 5 waypoint permutasyonu
Power_Genes:       (3 değer)  Her agent için güç seviyesi [0-1]
Topology_Genes:    (3 değer)  Haberleşme bağlantıları (binary)

Örnek: [0.1, 0.5, 0.8, 0.2, 0.9, ... | 0.82, 0.67, 0.92 | 0.9, 0.1, 0.8]
```

## GA Parametreleri

`config.py`'da tüm ayarlar vardır:

```python
# GA Parameters
GA_POPULATION_SIZE = 50          # Popülasyon büyüklüğü
GA_GENERATIONS = 100             # Jenerasyon sayısı
GA_MUTATION_RATE = 0.2           # Mutasyon olasılığı
GA_TOURNAMENT_SIZE = 3           # Tournament selection boyutu
GA_ELITE_SIZE = 5                # Elitism: en iyi kaçını saklayalım

# Fitness Weights
W_TIME = 0.3                     # Zaman ağırlığı
W_ENERGY = 0.3                   # Enerji ağırlığı
W_LATENCY = 0.2                  # Gecikme ağırlığı
W_COMM_FAILURES = 0.2            # Başarısızlık ağırlığı
```

## Özelleştirme Rehberi

### 1. Agent/Waypoint Sayısı Değiştir
```python
# config.py
NUM_AGENTS = 5        # 3'ten 5'e çık
NUM_WAYPOINTS = 8     # 5'ten 8'e çık

# Waypoint konumlarını ekle/değiştir
WAYPOINT_POSITIONS = [
    (50, 50), (450, 50), (450, 450), (50, 450), (250, 250),
    (150, 150), (350, 350), (300, 100)  # Yeni waypoint'ler
]
```

### 2. Fitness Ağırlıklarını Ayarla
```python
# config.py - Enerjiyi daha önemli yap
W_TIME = 0.2
W_ENERGY = 0.5         # Arttı
W_LATENCY = 0.15
W_COMM_FAILURES = 0.15
```

### 3. GA Parametrelerini Tune Et
```python
# config.py - Daha uzun ve daha büyük GA
GA_POPULATION_SIZE = 100         # Daha fazla birey
GA_GENERATIONS = 200             # Daha fazla jenerasyon
GA_MUTATION_RATE = 0.15          # Daha az mutation (exploitation)
GA_TOURNAMENT_SIZE = 5           # Daha seçici tournament
```

### 4. Haberleşme Modelini Değiştir
```python
# simulator.py - _simulate_communication() metodunda
# Örneğin, haberleşme menzilini artır
MAX_COMMUNICATION_RANGE = 300.0  # 200'den 300'e

# Paket kaybı modelini değiştir
loss_probability = 0.01 + (distance / MAX_COMMUNICATION_RANGE) * 0.05  # Daha az kaybı
```

### 5. Simulasyon Süresini Arttır
```python
# config.py
MAX_SIMULATION_TIME = 200         # 100'den 200'e (çalışma süresi artar)
```

## Beklenen Sonuçlar

100 jenerasyon sonra:
- **Fitness iyileşmesi:** İlk ~120 → Son ~45 (62% iyileşme)
- **Convergence:** 80-90 jenerasyonda stabil
- **Çalışma süresi:** ~20-30 sn (3 agent, 5 waypoint)

## Kod Detayları

### Fitness Function
```
Fitness = 0.3×TravelTime + 0.3×Energy + 0.2×Latency + 0.2×CommFailures
```

- **TravelTime:** Tüm agentlerin total seyahat süresi
- **Energy:** Tüm agentlerin toplam enerji tüketimi
- **Latency:** Haberleşme gecikmesi toplamı
- **CommFailures:** Başarısız mesaj sayısı (cezalandırılır)

### GA Operatörleri

**Selection:** Tournament selection (k=3)
- 3 rasgele birey seç → en iyisini al

**Crossover:** Hibrid
- Paths: Order Crossover (OX) - yol sırası korunur
- Power: Uniform - rastgele her gen al
- Topology: Uniform - rastgele her bağlantı al

**Mutation:** Hibrid
- Paths: Swap mutation - iki waypoint'i değiştir
- Power: Gaussian mutation - N(0, 0.1) ekle
- Topology: Bit flip - bağlantı toggle et

## Sorun Giderme

### Problem: "Module not found" hatası
```
ModuleNotFoundError: No module named 'numpy'
```
**Çözüm:**
```bash
pip install numpy --break-system-packages
```

### Problem: Fitness değeri `inf` (sonsuz)
**Sebep:** Path validasyonu başarısız (duplicate waypoint)
**Çözüm:** `fitness.py`'da `_validate_paths()` kontrol et

### Problem: GA çok yavaş
**Çözüm:** Parametreleri düşür
```python
GA_POPULATION_SIZE = 30
GA_GENERATIONS = 50
MAX_SIMULATION_TIME = 50
```

## İleri Konular (Bonus)

### 1. Multi-Objective Optimization (Pareto Front)
```python
# NSGA-II algoritmasını implement et
# Fitness yerine Pareto ranking kullan
```

### 2. Dinamik Waypoint'ler
```python
# Waypoint'leri simülasyon sırasında hareket ettir
```

### 3. Gerçek Haberleşme Modeli
```python
# UDP trace kullanarak gerçekçi latency/loss model
```

### 4. Parallel Evaluation
```python
# multiprocessing ile fitness evaluasyonu hızlandır
```

## Referanslar

- Michalewicz, Z. (1996). Genetic Algorithms + Data Structures = Evolution Programs
- Deb, K., Pratap, A., Agarwal, S., & Meyarivan, T. (2002). A fast and elitist multiobjective genetic algorithm: NSGA-II
- Dorigo, M., & Blum, C. (2005). Ant colony optimization theory

## Lisans

Eğitim amacıyla açık kaynak.

## Sorular / İletişim

Kod ile ilgili sorular varsa, `config.py` ve `main.py`'yi önce inceleyip, 
sonra `fitness.py` ve `simulator.py`'ye bakın.

---

**Başarılar! 🚀**
