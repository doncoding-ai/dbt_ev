# ⚡ dbt_ev: Electric Vehicle Analytics with dbt + Snowflake
=======
Welcome to your new dbt Data Engineering project!


This project uses **dbt (data build tool)** to model, clean, and transform electric vehicle specification data stored in **Snowflake**, enabling analytics and dashboarding for automotive insights.
I have sourced this data from Kaggle Check the data here:
https://www.kaggle.com/datasets/urvishahir/electric-vehicle-specifications-dataset-2025?resource=download
---

## 📁 Project Structure

dbt_ev/
├── models/
│ ├── staging/
│ │ └── stg_ev_data.sql # Raw data staging from Snowflake source
│ ├── marts/
│ │ ├── dimension_model/
│ │ │ ├── dimension_model.sql # Brand-model dimension with surrogate keys
│ │ │ └── dimension_model.yml
│ │ ├── fact_ev_specs/
│ │ │ ├── fact_ev_specs.sql # Fact table with normalized and engineered metrics
│ │ │ └── fact_ev_specs.yml
├── snapshots/
├── tests/
└── README.md
---
## Architecture
![Architecture Diagram](./DBT_ETL.png)  
*Diagram illustrates the flow from data ingestion to dashboards.*
![WorfkFlow](./ETL_DATA_FLOW.gif)

---

## 🚗 Data Source

- **Database:** `RAW`  
- **Schema:** `CARS`  
- **Table:** `EV_CARS`

This table contains specifications of 400+ electric vehicles (brands, battery, range, dimensions, drivetrain, etc.).

---

## 🔧 Key Transformations

### ✅ `dimension_model`
- Deduplicates and normalizes brand-model combinations
- Assigns a surrogate `model_id` key

### ✅ `fact_ev_specs`
- Cleans data types (e.g., casting cargo volume)
- Fills missing values (`torque_nm`, `number_of_cells`, etc.)
- Normalizes categorical fields: `drivetrain`, `segment`, `car_body_type`
- Adds:
  - `performance_category` (based on acceleration)
  - `length_m`, `width_m`, `height_m` from mm
  - `fast_charging_ratio = battery_capacity / charging_power`

---

## 📊 Use Cases

- Analyze EV performance vs. efficiency
- Group by segment, body type, drivetrain for comparison
- Power dashboards in Tableau / Power BI

---

## 🧪 How to Run

1. **Install dbt (if not done):**

```bash
pip install dbt-snowflake
Configure profiles.yml:


dbt_ev:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account>
      user: <your_user>
      password: <your_password or use externalbrowser>
      role: <your_role>
      database: RAW
      warehouse: <your_warehouse>
      schema: <your_target_schema>
Run the pipeline:


dbt debug       # Verify connection
dbt run         # Build all models
dbt test        # Run data quality tests
📈 Future Enhancements
Add dim_drivetrain, dim_segment as dimension lookups

Track historical changes via snapshots

Integrate ML predictions for EV performance

Build CI/CD with GitHub Actions

🧑‍💻 Author
Built and maintained by doncodingai — Powered by Snowflake + dbt.

📄 License
MIT License
