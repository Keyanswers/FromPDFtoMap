
title: "From PDF to Georeferenced Map in R 🌍📄🗺️"
author: "Juan Carlos Rubio Polania, PhD"
date: "2024-05-11"

## Overview

This workflow demonstrates how to extract tabular information from a PDF file, clean and organize the data, convert geographic coordinates into decimal degrees, and visualize the results on a map using R.

The script combines:
- PDF text extraction
- Data cleaning
- Coordinate conversion
- Spatial visualization

Although this example uses geographic coordinates extracted from a PDF document, the workflow can be adapted to many other applications involving:
- Species occurrence records
- Environmental reports
- Historical datasets
- Field notes
- Scientific publications
- Biodiversity databases
---

# Required Packages

```r
require(tidyverse)
require(pdftools)
require(tidyr)
require(measurements)
```

---

# Workflow

## 1. Load Required Packages

```r
require(tidyverse)
require(pdftools)
```

The script loads the libraries required for:
- Data manipulation
- PDF extraction
- Text processing

---

## 2. Define PDF File Path

```r
QQ = "File/Path/"
```

The path to the PDF file is specified.

---

## 3. Extract PDF Text

```r
PDF = pdf_text(QQ) %>%
  str_split('\n')
```

The PDF content is extracted and separated line by line.

---

## 4. Select Specific Text Lines

```r
PDF2 = data.frame(PDF[[3]][7:18])
```

A subset of lines containing the desired information is selected.

---

## 5. Rename Column

```r
colnames(PDF2) = "Info"
```

The extracted information is stored in a column called `"Info"`.

---

## 6. Clean Text Information

```r
PDF2.1 = data.frame(
  gsub("\\s+",
       " ",
       PDF2$Info)
)
```

Extra spaces are removed from the extracted text.

---

## 7. Replace Multi-Word Site Names

```r
PDF2.1$Info = gsub("Bruno Sawmill",
                   "Bruno-Sawmill",
                   PDF2.1$Info)
```

Specific names are modified to preserve them during text separation.

---

## 8. Separate Columns

```r
Sd = separate(PDF2.1,
              Info,
              into = c("Site",
                       "Elev",
                       "Lat",
                       "Lon"),
              sep = " ")
```

The text is separated into:
- Site
- Elevation
- Latitude
- Longitude

---

## 9. Remove Missing Values

```r
Sd = na.omit(Sd)
```

Rows containing missing values are removed.

---

## 10. Clean Coordinate Fields

```r
Sd$Lon = gsub("[,°’ ”]|[[:upper:]]+",
              " ",
              Sd$Lon)
```

Unnecessary symbols and letters are removed from coordinate values.

---

## 11. Convert Coordinates to Decimal Degrees

```r
require(measurements)

Sd[i,j] = conv_unit(
  Sd[i,j],
  from = "deg_min_sec",
  to = "dec_deg"
)
```

Coordinates in degrees-minutes-seconds format are converted into decimal degrees.

---

## 12. Adjust Coordinate Values

```r
Sd$Lat = Sd$Lat * -1
```

Latitude values are adjusted according to hemisphere orientation.

---

## 13. Reorder Columns

```r
Sd = Sd[,c(1,4,3,2)]
```

Columns are reorganized.

---

## 14. Load Mapping Function

```r
load("QMap.Rdata")
```

A previously saved mapping function is loaded.

---

## 15. Plot Georeferenced Data

```r
QMap(Sd,
     angle = 50)
```

The extracted coordinates are visualized on a map.

---

# Applications

This workflow can be useful for:
- Biodiversity databases
- GIS workflows
- Scientific data extraction
- Species occurrence mapping
- Ecological studies
- Environmental analysis
- Spatial visualization

---

# Requirements

- R
- tidyverse
- pdftools
- tidyr
- measurements

---

# License

This project is licensed under the MIT License.

---

# Author

Juan Carlos Rubio Polania, PhD

---

# Author

Juan Carlos Rubio Polania, PhD
