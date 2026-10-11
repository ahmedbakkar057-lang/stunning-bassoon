FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    BASE_PATH=/data

WORKDIR /app

# Runtime إضافي لتشغيل ملفات JavaScript التي يرفعها المستخدمون.
RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# تثبيت الاعتماديات أثناء البناء بدل التثبيت وقت التشغيل.
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY panel.py ./panel.py

# Railway يمرر PORT وقت التشغيل؛ هذا توثيق/قيمة احتياطية فقط.
EXPOSE 8080

# اجعل RUN_BOT=1 في Railway Variables عند الحاجة لتشغيل بوت Telegram.
CMD ["python", "panel.py"]
