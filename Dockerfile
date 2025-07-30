# Use official Python runtime as base image
FROM python:3.11-slim

# Set working directory in container
WORKDIR /app

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY main.py .
COPY config.json .
COPY run.sh .

# Make run.sh executable
RUN chmod +x run.sh

# Create directory for data persistence
RUN mkdir -p /app/data

# Set environment variable for token (to be provided at runtime)
ENV TELEGRAM_BOT_TOKEN=""

# Run the application
CMD ["./run.sh"]