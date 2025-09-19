# AI-Powered Sales & Risk Project

This is a data science SalesBI project I completed as part of my internship deliverables at **Victoria Solutions**.  
The goal was to clean and analyze a raw dataset, detect outliers, visualize feature relationships, and prepare the data for predictive modeling in **sales forecasting** and **risk management**.

---

# What I Did
- Imported and cleaned the dataset using Python (handled missing values).  
- Detected and removed outliers using the **Interquartile Range (IQR) method**.  
- Created data visualizations (boxplots, histograms, correlation heatmaps).  
- Prepared a cleaned dataset ready for predictive modeling.  
- Explained how the insights can help businesses manage risks and forecast sales better.  

---

# Business Insights
This project shows how data-driven analysis can support **business decision-making**:

- **Improved Data Quality**: By filling missing values and removing outliers, the dataset became reliable, reducing the risk of wrong forecasts.  
- **Sales Drivers Identified**: The correlation heatmap revealed strong relationships between **marketing spend and sales**, showing that investment in campaigns leads to higher revenue.  
- **Risk Reduction**: Outlier detection eliminated unusual or misleading data points (e.g., extreme pricing or recording errors) that could distort insights.  
- **Inventory & Resource Planning**: Insights can help shops or companies plan stock levels and staffing during periods of high sales (i.e., seasonal peaks).  
- **Better Strategic Decisions**: Management can now base pricing, promotions, and budget allocations on data rather than assumptions.  

---

# Tools Used
- **Python** (Pandas, NumPy)  
- **Seaborn & Matplotlib** for charts  
- **Scikit-learn** for model preparation (future work)  
- **Jupyter Notebook / VS Code**  

---

# How to Run
1. Clone the repo:
   ```bash
   git clone https://github.com/yourusername/sales-risk-analysis.git
   cd sales-risk-analysis
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
3. Place your dataset in the data/ folder. Example:
   ```python
   import pandas as pd
   df = pd.read_csv("data/data.csv")
4. Run the script or open the notebook to see the analysis and charts:
   ```bash
   python src/data_cleaning.py
