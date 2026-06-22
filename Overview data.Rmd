
---
title: "FloodTraces Hackathon — Dataset Overview"
date: "`r format(Sys.Date(), '%d %B %Y')`"
output:
  html_document:
    theme: flatly
    toc: true
    toc_float: true
    toc_depth: 2
    df_print: kable
  pdf_document:
    toc: true
    toc_depth: 2
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE, message = FALSE, warning = FALSE)
library(knitr)
library(kableExtra)
```

This document summarises the datasets available for the FloodTraces Hackathon. Full documentation and data access (Zenodo, registration required) can be found at: <https://pietrostefani.github.io/floodtraces-hack/datasets.html>.

The datasets fall into four categories: **Meta/Facebook** mobility data, **IOM** survey data, **contextual** datasets (population, deprivation, flood extent, rainfall, vegetation), and **spatial boundary** files.

> **Key note on geographies:** The Meta and IOM datasets use *different* administrative systems — GADM and OCHA p-codes respectively. They cannot be joined directly without a crosswalk.

---

## 1. Meta / Facebook — Human Mobility (Digital Traces)

Meta provides these data through the [Data for Good](https://dataforgood.facebook.com/) programme in the aftermath of humanitarian disasters. Data are available to researchers for **90 days** after upload, and cover user counts and flows at two spatial scales: 800 m tiles (quadkeys) and GADM administrative level 2.

Each event includes:

- **Population during crisis** — stock counts of Facebook users per spatial unit at three daily snapshots (00:00, 08:00, 16:00 Pacific Time). Cells with fewer than 10 observations are suppressed.
- **Movement during crisis** — origin–destination flows between 8-hour windows. Only 08:00 and 16:00 periods available for Pakistan; 00:00 is missing. Flows with fewer than 10 observations are suppressed.

Both datasets include a baseline period for comparison, with raw differences, percentage differences, and z-scores.

```{r meta-events}
meta_events <- data.frame(
  Event = c(
    "2022 floods (majority of Pakistan)",
    "2025 floods — Punjab province",
    "2025 floods — Sindh province"
  ),
  `Period covered` = c(
    "14 August – 7 September 2022",
    "19 August – 28 August 2025",
    "21 August – 1 September 2025"
  ),
  `Baseline date` = c(
    "30 June 2022",
    "5 July 2025",
    "7 July 2025"
  ),
  check.names = FALSE
)

kable(meta_events, caption = "Table 1. Facebook data: flood events and coverage periods") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"), full_width = TRUE) %>%
  column_spec(1, bold = TRUE)
```

```{r meta-datasets}
meta_data <- data.frame(
  Dataset = c(
    "Population during crisis (aggregated)",
    "Population during crisis (tiled)",
    "Movement during crisis (aggregated)",
    "Movement during crisis (tiled)"
  ),
  `Spatial resolution` = c(
    "GADM level 2",
    "800 m tiles (quadkeys)",
    "GADM level 2",
    "800 m tiles (quadkeys)"
  ),
  `Spatial join key` = c(
    "polygon_id → GID_2",
    "quadkey → quadkey",
    "start/end_polygon_id → GID_2",
    "start/end_quadkey → quadkey"
  ),
  Format = c("CSV", "CSV", "CSV", "CSV"),
  `Known gaps` = c(
    "Aggregated pop missing 20–22 Aug 2022; not available for 2025 Karachi",
    "—",
    "00:00 period missing for all Pakistan events",
    "00:00 period missing for all Pakistan events"
  ),
  check.names = FALSE
)

kable(meta_data, caption = "Table 2. Facebook dataset summary") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"), full_width = TRUE) %>%
  column_spec(1, bold = TRUE)
```

**Guide for using these data in R:** <https://fcorowe.github.io/dfd4mobility/>

---

## 2. IOM — Human Mobility (Survey Data)

The IOM Displacement Tracking Matrix (DTM) collects **Community Needs Identification (CNI)** data via key informant interviews and direct observation. Data are published in rounds and provide estimates of temporarily displaced persons (TDPs), returnees, and related variables at the village/settlement level.

> Coverage and variable names vary across rounds. Province and district codes use OCHA p-codes (not GADM) — join to OCHA subnational polygons using `ADM1_PCODE` and `ADM2_PCODE`.

```{r iom-rounds}
iom_rounds <- data.frame(
  Round = c("Round 1", "Round 2", "Round 3 (×3 provinces)", "Round 4 (×3 provinces)",
            "Round 6", "Round 7"),
  `Period` = c(
    "Nov – Dec 2022",
    "Jan – Mar 2023",
    "May – Jun 2023",
    "August 2023",
    "August 2024",
    "Sep – Oct 2025"
  ),
  `Geographic coverage` = c(
    "National",
    "National",
    "Balochistan, KPK, Sindh (separate reports)",
    "Balochistan, KPK, Sindh (separate reports)",
    "Balochistan and KPK",
    "Punjab"
  ),
  `Spatial resolution` = rep("Village / settlement, Tehsil, District, Province", 6),
  `Join key` = rep("ADM1_PCODE / ADM2_PCODE → OCHA polygons", 6),
  check.names = FALSE
)

