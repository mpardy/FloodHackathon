# FloodTraces Hackathon 2026

## Notebook Structure

01_GRDI_Exploration └─ District-level deprivation analysis

02_WorldPop_Population └─ Population exposure analysis

03_Vulnerability_Index Inputs: - GRDI - Population

Weights: - GRDI_WEIGHT = 0.50 - POP_WEIGHT = 0.50 #need to update

Output: - Vulnerability Index - Vulnerability Map - Top Vulnerable Districts

04_Flood_Exposure Inputs: - Flood Extent (2022 / 2025) - District Boundaries

Output: - Flooded Area per District - Flood Exposure Layer

05_Priority_Index Inputs: - Vulnerability Index - Flood Exposure

Weights: - VULNERABILITY_WEIGHT = 0.50 - FLOOD_WEIGHT = 0.50 #need to update

Output: - Flood-Exposed Vulnerability - Priority District Map - Top Priority Districts

06_Mobility_Analysis Inputs: - Meta Population - Meta Mobility

Output: - Mobility Anomaly Index - Early Movement Signals

07_Humanitarian_Stress_Index Inputs: - Priority Index - Mobility Anomaly Index

Weights: - PRIORITY_WEIGHT = 0.50 - MOBILITY_WEIGHT = 0.50

Output: - Humanitarian Stress Index - Early Warning Districts



## Project

### Beyond Flood Maps: Anticipating Humanitarian Stress Through Mobility and Vulnerability Signals


Flood impacts often become visible in official displacement statistics only after humanitarian needs have already escalated. This project explores whether mobility anomalies, flood indicators, and vulnerability information can provide earlier signals of humanitarian stress and support anticipatory action.

---

## Research Question

Can digital trace data help identify districts at risk of severe displacement before official displacement statistics become available?

Can mobility anomalies act as an early warning indicator of humanitarian stress and displacement?

---

## Proposed Approaches

### Humanitarian Stress Index

Combine:

* Flood Severity
* Vulnerability

Output:

* Priority District Ranking
* Humanitarian Stress
* Early Warning Map

Workflow:

```text
Rainfall + Flood Extent
            +
      Meta Mobility
            +
 Population + GRDI
            ↓
 Humanitarian Stress Index
            ↓
  Priority Districts
```

---

### Mobility as an Early Warning Signal

Investigate whether unusual mobility patterns occur before displacement peaks.

Workflow:

```text
Flood Event
      ↓
Mobility Anomaly
      ↓
Displacement Peak
```

Question:

* Can mobility act as an early warning indicator?

---

## Possible Flowwork
```mermaid
flowchart TD

A[Pakistan Floods 2022/2025]

B[Rainfall<br>NASA GPM]
C[Flood Extent<br>UNOSAT]
D[Meta Mobility<br>Population & Movement]

A --> B
A --> C
A --> D

B --> E[Flood Severity Index]
C --> E

D --> F[Mobility Anomaly Index]

G[Population + GRDI] --> H[Vulnerability Index]

E --> I[Humanitarian Stress Indicators]
F --> I
H --> I

I --> J[Priority District Ranking]

J --> K[Early Warning Framework]

K --> L[Validation with IOM DTM]

L --> M[<br>Humanitarian Stress Map]
L --> N[<br>Mobility Pattern]

M --> O[Indicator / Situation Analysis]
N --> O

O --> P[District Prioritisation for Response]
```
## Available Data

| Dataset                       | Format         | Spatial Scale          |
| ----------------------------- | -------------- | ---------------------- |
| Meta Population During Crisis | CSV            | 800m Quadkeys / Admin2 |
| Meta Movement During Crisis   | CSV            | 800m Quadkeys / Admin2 |
| IOM DTM CNI                   | CSV/XLSX       | Village / District     |
| Flood Extent (UNOSAT)         | Shapefile      | Flood polygons         |
| Rainfall (NASA GPM)           | GeoTIFF Raster | 10 km                  |
| WFP Rainfall                  | CSV            | District               |
| WFP NDVI                      | CSV            | District               |
| WorldPop Population           | GeoTIFF Raster | 100 m                  |
| GRDI Deprivation              | GeoTIFF Raster | 1 km                   |
| GADM Boundaries               | Shapefile      | Admin Levels           |
| OCHA Boundaries               | Shapefile      | District / Tehsil      |

---

## Expected Deliverables ( Early Warning Framework )

### Mobility Anomaly Analysis
- Deliverable: District Priority Map
- Deliverable: 3D Animation vizulization

### Vulnerability Assessment
More concretely: Humanitarian Stress Index
-Deliverable: District Priority Map
- Deliverable: 3D Animation vizulization

  ## Sanity Checks
- Validation Against IOM DTM Data

  
- Final Hackathon Presentation

---

## Repository Structure

```text
data/
├── raw/
├── processed/

notebooks/

scripts/

outputs/
├── figures/
├── maps/
├── dashboard/

docs/
```

---

## Team Members

| Name | Role |
| ---- | ---- |
|  Munazza    |      |
|  Martina    |      |
|   Sebo |      |
|  Yaseen    |      |
|      |      |
