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
pheatmap(cor(df_numeric), display_numbers = TRUE, fontsize_number = 30)

head(df)
scatterplot_veg_num_species <- ggplot(data = df, aes(x = vegetation_index, y = num_species, color = habitat_type)) +
  geom_point(size = 4) + geom_smooth(se = FALSE, size = 2) + theme_classic()
ggsave("Output/Scatter plot of vegetation index and num of species.png", dpi = 300)

