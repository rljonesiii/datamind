# DataMind Data Directory

This directory contains sample datasets for the DataMind agentic data science system, supporting various analytical workflows and agent demonstrations.

## Sample Datasets

### cc_data.csv
- **Description**: Credit card customer dataset with comprehensive financial behavior metrics
- **Size**: 8,950 customer records with 18 features
- **Columns**:
  - `CUST_ID`: Unique customer identifier
  - `BALANCE`: Account balance amount
  - `BALANCE_FREQUENCY`: Frequency of balance updates (0-1)
  - `PURCHASES`: Total purchase amount
  - `ONEOFF_PURCHASES`: One-off purchase amount
  - `INSTALLMENTS_PURCHASES`: Installment purchase amount
  - `CASH_ADVANCE`: Cash advance amount
  - `PURCHASES_FREQUENCY`: Frequency of purchases (0-1)
  - `ONEOFF_PURCHASES_FREQUENCY`: Frequency of one-off purchases (0-1)
  - `PURCHASES_INSTALLMENTS_FREQUENCY`: Frequency of installment purchases (0-1)
  - `CASH_ADVANCE_FREQUENCY`: Frequency of cash advances (0-1)
  - `CASH_ADVANCE_TRX`: Number of cash advance transactions
  - `PURCHASES_TRX`: Number of purchase transactions
  - `CREDIT_LIMIT`: Credit limit amount
  - `PAYMENTS`: Total payments made
  - `MINIMUM_PAYMENTS`: Minimum payment amount
  - `PRC_FULL_PAYMENT`: Percentage of full payment (0-1)
  - `TENURE`: Customer tenure in months
- **Use Case**: Customer segmentation, risk analysis, financial behavior modeling, credit scoring

### sample_data.csv
- **Description**: Basic numerical dataset for testing data loading and analysis
- **Size**: 15 records with 5 columns
- **Columns**: 
  - `name`: Person name
  - `age`: Age in years
  - `salary`: Annual salary
  - `department`: Department name
  - `satisfaction_score`: Job satisfaction score (1-5)
- **Use Case**: Initial testing of CSV loading, basic statistical analysis, agent workflow validation

### product_sales.csv
- **Description**: E-commerce product sales dataset with multiple categories
- **Size**: 15 product records with 7 columns
- **Columns**:
  - `product_id`: Unique product identifier
  - `product_name`: Product name
  - `category`: Product category (Electronics, Appliances, Sports, etc.)
  - `price`: Product price in USD
  - `sales_count`: Number of units sold
  - `rating`: Customer rating (1-5 stars)
  - `in_stock`: Inventory status (boolean)
- **Use Case**: Multi-categorical analysis, sales forecasting, inventory optimization, business intelligence

### weather_data.csv
- **Description**: Multi-city weather observations with meteorological data
- **Size**: 15 observations across 3 cities
- **Columns**:
  - `date`: Observation date (YYYY-MM-DD format)
  - `temperature`: Temperature in Celsius
  - `humidity`: Relative humidity percentage (0-100)
  - `pressure`: Atmospheric pressure in hPa
  - `weather_condition`: Categorical weather description (Sunny, Cloudy, Rainy)
  - `city`: City name (New York, Los Angeles, Chicago)
- **Use Case**: Time series analysis, weather pattern recognition, multi-location comparison, climate modeling

## Usage

The DataMind system provides multiple ways to analyze these datasets:

### 🚀 Enhanced Script Runner (Recommended)
```bash
# From scripts/ directory
cd scripts/

# Run agentic analysis on any dataset
./run.sh demos/agentic_guided_tour/credit_card_guided_tour.jl      # Uses cc_data.csv
./run.sh demos/agentic_guided_tour/product_sales_analysis.jl       # Uses product_sales.csv
./run.sh demos/agentic_guided_tour/weather_agentic_analysis.jl     # Uses weather_data.csv
./run.sh demos/agentic_guided_tour/basic_usage.jl                  # Uses sample_data.csv

# Analytics showcase scripts
./run.sh demos/analytics_showcase/credit_card_analytics.jl         # Credit card deep dive
./run.sh demos/analytics_showcase/julia_ml_usage_example.jl        # ML demonstration
```

