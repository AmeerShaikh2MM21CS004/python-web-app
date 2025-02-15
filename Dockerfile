FROM ubuntu:latest

WORKDIR /app

COPY requirements.txt /app
COPY devops /app

RUN apt-get update && \
    apt-get install -y python3 python3-venv python3-pip && \
    python3 -m venv /app/venv && \
    /app/venv/bin/pip install -r requirements.txt

EXPOSE 8000

CMD ["/app/venv/bin/python", "manage.py", "runserver", "0.0.0.0:8000"]



