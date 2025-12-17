# AI Readiness Audit Spreadsheet

Interactive HTML spreadsheet for calculating AI automation ROI.

## Quick Start

### Option 1: Open Directly
Simply open `ai-readiness-audit.html` in your web browser.

### Option 2: Run with Docker

Build the Docker image:
```bash
docker build -t ai-readiness-audit .
```

Run the container:
```bash
docker run -d -p 8080:80 ai-readiness-audit
```

Access the application at: http://localhost:8080

## Docker Commands

**Stop the container:**
```bash
docker ps  # Find the container ID
docker stop <container-id>
```

**Remove the container:**
```bash
docker rm <container-id>
```

**Remove the image:**
```bash
docker rmi ai-readiness-audit
```
