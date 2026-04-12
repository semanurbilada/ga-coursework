# ⚡ Quick Start - 5 Dakika Başlangıç

## 1. Kurulum (30 saniye)
```bash
cd swarm-ga-optimization
pip install -r requirements.txt --break-system-packages
```

## 2. GA'yı Çalıştır (20 saniye)
```bash
python main.py
```

Beklenen çıktı:
```
============================================================
Swarm GA Optimization - Starting
...
[Gen   0] Best: 937.5666 | Current: 937.5666 | Avg: 4598.2982
[Gen  10] Best: 456.3716 | Current: 549.7339 | Avg: 2841.8732
[Gen  99] Best: 119.3354 | Current: 178.0053 | Avg: 1111.7320

GA Completed! Best Fitness: 119.3354
============================================================
```

✅ **Başarılı!** Sonuçlar `results/` klasöründe kaydedildi.

## 3. Sonuçları Görüntüle
```bash
python visualization.py
```

## Dosya Yapısı Kısaca

| Dosya | Görev |
|-------|-------|
| `config.py` | 📋 Tüm ayarlar (agent sayısı, waypoint'ler, fitness ağırlıkları) |
| `simulator.py` | 🚁 Drone fiziği + haberleşme modeli |
| `fitness.py` | 📊 Chromosom'u fitness'e çevir |
| `ga_operators.py` | 🧬 Selection, Crossover, Mutation |
| `main.py` | 🎯 GA ana döngüsü (ÇEKİRDEK) |
| `visualization.py` | 📈 Grafikler + animasyon |

## Kod Akışı (3 Adım)

```
1. main.py çalıştırıldı
   ↓
2. GA popülasyonunu oluştur → 100 jenerasyon evolve et
   ├─ fitness.py → Her chromosom'u değerlendir
   ├─ simulator.py → Drone fiziğini simüle et  
   └─ ga_operators.py → Selection/Crossover/Mutation yap
   ↓
3. Best solution → results/ klasöründe kaydet
```

## 5 Dakikalık Değişiklikler

### Değişiklik 1: Daha Fazla Agent
```python
# config.py satır 8
NUM_AGENTS = 5  # 3'ten 5'e çık
```
→ **Etkisi:** Daha karmaşık problem, daha uzun çalışma

### Değişiklik 2: Daha Fazla Jenerasyon (Daha İyi Sonuç)
```python
# config.py satır 11
GA_GENERATIONS = 200  # 100'den 200'e çık
```
→ **Etkisi:** ~40 sn çalışma süresi, %10 daha iyi fitness

### Değişiklik 3: Enerji Önemli
```python
# config.py satır 22
W_ENERGY = 0.5  # 0.3'ten 0.5'e çık
```
→ **Etkisi:** GA enerjiyi daha önemseyecek

### Değişiklik 4: Daha Hızlı Sonuç (Test için)
```python
# config.py satırlar 8, 11, 14
NUM_AGENTS = 2
GA_GENERATIONS = 30
MAX_SIMULATION_TIME = 50
```
→ **Etkisi:** ~3 sn çalışma süresi (prototip test)

## Sonuçları Anla

### results/best_individual.json
```json
{
  "best_fitness": 119.33,      # Düşük = İyi
  "best_individual": [...],    # 21 sayı (chromosom)
  "chromosome_size": 21
}
```

### results/fitness_history.csv
```csv
Generation,Best_Fitness,Avg_Fitness
0,937.5666,4598.2982
1,594.3186,4026.5706
...
99,119.3354,1111.7320
```
→ **Fitness azalıyor** = GA çalışıyor! ✅

## Örnek Sonuçlar Açıklaması

```
Agent Paths:
  Agent 0: 4 → 1 → 3 → 0 → 2
  Agent 1: 0 → 4 → 1 → 3 → 2
  Agent 2: 2 → 4 → 1 → 0 → 3

→ Agent 0 waypoint 4'te başlıyor, 
  sonra 1, 3, 0, 2 sırasıyla ziyaret ediyor
```

```
Power Levels:
  Agent 0: 0.024
  Agent 1: 0.062
  Agent 2: 0.061

→ Agent 0 düşük güçle enerji tasarruf ediyor
  (uzak hedefler veya kısa mesafeler)
```

## Sık Sorulan Sorular

### S: Fitness değeri nedir?
**C:** Daha düşük = daha iyi. Hedef minimize etmek.

### S: GA neden durursa?
**C:** Jenerasyon 100'e ulaştı. `GA_GENERATIONS` arttır.

### S: Sonuçlar farklı niye?
**C:** Random initialization. `RANDOM_SEED` sabit olursa tekrarlanır.

### S: Daha iyi sonuç için?
**C:** Parametreleri ayarla:
- `GA_POPULATION_SIZE = 100` (daha geniş arama)
- `GA_GENERATIONS = 200` (daha derin arama)
- `GA_MUTATION_RATE = 0.1` (daha az random)

### S: Çalışma süresi çok uzun?
**C:** Parametreleri düşür (bkz Değişiklik 4)

## Aşağıdaki Adımlar

1. **README.md** oku (detaylı açıklama)
2. **config.py** değiştir (kendi probleminize göre)
3. **main.py** çalıştır
4. **results/** klasörünü incele

## İletişim / Debug

Eğer hata varsa:
1. `pip install numpy matplotlib --break-system-packages` tekrar çalıştır
2. `python simulator.py` test et (simulator çalışıyor mu?)
3. `python fitness.py` test et (fitness çalışıyor mu?)
4. `python ga_operators.py` test et (GA operatörleri çalışıyor mu?)

Hepsi pass ise `python main.py` çalışır!

---

**İyi Eğlenceler! 🚀**
