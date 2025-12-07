# 🛒 Retail Sales Forecasting using Snowflake Feature Engineering + XGBoost

This project demonstrates a complete end-to-end **machine learning pipeline for retail sales forecasting**, built using:

- **Snowflake SQL** for data ingestion, cleaning, feature engineering  
- **Snowflake Feature Store** for storing engineered features  
- **Snowflake Notebook + Python** for training an XGBoost regression model  
- **Visualization & evaluation inside the notebook**  
- **Writing predictions back to Snowflake**

It follows the structure of real-world MLOps pipelines and is aligned with Snowflake's ML best practices.

---

## 📁 Repository Structure

├── MODEL_TRAIN.ipynb # Model training & evaluation notebook

├── Retail_sales_feature_engineering.sql # Full SQL pipeline (ETL + features)

├── Model_Evaluation_Metrices.png # RMSE, MAE, R² metric output

├── Model_Evaluation_Plot.png # Actual vs Predicted visualization

├── requirements.txt # Python dependencies (for local use)

└── README.md # Project documentation

---

## 🚀 Project Objective

To forecast daily retail sales using historical transaction data enriched with:

- Time-series lag features  
- Rolling window aggregates  
- Encoded categorical features  
- Calendar-based features  
- Normalization and transformations  

The model provides **highly accurate predictions** and demonstrates the power of Snowflake for feature engineering + ML.

---

## 🛠️ Technology Stack

### **Snowflake**
- SQL worksheets  
- Snowflake Feature Store  
- Snowflake Python Notebook  
- Snowpark (Python API)

### **Python Libraries**
- XGBoost  
- Pandas  
- NumPy  
- scikit-learn  
- Matplotlib / Streamlit (for plots)

---

## 🧹 Data Preparation & Cleaning (SQL)

Script: `Retail_sales_feature_engineering.sql`

### ✔ Cleaned Data
- Removed NULL or invalid sales  
- Ensured valid timestamps  
- Sorted rows chronologically  

### ✔ Engineered Features
The project uses advanced SQL window functions to create:

#### **Normalization**
- `SALES_SCALED`
- `PROMOTION_SCALED`

#### **Lag Features**
- `LAG_1`, `LAG_7`, `LAG_30`

#### **Rolling Statistics**
- `ROLLING_AVG_7`, `ROLLING_AVG_30`
- `ROLLING_STD_30`

#### **Categorical Encoding**
- `FAMILY_ENCODED`

#### **Calendar Features**
- `DAY_OF_WEEK`
- `MONTH`
- `WEEK_OF_YEAR`

#### **Transformations**
- `LOG_SALES`
- `PROMO_EFFECT`

All engineered features are stored in:

RETAIL_TRAIN

RETAIL_TEST

---

## 🤖 Model Training (MODEL_TRAIN.ipynb)

The notebook performs:

### ✔ Load processed feature tables from Snowflake  
### ✔ Select important engineered features  
### ✔ Train XGBoost Regressor  
### ✔ Predict test data  
### ✔ Evaluate using regression metrics  
### ✔ Save predictions back to Snowflake

### 📊 Model Performance
The model achieved:

RMSE = 160.48

MAE = 13.55

R² = 0.986

These results indicate **excellent predictive ability**, explaining nearly **99%** of variance in sales.

---

## 📈 Visualizations

Included in the repository:

### **1. Model_Evaluation_Plot.png**
Actual vs Predicted Sales (first 200 time steps)  
Shows the model tracks true sales extremely well.

### **2. Model_Evaluation_Metrices.png**
Formatted output of evaluation metrics (RMSE, MAE, R²)

---

## 📤 Writing Predictions Back to Snowflake

Using Snowpark:

```python
session.write_pandas(pred_df, "PREDICTIONS_RETAIL", auto_create_table=True)
```
Creates a final predictions table:

PREDICTIONS_RETAIL

🧩 requirements.txt

Used only for local execution

▶️ How to Use This Repository

1️⃣ Run SQL Pipeline in Snowflake

Execute:

Retail_sales_feature_engineering.sql

This prepares cleaning, feature engineering, feature store, and train/test tables.

2️⃣ Open Notebook in Snowflake

Run:

MODEL_TRAIN.ipynb


This trains the ML model, evaluates it, visualizes results, and writes predictions to Snowflake.

3️⃣ View Outputs

Check:

Model_Evaluation_Plot.png

Model_Evaluation_Metrices.png

Snowflake table: PREDICTIONS_RETAIL

🎉 Final Notes

This project successfully demonstrates:

Professional-grade feature engineering

End-to-end ML lifecycle using Snowflake + Python

High-performance forecasting using XGBoost

Reusable pipeline suitable for production or academic submission