### 🔄 Direct Analysis
```bash
# Interactive analysis with native Julia ML
julia --project=. scripts/direct_analysis.jl "What drives customer satisfaction?"

# Specify dataset when prompted or modify script to use specific files
```

### 📊 Julia Native ML
```julia
using DataMind

# Load datasets using optimized Julia ML pipeline
cc_data = load_and_prepare_data("data/cc_data.csv", validate=true)
sales_data = load_and_prepare_data("data/product_sales.csv", validate=true)

# Advanced analytics with 5-100x performance improvements
results = linear_regression_analysis(X_train, y_train, X_test, y_test)
cv_results = cross_validate_model(X, y, 5, model_type="linear")
```

## Dataset Applications

### 💳 Credit Card Analysis (cc_data.csv)
- **Customer Segmentation**: Risk-based customer grouping using purchase patterns
- **Risk Modeling**: Payment behavior prediction and default risk assessment  
- **Financial Insights**: Credit utilization patterns and spending behavior analysis
- **Business Intelligence**: Revenue optimization and customer lifetime value

### 🛒 E-commerce Analytics (product_sales.csv)
- **Sales Forecasting**: Revenue prediction and inventory planning
- **Category Analysis**: Performance comparison across product categories
- **Rating Impact**: Customer satisfaction correlation with sales metrics
- **Portfolio Optimization**: Product mix and pricing strategy

### 🌤️ Weather Intelligence (weather_data.csv)
- **Climate Profiling**: Multi-city atmospheric pattern recognition
- **Predictive Modeling**: Temperature and weather condition forecasting
- **Correlation Discovery**: Atmospheric variable relationship analysis
- **Geographic Comparison**: Climate zone classification and city ranking

### 👥 HR Analytics (sample_data.csv)
- **Employee Satisfaction**: Factor analysis for job satisfaction drivers
- **Compensation Analysis**: Salary distribution and department comparison
- **Demographic Insights**: Age and experience correlation patterns
- **Basic Testing**: System validation and workflow verification

## Data Organization

## Data Organization

- **Structured Format**: All datasets follow consistent CSV format with headers
- **Descriptive Naming**: File names clearly indicate content and domain
- **Size Optimization**: Datasets sized for demonstration while maintaining analytical depth
- **Domain Coverage**: Financial, e-commerce, meteorological, and HR data domains
- **Quality Assurance**: Clean, validated datasets ready for immediate analysis

## Adding New Datasets

When adding new datasets to this directory:

1. **File Format**: Use CSV with headers in the first row
2. **Documentation**: Update this README with dataset description and column details
3. **Size Considerations**: Keep demonstration datasets under 10MB for performance
4. **Missing Values**: Use consistent representation (empty cells, "NA", or explicit nulls)
5. **Validation**: Test with basic loading: `CSV.read("data/filename.csv", DataFrame)`

## Integration with DataMind

All datasets are automatically discoverable by the DataMind agentic system:

- **Auto-Detection**: Agents can automatically find and analyze any CSV in this directory
- **Schema Inference**: Column types and patterns are automatically detected
- **Quality Validation**: Built-in data quality checks and missing value handling
- **Performance Optimization**: Julia native ML provides 5-100x faster processing
- **Knowledge Graph**: Analysis results are stored for cross-dataset learning

## Dataset Statistics

| Dataset | Rows | Columns | Domain | Complexity |
|---------|------|---------|---------|------------|
| cc_data.csv | 8,950 | 18 | Financial | High |
| product_sales.csv | 15 | 7 | E-commerce | Medium |
| weather_data.csv | 15 | 6 | Meteorological | Medium |
| sample_data.csv | 15 | 5 | HR/Demo | Low |