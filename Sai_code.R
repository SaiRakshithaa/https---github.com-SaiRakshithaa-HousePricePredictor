library(shiny)
library(ggplot2)
library(caret)
library(dplyr)
library(corrplot)


data <- read.csv("D:\\Rakshu\\Rprogramming\\Rproject1\\kc_house_data.csv")


data$date <- as.Date(data$date, "%Y%m%dT000000")
data$total_sqft <- data$sqft_living + data$sqft_living15
data$age <- 2024 - data$yr_built


set.seed(123)
train_index <- createDataPartition(data$price, p=0.8, list=FALSE)
train_data <- data[train_index, ]
test_data <- data[-train_index, ]


model <- lm(price ~ bedrooms + bathrooms + sqft_living + floors + waterfront + view + condition + grade + age, data=train_data)


predict_price <- function(bedrooms, bathrooms, sqft_living, floors, waterfront, view, condition, grade, year_built, sqft_living15) {
 
  new_data <- data.frame(
    bedrooms = bedrooms,
    bathrooms = bathrooms,
    sqft_living = sqft_living,
    floors = floors,
    waterfront = waterfront,
    view = view,
    condition = condition,
    grade = grade,
    age = 2024 - year_built,
    sqft_living15 = sqft_living15
  )
  
  
  predicted_price <- predict(model, newdata = new_data)
  
  return(predicted_price)
}


ui <- fluidPage(
  titlePanel("House Price Prediction"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("bedrooms", "Number of Bedrooms:", value = 3, min = 1, max = 10),
      numericInput("bathrooms", "Number of Bathrooms:", value = 2, min = 1, max = 10),
      numericInput("sqft_living", "Square Footage of Living Space:", value = 1800),
      numericInput("floors", "Number of Floors:", value = 1, min = 1, max = 3),
      numericInput("waterfront", "Waterfront (0 = No, 1 = Yes):", value = 0, min = 0, max = 1),
      numericInput("view", "View (0-4):", value = 0, min = 0, max = 4),
      numericInput("condition", "Condition (1-5):", value = 3, min = 1, max = 5),
      numericInput("grade", "Grade (1-13):", value = 7, min = 1, max = 13),
      numericInput("year_built", "Year Built:", value = 1990, min = 1800, max = 2024),
      numericInput("sqft_living15", "Living Space 15:", value = 1800),
      
      actionButton("predict", "Predict House Price")
    ),
    
    mainPanel(
      textOutput("price_output"),
      plotOutput("heatmap"),
      plotOutput("scatter"),
      plotOutput("boxplot_bedrooms"),
      plotOutput("boxplot_floors"),
      plotOutput("residuals_plot")
    )
  )
)


server <- function(input, output) {
  observeEvent(input$predict, {
    
    predicted_price <- predict_price(
      bedrooms = input$bedrooms,
      bathrooms = input$bathrooms,
      sqft_living = input$sqft_living,
      floors = input$floors,
      waterfront = input$waterfront,
      view = input$view,
      condition = input$condition,
      grade = input$grade,
      year_built = input$year_built,
      sqft_living15 = input$sqft_living15
    )
    
    output$price_output <- renderText({
      paste("The predicted house price is:", round(predicted_price, 2), "USD")
    })
  })
  
  
  output$heatmap <- renderPlot({
    corr_matrix <- cor(data[, c("price", "bedrooms", "bathrooms", "sqft_living", "sqft_lot", "floors", "grade")])
    corrplot(corr_matrix, method = "color", tl.col = "black", tl.srt = 45, addCoef.col = "black", number.cex = 0.7, main = "Correlation Heatmap")
  })
  
  
  output$scatter <- renderPlot({
    ggplot(data, aes(x = sqft_living, y = price)) + 
      geom_point(alpha = 0.3) + 
      geom_smooth(method = "lm", col = "blue") + 
      ggtitle("Price vs. Sqft Living with Regression Line") +
      theme_minimal()
  })
  
  
  output$boxplot_bedrooms <- renderPlot({
    ggplot(data, aes(factor(bedrooms), price)) + 
      geom_boxplot() + 
      ggtitle("House Prices by Number of Bedrooms") +
      theme_minimal()
  })
  
  
  output$boxplot_floors <- renderPlot({
    ggplot(data, aes(factor(floors), price)) + 
      geom_boxplot() + 
      ggtitle("House Prices by Number of Floors") +
      theme_minimal()
  })
  
 
  output$residuals_plot <- renderPlot({
    lm_model <- lm(price ~ sqft_living + bedrooms + bathrooms, data = train_data)
    residuals <- residuals(lm_model)
    predicted <- predict(lm_model)
    
    ggplot(data.frame(predicted, residuals), aes(x = predicted, y = residuals)) + 
      geom_point(alpha = 0.3) + 
      geom_hline(yintercept = 0, col = "red", linetype = "dashed") + 
      ggtitle("Residuals vs Fitted Values") +
      theme_minimal()
  })
}


shinyApp(ui = ui, server = server)
