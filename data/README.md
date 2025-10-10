# DSAssist Data Directory

This directory contains sample datasets and data files for the DSAssist agentic data science system.

## Sample Datasets

### sample_data.csv
- **Description**: Basic numerical dataset for testing data loading and analysis
- **Columns**: 
  - `id`: Unique identifier
  - `value`: Numerical values for analysis
  - `category`: Categorical groupings
- **Use Case**: Initial testing of CSV loading, basic statistical analysis, agent workflow validation

### product_sales.csv
- **Description**: E-commerce product sales dataset with multiple categories
- **Columns**:
  - `product_id`: Unique product identifier
  - `product_name`: Product name
  - `category`: Product category (Electronics, Appliances, Sports, etc.)
  - `price`: Product price in USD
  - `sales_count`: Number of units sold
  - `rating`: Customer rating (1-5 stars)
  - `in_stock`: Inventory status (boolean)
- **Use Case**: Testing multi-categorical analysis, sales forecasting, inventory optimization

### weather_data.csv
- **Description**: Multi-city weather observations with meteorological data
- **Columns**:
  - `date`: Observation date (YYYY-MM-DD)
  - `temperature`: Temperature in Celsius
  - `humidity`: Relative humidity percentage
  - `pressure`: Atmospheric pressure in hPa
  - `weather_condition`: Categorical weather description
  - `city`: City name
- **Use Case**: Time series analysis, weather pattern recognition, multi-location comparison

## Usage

The DSAssist system can automatically load and analyze any CSV file in this directory using:

```julia
using DSAssist

# Load and analyze a dataset
result = load_and_analyze_csv("data/sample_data.csv")
println(result)

# Analyze product sales data
sales_analysis = load_and_analyze_csv("data/product_sales.csv")

# Weather data analysis
weather_analysis = load_and_analyze_csv("data/weather_data.csv")
```

## Data Organization

- Place new datasets in this directory
- Use descriptive filenames
- Include documentation for complex datasets
- Follow CSV best practices (headers, consistent formats)

## Notes

- All CSV files should have headers in the first row
- Missing values should be represented consistently (empty cells, "NA", etc.)
- Large datasets (>100MB) should be compressed or stored externally