setwd("")

# Load required packages
library(forecast)
library(tseries)
library(ggplot2)

# Load 
Sales_data <- read.csv("Sales.csv")

# Convert to time series (monthly, starting Jan 1992)
Sales_ts <- ts(Sales_data$Sales, frequency = 12, start = c(1992, 1))

# Raw plot
autoplot(Sales_ts) + ggtitle("Monthly Retail Sales of Sporting Goods (US)") +
  xlab("Year") + ylab("Sales (Million $)")

# Decomposition
decomp <- decompose(Sales_ts, type = "multiplicative")
autoplot(decomp)

# ADF test 
adf.test(Sales_ts)

# First difference 
Sales_diff <- diff(Sales_ts)

# Seasonal difference
Sales_season_diff <- diff(Sales_diff, lag = 12)
autoplot(Sales_season_diff) + ggtitle("Seasonally Differenced Series")

# ADF test
adf.test(Sales_season_diff)

# ACF & PACF
par(mfrow = c(1,2))
acf(Sales_season_diff, lag.max = 48, main = "ACF: Seasonally Differenced")
pacf(Sales_season_diff, lag.max = 48, main = "PACF: Seasonally Differenced")

# ACF & PACF data
acf_result <- acf(Sales_season_diff, lag.max = 48, plot = FALSE)
data.frame(Lag = acf_result$lag,
           ACF = acf_result$acf)
pacf_result <- pacf(Sales_season_diff,lag.max = 48, plot = FALSE)
data.frame(Lag = pacf_result$lag,
           PACF = pacf_result$acf)

# Fit initial model
initial_model <- Arima(Sales_ts, order = c(1,1,1), seasonal = c(0,1,1))
summary(initial_model)

models <- list()

models[["SARIMA(1,1,1)(0,1,2)[12]"]] <- Arima(Sales_ts, order = c(1,1,1), seasonal = c(0,1,2))
models[["SARIMA(1,1,1)(0,1,1)[12]"]] <- Arima(Sales_ts, order = c(1,1,1), seasonal = c(0,1,1))
models[["SARIMA(1,1,1)(0,1,3)[12]"]] <- Arima(Sales_ts, order = c(1,1,1), seasonal = c(0,1,3))

models[["SARIMA(0,1,1)(0,1,2)[12]"]] <- Arima(Sales_ts, order = c(0,1,1), seasonal = c(0,1,2))
models[["SARIMA(2,1,1)(0,1,2)[12]"]] <- Arima(Sales_ts, order = c(2,1,1), seasonal = c(0,1,2))
models[["SARIMA(1,1,0)(0,1,2)[12]"]] <- Arima(Sales_ts, order = c(1,1,0), seasonal = c(0,1,2))
models[["SARIMA(1,1,2)(0,1,2)[12]"]] <- Arima(Sales_ts, order = c(1,1,2), seasonal = c(0,1,2))
models[["SARIMA(2,1,2)(0,1,2)[12]"]] <- Arima(Sales_ts, order = c(2,1,2), seasonal = c(0,1,2))
models[["SARIMA(0,1,2)(0,1,2)[12]"]] <- Arima(Sales_ts, order = c(0,1,2), seasonal = c(0,1,2))

models[["SARIMA(1,1,1)(1,1,2)[12]"]] <- Arima(Sales_ts, order = c(1,1,1), seasonal = c(1,1,2))
models[["SARIMA(1,1,1)(2,1,2)[12]"]] <- Arima(Sales_ts, order = c(1,1,1), seasonal = c(2,1,2))
models[["SARIMA(1,1,1)(1,1,1)[12]"]] <- Arima(Sales_ts, order = c(1,1,1), seasonal = c(1,1,1))
models[["SARIMA(1,1,1)(1,1,3)[12]"]] <- Arima(Sales_ts, order = c(1,1,1), seasonal = c(1,1,3))

models[["SARIMA(2,1,1)(1,1,2)[12]"]] <- Arima(Sales_ts, order = c(2,1,1), seasonal = c(1,1,2))
models[["SARIMA(1,1,2)(1,1,2)[12]"]] <- Arima(Sales_ts, order = c(1,1,2), seasonal = c(1,1,2))
models[["SARIMA(2,1,2)(1,1,2)[12]"]] <- Arima(Sales_ts, order = c(2,1,2), seasonal = c(1,1,2))

models[["SARIMA(1,1,0)(1,1,2)[12]"]] <- Arima(Sales_ts, order = c(1,1,0), seasonal = c(1,1,2))
models[["SARIMA(0,1,1)(1,1,2)[12]"]] <- Arima(Sales_ts, order = c(0,1,1), seasonal = c(1,1,2))
models[["SARIMA(0,1,2)(1,1,2)[12]"]] <- Arima(Sales_ts, order = c(0,1,2), seasonal = c(1,1,2))
models[["SARIMA(2,1,0)(0,1,2)[12]"]] <- Arima(Sales_ts, order = c(2,1,0), seasonal = c(0,1,2))


# Compare AIC and BIC
model_aics <- sapply(models, AIC)
model_bics <- sapply(models, BIC)

# Show sorted AICs and BICs
print(sort(model_aics))
print(sort(model_bics))

# Best model by AIC
best_model_key <- names(which.min(model_aics))
cat("Best model by AIC:", best_model_key, "\n")

best_model <- models[[best_model_key]]
summary(best_model)

# Residual diagnostics
checkresiduals(best_model)

# Forecast next 3 years (36 months)
forecast_sales <- forecast(best_model, h = 36)

forecast_sales

# Plot forecast
autoplot(forecast_sales) +
  autolayer(forecast_sales$mean, series = "Forecast") +
  autolayer(fitted(best_model), series = "Fitted") +
  xlab("Year") + ylab("Sales (Million $)") +
  ggtitle(paste("Forecast using", best_model_key)) +
  guides(colour = guide_legend(title = "Series"))
