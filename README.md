# 🏡 House Price Prediction App (R Shiny)

This is a web-based House Price Prediction application built using **R Shiny**. The app utilizes a linear regression model trained on the **King County housing dataset** to predict house prices based on various user inputs. It also provides visual insights through heatmaps, scatter plots, and boxplots.

---

## 🔍 Features

- **Real-time Price Prediction** using a multiple linear regression model.
- **Interactive UI** built with Shiny for easy input of house features.
- **Data Visualizations** including:
  - Correlation Heatmap
  - Price vs Sqft Living (with regression line)
  - Boxplots of Price vs Bedrooms and Floors
  - Residuals vs Fitted plot for regression diagnostics
- **Custom Feature Engineering**:
  - Total Square Footage = `sqft_living + sqft_living15`
  - Age of the house = `2024 - year_built`

---

## 📊 Model Details

The model is trained using the following features:
- `bedrooms`, `bathrooms`, `sqft_living`, `floors`
- `waterfront`, `view`, `condition`, `grade`
- `age` (derived from `year_built`)

Model Type: **Linear Regression (using `lm`)**  
Training-Test Split: 80%-20%

---

## 🧪 Tech Stack

- **Frontend/UI:** R Shiny
- **Backend/Logic:** R, caret, dplyr, ggplot2, corrplot
- **Modeling:** Linear Regression

---

## 📂 Dataset

Dataset used: [`kc_house_data.csv`](https://www.kaggle.com/datasets/harlfoxem/housesalesprediction) (King County, USA)

Make sure the dataset is placed at:
```r
"D:\\Rakshu\\Rprogramming\\Rproject1\\kc_house_data.csv"
