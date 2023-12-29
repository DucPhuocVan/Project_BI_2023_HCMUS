A. Rules
1. Stage: Source --> Staging (ProjectBI_Staging) -->  Normalized Data Store (ProjectBI_NDS) --> DataWarehouse (ProjectBI_DW)
2. 

B. Processing Data
1. Please note this:
Path: Airflow/dags/save will save folder/file of Data Source (including: .csv; .xlsx) and folder for transformation, so when pulling the project to your local computer, please add folder dbt transform to path (i just create folder following pipeline, you only add files and subfolders of the dbt folder in your computer)
Note: 
    Make sure you run the dbt directory on your local machine successfully
    If you merger your branch into main's branch, please noti to the group to everyone can follow

2. Pipeline 1: 
    - Status: Done
    - Assign: Tan, Phuoc
    - Description: Data Integration from multiple source (.CSV/ .XLSX/ .bak) to projectBI_Staging 
3. Pipeline 2: 
    - Status: 
    - Assign: 
    - Description:
4. Pipeline 3:
    -
    -