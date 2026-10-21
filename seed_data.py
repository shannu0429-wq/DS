from db import query_db, test_db_connection
from auth import hash_password

def seed_all():
    connected, msg = test_db_connection()
    if not connected:
        print(f"Error: {msg}")
        return False

    demo_users = [
        ('Ramachandra Rao', 'ramarao@example.com', '9848012345', 'Senior@123', 'senior', 'te'),
        ('Lakshmi Devi', 'lakshmi@example.com', '9848054321', 'Senior@123', 'senior', 'te'),
        ('Ananya Sharma', 'ananya.volunteer@digitalsaathi.org', '9440112233', 'Volunteer@123', 'volunteer', 'en'),
        ('Karthik Reddy', 'karthik.volunteer@digitalsaathi.org', '9440445566', 'Volunteer@123', 'volunteer', 'te')
    ]

    for name, email, mobile, pwd, role, lang in demo_users:
        existing = query_db("SELECT id FROM users WHERE email = %s", (email,), one=True)
        if not existing:
            p_hash = hash_password(pwd)
            query_db(
                "INSERT INTO users (full_name, email, mobile_number, password_hash, role, preferred_language) VALUES (%s, %s, %s, %s, %s, %s)",
                (name, email, mobile, p_hash, role, lang),
                commit=True
            )

    senior_1 = query_db("SELECT id FROM users WHERE email = 'ramarao@example.com'", one=True)
    senior_2 = query_db("SELECT id FROM users WHERE email = 'lakshmi@example.com'", one=True)
    vol_1 = query_db("SELECT id FROM users WHERE email = 'ananya.volunteer@digitalsaathi.org'", one=True)
    vol_2 = query_db("SELECT id FROM users WHERE email = 'karthik.volunteer@digitalsaathi.org'", one=True)

    if senior_1 and vol_1:
        existing_reqs = query_db("SELECT COUNT(*) as count FROM help_requests", one=True)
        if existing_reqs['count'] == 0:
            sample_requests = [
                (
                    senior_1['id'],
                    'Cannot see WhatsApp text clearly on my phone',
                    'The text on my WhatsApp messages is too small. I have difficulty reading without strain. Please help me make the text larger.',
                    'Phone Call',
                    'Morning 10 AM',
                    'Resolved',
                    vol_1['id'],
                    'Assisted Mr. Rama Rao via phone call and guided him to Android Settings > Display > Font Size. Enabled High-contrast text and resized WhatsApp chat font to Large.'
                ),
                (
                    senior_1['id'],
                    'Received strange SMS asking to pay electricity bill urgently',
                    'I received an SMS claiming my power will be disconnected at 9 PM tonight unless I call a number. Is this genuine?',
                    'WhatsApp',
                    'Afternoon 3 PM',
                    'Resolved',
                    vol_1['id'],
                    'Advised senior not to call the number or click any links. Verified with APCPDCL electricity bill portal that their bill was already cleared. Flagged SMS as standard cyber scam.'
                ),
                (
                    senior_2['id'],
                    'Help setting up voice call shortcut for my daughter in USA',
                    'I want to be able to tap one button on my screen to make a WhatsApp call to my daughter in Chicago without scrolling through contacts.',
                    'In-Person',
                    'Evening 5 PM',
                    'In Progress',
                    vol_2['id'],
                    'Scheduled a home visit with senior citizen along with student coordinator to create 1-tap contact widget.'
                ),
                (
                    senior_2['id'],
                    'Someone sent a QR code asking me to scan to receive pension arrears',
                    'A caller claiming to be from social welfare office sent a QR code and told me scanning it will deposit 3,000 rupees into my bank account.',
                    'Phone Call',
                    'Immediate',
                    'Assigned',
                    vol_2['id'],
                    'Volunteer assigned. Immediate alert sent: NEVER SCAN QR CODE TO RECEIVE MONEY.'
                )
            ]
            for uid, subj, desc, method, time_pref, status, vid, resolution in sample_requests:
                query_db(
                    "INSERT INTO help_requests (user_id, subject, description, preferred_contact_method, preferred_contact_time, status, volunteer_id, resolution_summary) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
                    (uid, subj, desc, method, time_pref, status, vid, resolution),
                    commit=True
                )

        existing_progress = query_db("SELECT COUNT(*) as count FROM tutorial_progress", one=True)
        if existing_progress['count'] == 0:
            query_db("INSERT INTO tutorial_progress (user_id, tutorial_id, completed) VALUES (%s, 1, 1), (%s, 2, 1), (%s, 6, 1)", (senior_1['id'], senior_1['id'], senior_1['id']), commit=True)
            query_db("INSERT INTO tutorial_progress (user_id, tutorial_id, completed) VALUES (%s, 1, 1), (%s, 7, 1)", (senior_2['id'], senior_2['id']), commit=True)

        existing_quizzes = query_db("SELECT COUNT(*) as count FROM quiz_results", one=True)
        if existing_quizzes['count'] == 0:
            query_db(
                "INSERT INTO quiz_results (user_id, score, total_questions, percentage, topic) VALUES (%s, 5, 5, 100.0, 'Scam Awareness Quiz'), (%s, 4, 5, 80.0, 'Scam Awareness Quiz')",
                (senior_1['id'], senior_2['id']),
                commit=True
            )

    print("Sample seed data created successfully!")
    return True

if __name__ == '__main__':
    seed_all()
