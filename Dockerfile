# Small, fast base
FROM python:3.11-slim

# Avoid interactive prompts & keep images small
ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# System deps (build tools + common libs)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Create a writable workspace we will mount to
RUN mkdir -p /work

# Create a non-root user and hand over ownership of /app and /work
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app /work

# Switch to non-root and start in /work by default
USER appuser
WORKDIR /work

# Document the port (publish at runtime with -p)
EXPOSE 8888

# Start JupyterLab with modern ServerApp flags; token enabled by default (safer)
CMD ["jupyter", "lab","--ServerApp.ip=0.0.0.0","--ServerApp.port=8888","--ServerApp.open_browser=False"]
