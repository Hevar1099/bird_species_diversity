library(dplyr)
library(tidyr)
library(ggplot2)
library(Metrics)

df <- read.csv("Data/bird_species_diversity.csv")

head(df)
str(df)
summary(df) # based on this normal values within range

# checking for NA values
colSums(is.na(df)) # no missing values

# exploring the data
df_numeric <- df %>% select(where(is.numeric))
cor(df_numeric) # NOTE very strong positive correlation between vegetation and num_species # nolint
library(pheatmap)
heatmap <- pheatmap(cor(df_numeric), display_numbers = TRUE, fontsize_number = 30) # nolint
ggsave(plot = heatmap, "Output/Correlation heatmap for the numerical values.png", dpi = 300, device = "png") # nolint
# NOTE also noise levels have a weak negative correlation with number of species

head(df)
scatterplot_veg_num_species <- ggplot(data = df, aes(x = vegetation_index, y = num_species, color = habitat_type)) + # nolint
  geom_point(size = 4) +
  geom_smooth(se = FALSE, size = 2) +
  theme_classic()
ggsave(plot = scatterplot_veg_num_species, "Output/Scatter plot of vegetation index and num of species.png", dpi = 300, device = "png") # nolint

png("Output/Scatter plot of precipitation and the avg temperatures.png")
scatterplot_precipitation_avg_temp <- with(df, {
  plot(avg_temp, precipitation, type = "p", data = df)
  text(avg_temp, precipitation, labels = habitat_type, col = "lightblue")
})
dev.off()
# NOTE no meaningful relations where observed in the above plot

# Since for this study num of species is the target we will focus on that for the rest # nolint
# of the analysis

Scatterplot_numspcies_noiselevel_facet <- ggplot(data = df, aes(x = num_species, y = noise_level, color = habitat_type)) +
  geom_point() +
  geom_smooth(se = FALSE) +
  facet_grid(habitat_type ~ .)
ggsave(
  plot = Scatterplot_numspcies_noiselevel_facet,
  "Output/scatter plot of number of species and noise lavels facted by location.png",
  dpi = 300
)
# NOTE Based on the above plot noise levels seem to be really negatively affecting number of species in urban areas. # nolint
# To further investigate this we will use statistical testing and data subsetting. #nolint

head(df)
shapiro.test(df$num_species) # normally distributed (W = 0.96838, p-value = 0.0001792) there for we will use anova #nolint
anova_re <- aov(df$num_species ~ df$habitat_type)
summary(anova_re) # NOTE results come back borderline significant p = 0.0599
TukeyHSD(anova_re) # the only significant value is wetland vs grassland p = 0.0414 #nolint

# checking if noise levels differ significantly between habitat types
shapiro.test(df$noise_level) # non normally distributed data p = 0.7466
# because of this we will use kruskal rank sum test
kruskal.test(df$habitat_type ~ df$noise_level) # results are non significant

# Subsetting the data
df_urban_noise <- df %>% filter(habitat_type == "urban")
df_urban_noise_numeric <- df_urban_noise %>% select(where(is.numeric))
write.csv(cor(df_urban_noise_numeric), file = "Data/correlation matrix for urban data.csv")


# NOTE with the data subset now we have a better picture since avg temp and
# noise levels are higher in urban areas its negatively affecting number of species #nolint
# this requires further data and future explorations

# checking species richness in each habitat zones
boxplot_numspecies_habitat <- ggplot(data = df, aes(x = habitat_type, y = num_species, fill = habitat_type)) + # nolint
  geom_jitter() +
  geom_boxplot(alpha = 0.5)
ggsave(plot = boxplot_numspecies_habitat, filename = "Output/boxplot of habitat type and number of species.png") # nolint

# Weetland areas have the highest number of bird species, further exploring this is important #nolint
head(df, 10)

# Weetland data
wetland_data <- df %>% filter(habitat_type == "wetland")
head(wetland_data)
wetland <- as.data.frame(summary(wetland_data))


# rest of the habitat areas
df_rest <- df %>% filter(habitat_type != "wetland")
splited_data <- split(df_rest, df_rest$habitat_type)

forest <- as.data.frame(summary(splited_data$forest))
grassland <- as.data.frame(summary(splited_data$grassland))
urban <- as.data.frame(summary(splited_data$urban))

wetland$habitat_type <- "westland"
forest$habitat_type <- "forest"
grassland$habitat_type <- "grassland"
urban$habitat_type <- "urban"
all <- rbind(wetland, forest, grassland, urban)
write.csv(all, "Data/Summary statistic for all habitat types.csv")


# Since there is a very positive and strong correlation between vegetative index and num of species we # nolint
# will just use liner regression for our model

model <- lm(num_species ~ vegetation_index, data = df)
summary(model)

# Model Fit:
# The model explains a very high proportion of the
# variance in number of species, with an R-squared of 0.93 (adjusted R-squared: 0.92).
# This indicates that vegetation index is a strong predictor of bird species diversity in your dataset.

# Statistical Significance:
# The relationship between vegetation index and number of species is
# highly significant (p < 2e-16), as shown by the t-test for the vegetation
# index coefficient and the overall F-statistic.

# Model Coefficients:

# Intercept: -0.64 (not statistically significant, p = 0.487)
# Vegetation Index Coefficient: 78.62 (highly significant, p < 2e-16)
# This means that for each unit increase in vegetation index,
# the model predicts an increase of about 78.6 bird species.
# Residuals:

# The residuals are reasonably centered around zero,
# with a median close to zero and a residual standard error of 4.78.
# The spread of residuals (Min: -12.74, Max: 11.96) suggests some
# variability not explained by the model, but overall fit is strong.

model1 <- lm(num_species ~ vegetation_index + noise_level, data = df)
summary(model1)
png("Output/Model performance.png")
plot(model1, which = 1:2)
dev.off()

# For each unit increase in vegetation
# index, the number of species increases by about 79.
# For each unit increase in noise level,
# the number of species decreases by about 0.28,
# holding vegetation index constant.
# This model performs overall better than the previous model


saveRDS(model1, "Output/Linear_Model.rds")
