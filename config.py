import os
from datetime import timedelta
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'digitalsaathi_default_production_secret_2026')
    MYSQL_HOST = os.environ.get('MYSQL_HOST', 'localhost')
    MYSQL_PORT = int(os.environ.get('MYSQL_PORT', 3306))
    MYSQL_USER = os.environ.get('MYSQL_USER', 'root')
    MYSQL_PASSWORD = os.environ.get('MYSQL_PASSWORD', 'admin')
    MYSQL_DATABASE = os.environ.get('MYSQL_DATABASE', 'digitalsaathi_db')
    MYSQL_SSL_CA = os.environ.get('MYSQL_SSL_CA', None)
    MYSQL_SSL_REQUIRED = os.environ.get('MYSQL_SSL_REQUIRED', 'false').lower() == 'true'
    MYSQL_SSL_DISABLED = os.environ.get('MYSQL_SSL_DISABLED', 'false').lower() == 'true'
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = 'Lax'
    SESSION_COOKIE_SECURE = os.environ.get('SESSION_COOKIE_SECURE', 'false').lower() == 'true' or os.environ.get('FLASK_ENV', 'development') == 'production'
    PERMANENT_SESSION_LIFETIME = timedelta(days=7)
    WTF_CSRF_ENABLED = True
    WTF_CSRF_SECRET_KEY = SECRET_KEY
