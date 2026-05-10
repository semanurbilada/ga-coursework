# 🚀 GA Coursework – Genetic Algorithms Projects (MATLAB)

Coursework for the **Genetic Algorithms** course, including both **midterm** and **final** projects implemented in MATLAB.

This repository demonstrates how genetic algorithms can be applied to:
- Solution representation (Gray Code)
- Custom fitness function design
- Real-world optimization problems

---

## 📌 Project Overview

### 🔹 Midterm Project
Focuses on fundamental GA concepts:
- Gray Code representation
- Basic and customized fitness functions
- MATLAB-based implementation and testing

---

### 🔹 Final Project  
**Computer Network Topology Optimization using Genetic Algorithms**

Main question:
> Where should computers be physically placed to minimize communication cost while maintaining connectivity?

Key features:
- Traffic-aware fitness function
- Connectivity and node separation constraints
- Scalable design (10, 20, 30 nodes)
- Visualization of convergence, topology, and distance distribution

---

## 📁 Project Structure

```
ga-coursework/
├── docs/
│   ├── GA-final_report.pdf
│   └── GA-midterm_report.pdf
│
├── midterm/
│   ├── fitness_simple.m
│   └── graycode.m
│
├── final/
│   ├── main.m
│   ├── fitness_network.m
│   └── visualize_results.m
│
├── experiments/
│   ├── fitness_basic.m
│   └── fitness_custom.m
│
├── lecture-codes/
│
├── outputs/
│   ├── convergence_plot_10nodes.png
│   ├── convergence_plot_20nodes.png
│   ├── convergence_plot_30nodes.png
│   ├── network_topology_10nodes.png
│   ├── network_topology_20nodes.png
│   └── network_topology_30nodes.png
│
├── .gitignore
└── README.md
```

---

## 📊 Results Summary

| Nodes | Behavior |
|------|----------|
| 10   | ✅ Compact and efficient topology |
| 20   | ⚠️ Partially stretched network |
| 30   | ❌ Connectivity violations increase |

🔍 Key Insight:
> A **single-gateway topology becomes insufficient** for larger networks, highlighting the need for more advanced structures such as multi-cluster or multi-gateway designs.

---

## 📈 Outputs

The project generates:
- GA convergence plots
- Optimized network topology graphs
- Distance distribution histograms

All outputs are available in the `/outputs` directory.

---

## 🧠 Key Contribution

- Scalable GA-based optimization model
- Integration of network-aware fitness function
- Analysis of limitations in large-scale networks

---

## 📎 Reports

- Midterm Report → `/docs/GA-midterm_report.pdf`
- Final Report → `/docs/GA-final_report.pdf`

---

## ✅ Summary

This repository covers the full progression from fundamental genetic algorithm concepts to real-world network optimization problems, demonstrating both the effectiveness and limitations of GA-based approaches.
