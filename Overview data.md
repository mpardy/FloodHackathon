# FloodTraces Hackathon — Dataset Overview

Full documentation and data access (Zenodo, registration required):
<https://pietrostefani.github.io/floodtraces-hack/datasets.html>

The datasets fall into four categories: **Meta/Facebook** mobility data, **IOM** survey data, **contextual** datasets (population, deprivation, flood extent, rainfall, vegetation), and **spatial boundary** files.

> **Key note on geographies:** The Meta and IOM datasets use *different* administrative systems — GADM and OCHA p-codes respectively. They cannot be joined directly without a crosswalk.

---

## 1. Meta / Facebook — Human Mobility (Digital Traces)

Meta provides these data through the [Data for Good](https://dataforgood.facebook.com/) programme in the aftermath of humanitarian disasters. Data are available to researchers for **90 days** after upload, and cover user counts and flows at two spatial scales: 800 m tiles (quadkeys) and GADM administrative level 2.

Each event includes:

- **Population during crisis** — stock counts of Facebook users per spatial unit at three daily snapshots (00:00, 08:00, 16:00 Pacific Time). Cells with fewer than 10 observations are suppressed.
- **Movement during crisis** — origin–destination flows between 8-hour windows. Only 08:00 and 16:00 periods available for Pakistan; 00:00 is missing. Flows with fewer than 10 observations are suppressed.

Both datasets include a baseline period for comparison, with raw differences, percentage differences, and z-scores.

**Table 1. Facebook data: flood events and coverage periods**

| Event | Period covered | Baseline date |
|---|---|---|
| 2022 floods (majority of Pakistan) | 14 August – 7 September 2022 | 30 June 2022 |
| 2025 floods — Punjab province | 19 August – 28 August 2025 | 5 July 2025 |
| 2025 floods — Sindh province | 21 August – 1 September 2025 | 7 July 2025 |

**Table 2. Facebook dataset summary**

| Dataset | Spatial resolution | Spatial join key | Format | Known gaps |
|---|---|---|---|---|
| Population during crisis (aggregated) | GADM level 2 | polygon_id → GID_2 | CSV | Aggregated pop missing 20–22 Aug 2022; not available for 2025 Karachi |
| Population during crisis (tiled) | 800 m tiles (quadkeys) | quadkey → quadkey | CSV | — |
| Movement during crisis (aggregated) | GADM level 2 | start/end_polygon_id → GID_2 | CSV | 00:00 period missing for all Pakistan events |
| Movement during crisis (tiled) | 800 m tiles (quadkeys) | start/end_quadkey → quadkey | CSV | 00:00 period missing for all Pakistan events |

**Guide for using these data in R:** <https://fcorowe.github.io/dfd4mobility/>

---

## 2. IOM — Human Mobility (Survey Data)

The IOM Displacement Tracking Matrix (DTM) collects **Community Needs Identification (CNI)** data via key informant interviews and direct observation. Data are published in rounds and provide estimates of temporarily displaced persons (TDPs), returnees, and related variables at the village/settlement level.

> Coverage and variable names vary across rounds. Province and district codes use OCHA p-codes (not GADM) — join to OCHA subnational polygons using `ADM1_PCODE` and `ADM2_PCODE`.

**Table 3. IOM CNI data rounds**

| Round | Period | Geographic coverage | Spatial resolution | Join key |
|---|---|---|---|---|
| Round 1 | Nov – Dec 2022 | National | Village / settlement, Tehsil, District, Province | ADM1_PCODE / ADM2_PCODE → OCHA polygons |
| Round 2 | Jan – Mar 2023 | National | Village / settlement, Tehsil, District, Province | ADM1_PCODE / ADM2_PCODE → OCHA polygons |
| Round 3 (×3 provinces) | May – Jun 2023 | Balochistan, KPK, Sindh (separate reports) | Village / settlement, Tehsil, District, Province | ADM1_PCODE / ADM2_PCODE → OCHA polygons |
| Round 4 (×3 provinces) | August 2023 | Balochistan, KPK, Sindh (separate reports) | Village / settlement, Tehsil, District, Province | ADM1_PCODE / ADM2_PCODE → OCHA polygons |
| Round 6 | August 2024 | Balochistan and KPK | Village / settlement, Tehsil, District, Province | ADM1_PCODE / ADM2_PCODE → OCHA polygons |
| Round 7 | Sep – Oct 2025 | Punjab | Village / settlement, Tehsil, District, Province | ADM1_PCODE / ADM2_PCODE → OCHA polygons |

---

## 3. Contextual Data

Contextual datasets provide background on population distribution, socioeconomic conditions, flood extent, rainfall, and vegetation for Pakistan.

**Table 4. Contextual datasets**

| Dataset | Provider | Spatial resolution | Temporal coverage | Format | Join key |
|---|---|---|---|---|---|
| WorldPop population (raster) | WorldPop / OCHA | 100 m raster | 2020 estimate | GeoTIFF | — |
| WorldPop population by age & sex (raster) | WorldPop / OCHA | 100 m raster (one file per age/sex group) | 2020 estimate | GeoTIFF | — |
| WorldPop aggregated population | Project team | GADM adm2; OCHA adm1 & adm2 | 2020 estimate | CSV | GID_2 or ADM1/2_PCODE |
| Global Relative Deprivation Index (GRDI) | SEDAC / NASA | 1 km raster; aggregated to GADM adm2 & OCHA adm1/adm2 | Static index | GeoTIFF / CSV | GID_2 or ADM1/2_PCODE |
| Satellite flood extent — 2022 (UNOSAT) | UNOSAT | Polygon shapefiles | 1–29 Aug 2022 | Shapefile | — |
| Satellite flood extent — 2025 (UNOSAT) | UNOSAT | Polygon shapefiles | 26 Aug – 7 Sep 2025 | Shapefile | — |
| NASA GPM daily rainfall (raster) | NASA GPM | 10 km raster | 1 Jul – 7 Sep 2022 & 2025 | Raster | — |
| WFP dekadal rainfall | WFP | District (OCHA adm2) | 2022–present (10-day intervals) | CSV | ADM2_PCODE |
| WFP dekadal NDVI | WFP | District (OCHA adm2) | 2022–present (10-day intervals) | CSV | ADM2_PCODE |

**Notes:**

- GRDI values range from 0–100; higher values indicate greater relative deprivation. Full documentation: <https://sedac.ciesin.columbia.edu/downloads/docs/povmap/povmap-grdi-v1-documentation.pdf>
- WorldPop age/sex files follow the naming convention: `{iso}_{gender}_{age_group}_{year}_{type}_{resolution}.tif` (e.g. `pak_f_05_2020_constrained_100m.tif` for Pakistani females aged 5–9).
- NDVI is the Normalised Difference Vegetation Index — used here as a proxy for agricultural and ecological disruption.

---

## 4. Spatial Boundaries

Three boundary systems are in use across the datasets. Selecting the right boundary file for each join is critical.

**Table 5. Spatial boundary files and join keys**

| Boundary file | Source | Format | Join key | Used with |
|---|---|---|---|---|
| GADM polygons (adm0–adm3) | GADM | Shapefile / GeoPackage | GID_2 | Facebook aggregated data; WorldPop & GRDI (gadm_2) |
| OCHA subnational polygons (adm1–adm3) | OCHA / HDX | Shapefile | ADM1_PCODE / ADM2_PCODE | IOM CNI data; WorldPop & GRDI (ocha_1/2); WFP rainfall & NDVI |
| Quadkey polygons (800 m tiles) | Project team (from Meta, via quadkeyr R package) | Shapefile | quadkey | Facebook tiled Population & Movement data |

> **Important:** The IOM CNI geography (OCHA p-codes) and the Facebook aggregated geography (GADM) do **not** align. Linking these two datasets requires a spatial crosswalk or areal interpolation.

---

## Quick Reference: Dataset × Boundary

**Table 6. Quick reference: datasets and their spatial join keys**

| Group | Dataset | Spatial code in dataset | Boundary file | Boundary join key |
|---|---|---|---|---|
| **Facebook / Meta** | Population (aggregated) | polygon_id | GADM adm2 | GID_2 |
| | Population (tiled) | quadkey | Quadkey polygons | quadkey |
| | Movement (aggregated) | start/end_polygon_id | GADM adm2 | GID_2 |
| | Movement (tiled) | start/end_quadkey | Quadkey polygons | quadkey |
| **IOM** | CNI | ProvinceCode / DistrictCode (varies per round) | OCHA adm1 / adm2 | ADM1_PCODE / ADM2_PCODE |
| **Contextual** | WorldPop aggregated (gadm_2) | GID_2 | GADM adm2 | GID_2 |
| | WorldPop aggregated (ocha_1/2) | ADM1_PCODE / ADM2_PCODE | OCHA adm1 / adm2 | ADM1/2_PCODE |
| | GRDI aggregated (gadm_2) | GID_2 | GADM adm2 | GID_2 |
| | GRDI aggregated (ocha_1/2) | ADM1_PCODE / ADM2_PCODE | OCHA adm1 / adm2 | ADM1/2_PCODE |
| | WFP rainfall | ADM2_PCODE | OCHA adm2 | ADM2_PCODE |
| | WFP NDVI | ADM2_PCODE | OCHA adm2 | ADM2_PCODE |

---

*Source: [pietrostefani.github.io/floodtraces-hack/datasets.html](https://pietrostefani.github.io/floodtraces-hack/datasets.html)*
