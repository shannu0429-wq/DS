import sys
import argparse
from db import get_db_connection, test_db_connection
from auth import hash_password

def check_existing_data():
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    counts = {}
    try:
        cur.execute("SELECT COUNT(*) as count FROM users")
        counts['users'] = cur.fetchone()['count']
        cur.execute("SELECT COUNT(*) as count FROM help_requests")
        counts['help_requests'] = cur.fetchone()['count']
        cur.execute("SELECT COUNT(*) as count FROM quiz_results")
        counts['quiz_results'] = cur.fetchone()['count']
    except Exception as e:
        counts['error'] = str(e)
    finally:
        cur.close()
        conn.close()
    return counts

def reset_database(confirmed=False):
    connected, msg = test_db_connection()
    if not connected:
        print(f"Database connection failed: {msg}")
        return False

    counts = check_existing_data()
    total_records = counts.get('users', 0) + counts.get('help_requests', 0) + counts.get('quiz_results', 0)

    if total_records > 0 and not confirmed:
        print("\n[SAFETY NOTICE] Existing database records detected in digitalsaathi_db:")
        print(f"  - Users: {counts.get('users', 0)}")
        print(f"  - Help Requests: {counts.get('help_requests', 0)}")
        print(f"  - Quiz Results: {counts.get('quiz_results', 0)}")
        print("\nTo prevent accidental data loss, reset will not proceed automatically.")
        print("To proceed with a clean, fresh database, run:")
        print("  python reset_db.py --confirm-reset\n")
        return False

    print("\nProceeding with clean database initialization...")
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute("SET FOREIGN_KEY_CHECKS = 0")
        for table in ['request_assignments', 'help_requests', 'tutorial_progress', 'quiz_results', 'users']:
            cur.execute(f"DROP TABLE IF EXISTS {table}")
        cur.execute("SET FOREIGN_KEY_CHECKS = 1")
        conn.commit()

        with open('schema.sql', 'r', encoding='utf-8') as f:
            sql = f.read()

        statements = [s.strip() for s in sql.split(';') if s.strip()]
        for stmt in statements:
            cur.execute(stmt)
        conn.commit()

        admin_pwd_hash = hash_password('Admin@123')
        cur.execute(
            "INSERT INTO users (full_name, email, mobile_number, password_hash, role, preferred_language) VALUES (%s, %s, %s, %s, 'admin', 'en')",
            ('Administrator', 'admin@digitalsaathi.org', '9876543210', admin_pwd_hash)
        )
        conn.commit()
        print("Database digitalsaathi_db has been reset to a fresh state.")
        print("Default administrator created:")
        print("  Email: admin@digitalsaathi.org")
        print("  Password: Admin@123")
        return True
    except Exception as e:
        print(f"Reset failed: {e}")
        return False
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Fresh Database Setup for DigitalSaathi")
    parser.add_argument('--confirm-reset', action='store_true', help="Confirm reset of digitalsaathi_db")
    args = parser.parse_args()
    reset_database(confirmed=args.confirm_reset)
