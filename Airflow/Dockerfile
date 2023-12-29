# Use the official Apache Airflow image as the base
FROM apache/airflow:2.7.3

# Switch to root user to install additional dependencies
USER root

# Install ODBC driver dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        unixodbc \
        unixodbc-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt các dependencies của DBT
RUN apt-get update && apt-get install -y \
    git \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Download and install Microsoft ODBC Driver 17 for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql17 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir $AIRFLOW_HOME/dags/save
RUN chown -R airflow: $AIRFLOW_HOME/dags/save
RUN chmod -R 777 $AIRFLOW_HOME/dags/save
USER airflow

# Copy and install Python dependencies (if any)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR $AIRFLOW_HOME