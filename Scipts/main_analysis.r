library(dplyr)
library(tidyr)
library(ggplot2)

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

Scatterplot_numspcies_noiselevel_facet<- ggplot(data = df, aes(x = num_species, y = noise_level, color = habitat_type)) +
  geom_point() +
  geom_smooth(se = FALSE) +
  facet_grid(habitat_type ~ .)
ggsave(plot = Scatterplot_numspcies_noiselevel_facet, 
  "Output/scatter plot of number of species and noise lavels facted by location.png",
  dpi = 300)
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