kable(iom_rounds, caption = "Table 3. IOM CNI data rounds") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"), full_width = TRUE) %>%
  column_spec(1, bold = TRUE)
```

---

## 3. Contextual Data

Contextual datasets provide background on population distribution, socioeconomic conditions, flood extent, rainfall, and vegetation for Pakistan.

```{r contextual}
contextual <- data.frame(
  Dataset = c(
    "WorldPop population (raster)",
    "WorldPop population by age & sex (raster)",
    "WorldPop aggregated population",
    "Global Relative Deprivation Index (GRDI)",
    "Satellite flood extent — 2022 (UNOSAT)",
    "Satellite flood extent — 2025 (UNOSAT)",
    "NASA GPM daily rainfall (raster)",
    "WFP dekadal rainfall",
    "WFP dekadal NDVI"
  ),
  Provider = c(
    "WorldPop / OCHA", "WorldPop / OCHA", "Project team",
    "SEDAC / NASA",
    "UNOSAT", "UNOSAT",
    "NASA GPM",
    "WFP", "WFP"
  ),
  `Spatial resolution` = c(
    "100 m raster",
    "100 m raster (one file per age/sex group)",
    "GADM adm2; OCHA adm1 & adm2",
    "1 km raster; also aggregated to GADM adm2 & OCHA adm1/adm2",
    "Polygon shapefiles",
    "Polygon shapefiles",
    "10 km raster",
    "District (OCHA adm2)",
    "District (OCHA adm2)"
  ),
  `Temporal coverage` = c(
    "2020 estimate", "2020 estimate", "2020 estimate",
    "Static index",
    "1–29 Aug 2022",
    "26 Aug – 7 Sep 2025",
    "1 Jul – 7 Sep 2022 & 2025",
    "2022–present (10-day intervals)",
    "2022–present (10-day intervals)"
  ),
  Format = c(
    "GeoTIFF", "GeoTIFF", "CSV",
    "GeoTIFF / CSV",
    "Shapefile", "Shapefile",
    "Raster",
    "CSV", "CSV"
  ),
  `Join key` = c(
    "—", "—", "GID_2 or ADM1/2_PCODE",
    "GID_2 or ADM1/2_PCODE",
    "—", "—", "—",
    "ADM2_PCODE", "ADM2_PCODE"
  ),
  check.names = FALSE
)

kable(contextual, caption = "Table 4. Contextual datasets") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"), full_width = TRUE) %>%
  column_spec(1, bold = TRUE) %>%
  column_spec(2, width = "10%") %>%
  column_spec(5, width = "8%")
```

**Notes:**

- GRDI values range from 0–100; higher values indicate greater relative deprivation. Full documentation: <https://sedac.ciesin.columbia.edu/downloads/docs/povmap/povmap-grdi-v1-documentation.pdf>
- WorldPop age/sex files follow the naming convention: `{iso}_{gender}_{age_group}_{year}_{type}_{resolution}.tif` (e.g. `pak_f_05_2020_constrained_100m.tif` for Pakistani females aged 5–9).
- NDVI is the Normalised Difference Vegetation Index — used here as a proxy for agricultural and ecological disruption.

---

## 4. Spatial Boundaries

Three boundary systems are in use across the datasets. Selecting the right boundary file for each join is critical.

```{r boundaries}
boundaries <- data.frame(
  `Boundary file` = c(
    "GADM polygons (adm0–adm3)",
    "OCHA subnational polygons (adm1–adm3)",
    "Quadkey polygons (800 m tiles)"
  ),
  Source = c("GADM", "OCHA / HDX", "Project team (from Meta, via quadkeyr R package)"),
  Format = c("Shapefile / GeoPackage", "Shapefile", "Shapefile"),
  `Join key` = c("GID_2", "ADM1_PCODE / ADM2_PCODE", "quadkey"),
  `Used with` = c(
    "Facebook aggregated data; WorldPop & GRDI (gadm_2)",
    "IOM CNI data; WorldPop & GRDI (ocha_1/2); WFP rainfall & NDVI",
    "Facebook tiled Population & Movement data"
  ),
  check.names = FALSE
)

kable(boundaries, caption = "Table 5. Spatial boundary files and join keys") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"), full_width = TRUE) %>%
  column_spec(1, bold = TRUE)
```

> **Important:** The IOM CNI geography (OCHA p-codes) and the Facebook aggregated geography (GADM) do **not** align. Linking these two datasets requires a spatial crosswalk or areal interpolation.

---

## Quick Reference: Dataset × Boundary

```{r quick-ref}
quick_ref <- data.frame(
  Dataset = c(
    "Facebook Population (aggregated)",
    "Facebook Population (tiled)",
    "Facebook Movement (aggregated)",
    "Facebook Movement (tiled)",
    "IOM CNI",
    "WorldPop aggregated (gadm_2)",
    "WorldPop aggregated (ocha_1/2)",
    "GRDI aggregated (gadm_2)",
    "GRDI aggregated (ocha_1/2)",
    "WFP rainfall",
    "WFP NDVI"
  ),
  `Spatial code in dataset` = c(
    "polygon_id",
    "quadkey",
    "start/end_polygon_id",
    "start/end_quadkey",
    "ProvinceCode / DistrictCode (varies
