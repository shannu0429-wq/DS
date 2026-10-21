import sys
import argparse
from db import query_db, test_db_connection
from auth import hash_password

def setup_admin(full_name, email, mobile, password):
    connected, msg = test_db_connection()
    if not connected:
        print(f"Error: {msg}")
        return False
    
    existing = query_db("SELECT id, email, role FROM users WHERE email = %s", (email,), one=True)
    p_hash = hash_password(password)
    
    if existing:
        query_db(
            "UPDATE users SET full_name = %s, mobile_number = %s, password_hash = %s, role = 'admin' WHERE id = %s",
            (full_name, mobile, p_hash, existing['id']),
            commit=True
        )
        print(f"Administrator account '{email}' updated successfully.")
    else:
        query_db(
            "INSERT INTO users (full_name, email, mobile_number, password_hash, role, preferred_language) VALUES (%s, %s, %s, %s, 'admin', 'en')",
            (full_name, email, mobile, p_hash),
            commit=True
        )
        print(f"Administrator account '{email}' created successfully.")
    return True

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Secure Administrator Setup for DigitalSaathi")
    parser.add_argument('--name', default='Administrator', help="Admin full name")
    parser.add_argument('--email', default='admin@digitalsaathi.org', help="Admin email address")
    parser.add_argument('--mobile', default='9876543210', help="Admin contact number")
    parser.add_argument('--password', default='Admin@123', help="Admin secure password")
    args = parser.parse_args()
    
    setup_admin(args.name, args.email, args.mobile, args.password)
