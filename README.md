# Bird Species Diversity Analysis

## Overview

This project analyzes bird species diversity across different habitat types using environmental and anthropogenic variables. The analysis is performed in R and includes data exploration, visualization, statistical testing, and linear modeling to understand the factors influencing bird species richness. The main script is `Scipts/main_analysis.r`.

---

## Table of Contents

- [Bird Species Diversity Analysis](#bird-species-diversity-analysis)
  - [Overview](#overview)
  - [Table of Contents](#table-of-contents)
  - [Project Structure](#project-structure)
  - [Data Description](#data-description)
  - [Analysis Workflow](#analysis-workflow)
  - [Key Findings](#key-findings)
  - [Usage](#usage)
  - [Dependencies](#dependencies)
  - [Outputs](#outputs)
  - [Reproducibility](#reproducibility)
  - [License](#license)
  - [Contact](#contact)

---

## Project Structure

```
birth_species_diversity/
├── Data/
│   └── bird_species_diversity.csv
├── Output/
│   ├── Correlation heatmap for the numerical values.png
│   ├── Scatter plot of vegetation index and num of species.png
│   ├── Scatter plot of precipitation and the avg temperatures.png
│   ├── scatter plot of number of species and noise lavels facted by location.png
│   ├── boxplot of habitat type and number of species.png
│   ├── Model performance.png
│   ├── Linear_Model.rds
│   └── habitat_summaries.csv
├── Scipts/
│   └── main_analysis.r
└── README.md
```

---

## Data Description

- **Source:** `Data/bird_species_diversity.csv`
- **Columns:**
  - `site_id`: Unique identifier for each site
  - `habitat_type`: Type of habitat (e.g., wetland, forest, grassland, urban)
  - `num_species`: Number of bird species observed
  - `vegetation_index`: Quantitative measure of vegetation cover/quality
  - `noise_level`: Ambient noise level at the site
  - `avg_temp`: Average temperature at the site
  - `precipitation`: Precipitation at the site

---

## Analysis Workflow

1. **Data Import & Cleaning**
   - Load data and check for missing values.
   - Summarize and inspect data structure.

2. **Exploratory Data Analysis**
   - Compute and visualize correlations between numeric variables.
   - Generate scatter plots and boxplots to explore relationships.

3. **Statistical Testing**
   - Test for normality (Shapiro-Wilk).
   - Compare species richness across habitats (ANOVA, Tukey HSD).
   - Compare noise levels across habitats (Kruskal-Wallis).

4. **Subsetting & Summarization**
   - Subset data by habitat type for detailed summaries.
   - Export summary statistics for each habitat.

5. **Modeling**
   - Fit linear regression models to predict species richness.
   - Compare models with different predictors (vegetation index, noise level).
   - Save the best model for future use.

6. **Visualization**
   - Save all plots and model diagnostics to the `Output/` directory.

---

## Key Findings

- **Data Quality:** No missing values; all variables within expected ranges.
- **Correlations:** Strong positive correlation between vegetation index and number of species; weak negative correlation between noise level and number of species.
- **Habitat Differences:** Wetlands have the highest bird species richness. Significant difference found between wetland and grassland habitats.
- **Modeling:**
  - Vegetation index alone explains ~93% of the variance in species richness.
  - Adding noise level improves the model (R² increases to ~95%). Both predictors are highly significant.
  - For each unit increase in vegetation index, species richness increases by ~79; for each unit increase in noise level, species richness decreases by ~0.28.
- **Urban Areas:** Higher noise and temperature in urban habitats are associated with lower species richness.

---

## Usage

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/birth_species_diversity.git
   cd birth_species_diversity
   ```

2. **Install R dependencies:**
   Open R and run:
   ```r
   install.packages(c("dplyr", "tidyr", "ggplot2", "Metrics", "pheatmap"))
   ```

3. **Run the analysis:**
   ```r
   source("Scipts/main_analysis.r")
   ```

4. **Review outputs:**
   - Plots and model summaries are saved in the `Output/` directory.
   - Summary statistics for each habitat are in `Data/Summary statistic for all habitat types.csv`.

---

## Dependencies

- R (>= 4.0.0)
- dplyr
- tidyr
- ggplot2
- Metrics
- pheatmap

---

## Outputs

- **Plots:** Correlation heatmaps, scatter plots, boxplots, model diagnostics.
- **Tables:** Summary statistics for each habitat type.
- **Models:** Saved linear model object (`Linear_Model.rds`).

---

## Reproducibility

- All code is contained in `Scripts/main_analysis.r`.
- Set a random seed if you add any stochastic analysis.
- Data and outputs are versioned in their respective folders.

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

## Contact

For questions or contributions, please contact:

- **Name:** Hevar Nyaz
- **Email:** hevar.nyaz@charmo.edu.iq