# Retail Sales Forecasting using SARIMA

## Overview
This project applies Seasonal ARIMA (SARIMA) modeling to analyse and forecast
monthly U.S. sporting goods retail sales from January 1992 to March 2023.
The objective is to identify a well-specified time series model that captures
both long-term trend and seasonality, and to use it to generate forecasts for
the next three years.

---

## Dataset
- Frequency: Monthly
- Period: Jan 1992 – Mar 2023
- Variable: U.S. sporting goods retail sales (USD, millions)

---

## Exploratory Data Analysis

### Raw Time Series
![Raw Time Series](images/raw_timeseries.png)

The time series shows a strong upward trend with clear and repeating annual
seasonality. The increasing amplitude of seasonal fluctuations over time
suggests a multiplicative seasonal structure.

---

### Seasonal Decomposition
![Seasonal Decomposition](images/decomposition.png)

**Trend:**  
A steady upward trend from 1992 until around 2019, followed by a sharp increase
during 2020–2021, corresponding to pandemic-era effects.

**Seasonality:**  
A stable and repeating yearly pattern with pronounced peaks, confirming strong
seasonal behaviour in sporting goods sales.

**Remainder:**  
Mostly small, random fluctuations, with larger deviations in recent years,
indicating irregular shocks not fully explained by trend or seasonality.

---

## Stationarity Assessment

### Augmented Dickey–Fuller Test
The Augmented Dickey–Fuller test on the original series fails to reject the null
hypothesis of non-stationarity (p-value ≈ 0.30), indicating that differencing is
required.

First-order differencing and seasonal differencing at lag 12 are applied.

![Differenced Series](images/differenced_series.png)

After differencing, the ADF test strongly rejects non-stationarity
(p-value < 0.01), confirming the series is suitable for SARIMA modelling.

---

## ACF and PACF Analysis
![ACF and PACF](images/acf_pacf.png)

The non-seasonal ACF and PACF show no clear cut-off, suggesting a mixed ARMA
structure. Seasonal lags show a strong ACF spike at lag 12 with tapering PACF,
indicating a seasonal MA component.

An initial model of the form SARIMA(1,1,1)(0,1,2)[12] is selected.

---

## Model Selection

A total of 20 neighbouring SARIMA models were evaluated using AIC and BIC to
balance goodness-of-fit and model complexity.

The best-performing model by both criteria is:

```
SARIMA(2,1,1)(1,1,2)[12]
```

This model provides the most parsimonious representation of the data while
maintaining strong predictive performance.

---

## Model Diagnostics

### Residual Analysis
![Residual Diagnostics](images/residuals.png)

Residuals fluctuate around zero, indicating mean-stationary errors. Increased
volatility during 2020–2021 reflects pandemic-related shocks. Minor remaining
autocorrelation is present but acceptable for forecasting purposes.

---

## Forecasting

Using the selected SARIMA model, monthly forecasts were generated for 36 months
(April 2023 – March 2026).

![Forecast Plot](images/forecast.png)

The forecasts preserve the strong seasonal pattern observed historically, with
peaks occurring each December, likely driven by holiday demand. Confidence
intervals widen gradually, reflecting increasing uncertainty over time.

---

## Technologies Used
- R
- forecast
- tseries
- ggplot2

---

## Key Takeaways
- SARIMA models effectively capture strong seasonal structure in retail sales
- Proper differencing is critical to achieving stationarity
- Model selection using AIC and BIC improves robustness
- External shocks can increase uncertainty without invalidating forecasts

---

## Future Improvements
- Extend to SARIMAX using exogenous variables
- Compare against ETS and machine-learning-based approaches
- Perform rolling-origin cross-validation

---

## License
This project is licensed under the MIT License.


 

 

 

 

 

 

 

 

 

 
:::
