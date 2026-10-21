import os
import sys
from config import Config
from db import get_db_connection
from seed_data import seed_all
from create_admin import setup_admin

def initialize_database():
    conn = get_db_connection()
    if not conn:
        print(f"Failed to connect to MySQL database at {Config.MYSQL_HOST}:{Config.MYSQL_PORT}")
        sys.exit(1)

    schema_file = os.path.join(os.path.dirname(__file__), 'schema.sql')
    with open(schema_file, 'r', encoding='utf-8') as f:
        sql_content = f.read()

    cursor = conn.cursor()
    statements = sql_content.split(';')
    for stmt in statements:
        raw = stmt.strip()
        if raw and not raw.upper().startswith('CREATE DATABASE') and not raw.upper().startswith('USE '):
            try:
                cursor.execute(raw)
            except Exception as e:
                pass
    conn.commit()
    cursor.close()
    conn.close()

    seed_all()
    admin_email = os.environ.get('INITIAL_ADMIN_EMAIL', 'admin@digitalsaathi.org')
    admin_password = os.environ.get('INITIAL_ADMIN_PASSWORD', 'Admin@123')
    setup_admin('Administrator', admin_email, '9876543210', admin_password)
    print("Database initialization and initial administrator setup complete.")

if __name__ == '__main__':
    initialize_database()
