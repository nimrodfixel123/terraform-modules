FROM python:3.9-slim

WORKDIR /app
COPY app.py .

# Make sure Python output is sent to the container log
ENV PYTHONUNBUFFERED=1

EXPOSE 8080

CMD ["python", "app.py"]