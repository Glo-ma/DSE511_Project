# Load required libraries
library(ggplot2)
library(dplyr)
library(reshape2)

# Read the dataset
df <- read.csv("C:/Users/7480/Documents/DSE511_homework4_Glory/DSS.csv")

# Display basic data insights
head(df)
colSums(is.na(df))  # Check for missing values
summary(df)
tail(df)
str(df)

col(df)

# Set theme for plots
theme_set(theme_minimal())

# Create subplots for distributions
par(mfrow = c(3, 2))  # Adjust layout for subplots

# Age Distribution
ggplot(df, aes(x = Age)) +
  geom_histogram(aes(y = ..density..), fill = "blue", color = "black", bins = 30) +
  geom_density(alpha = 0.2) +
  ggtitle("Age Distribution")

# Academic Pressure Distribution
ggplot(df, aes(x = Academic.Pressure)) +
  geom_histogram(aes(y = ..density..), fill = "green", color = "black", bins = 30) +
  geom_density(alpha = 0.2) +
  ggtitle("Academic Pressure Distribution")

# Study Satisfaction Distribution
ggplot(df, aes(x = Study.Satisfaction)) +
  geom_histogram(aes(y = ..density..), fill = "orange", color = "black", bins = 30) +
  geom_density(alpha = 0.2) +
  ggtitle("Study Satisfaction Distribution")

# Study Hours Distribution
ggplot(df, aes(x = Study.Hours)) +
  geom_histogram(aes(y = ..density..), fill = "red", color = "black", bins = 30) +
  geom_density(alpha = 0.2) +
  ggtitle("Study Hours Distribution")

# Financial Stress Distribution
ggplot(df, aes(x = Financial.Stress)) +
  geom_histogram(aes(y = ..density..), fill = "purple", color = "black", bins = 30) +
  geom_density(alpha = 0.2) +
  ggtitle("Financial Stress Distribution")

par(mfrow = c(1, 1))  # Reset layout

# Depression Prevalence
depression_counts <- table(df$Depression)
barplot(depression_counts, col = "red", main = "Depression Prevalence",
        xlab = "Depression (Yes/No)", ylab = "Count")

# Depression by Gender
ggplot(df, aes(x = Depression, fill = Gender)) +
  geom_bar(position = "dodge") +
  labs(title = "Depression Status by Gender", x = "Depression", y = "Count")

# Depression by Study Satisfaction
ggplot(df, aes(x = Depression, fill = Study.Satisfaction)) +
  geom_bar(position = "dodge") +
  labs(title = "Depression Status by Study Satisfaction", x = "Depression", y = "Count")

# Sleep Duration and Depression
ggplot(df, aes(x = Sleep.Duration, fill = Depression)) +
  geom_bar(position = "dodge") +
  labs(title = "Sleep Duration vs Depression", x = "Sleep Duration (hours)", y = "Count")

# Dietary Habits and Depression
ggplot(df, aes(x = Dietary.Habits, fill = Depression)) +
  geom_bar(position = "dodge") +
  labs(title = "Dietary Habits vs Depression", x = "Dietary Habits", y = "Count")

# Academic Pressure vs Depression
ggplot(df, aes(x = Depression, y = Academic.Pressure)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Academic Pressure vs Depression", x = "Depression", y = "Academic Pressure")

# Study Satisfaction vs Depression
ggplot(df, aes(x = Depression, y = Study.Satisfaction)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Study Satisfaction vs Depression", x = "Depression", y = "Study Satisfaction")

# Financial Stress vs Depression
ggplot(df, aes(x = Depression, y = Financial.Stress)) +
  geom_boxplot(fill = "lightcoral") +
  labs(title = "Financial Stress vs Depression", x = "Depression", y = "Financial Stress")

# Categorical Features vs Depression
categorical_features <- c("Gender", "Have.you.ever.had.suicidal.thoughts..", "Family.History.of.Mental.Illness")
target_feature <- "Depression"

for (feature in categorical_features) {
  p <- ggplot(df, aes_string(x = feature, fill = target_feature)) +
    geom_bar(position = "dodge") +
    labs(title = paste("Comparison of", feature, "with", target_feature), x = feature, y = "Count") +
    theme_minimal()
  
  print(p)  # Explicitly print the ggplot object
}

# Correlation Matrix for Numerical Features
numerical_df <- df %>% select_if(is.numeric)
correlation_matrix <- cor(numerical_df, use = "complete.obs")

# Plot the correlation matrix
corr_data <- melt(correlation_matrix)
ggplot(corr_data, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  geom_text(aes(label = round(value, 2)), color = "black", size = 3) +
  scale_fill_gradient2(low = "red", high = "blue", mid = "white", midpoint = 0) +
  labs(title = "Feature Correlation Matrix", x = "", y = "") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
