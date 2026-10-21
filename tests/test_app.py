import unittest
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import app
from db import query_db, test_db_connection

class DigitalSaathiTestCase(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        app.config['TESTING'] = True
        app.config['WTF_CSRF_ENABLED'] = False
        cls.client = app.test_client()

    def setUp(self):
        self.client.get('/logout')

    def test_database_connection(self):
        connected, msg = test_db_connection()
        self.assertTrue(connected, f"Database connection failed: {msg}")

    def test_homepage_loads(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'DigitalSaathi', response.data)

    def test_language_toggle(self):
        res_te = self.client.get('/set-language/te', follow_redirects=True)
        self.assertEqual(res_te.status_code, 200)
        with self.client.session_transaction() as sess:
            self.assertEqual(sess.get('lang'), 'te')

        res_en = self.client.get('/set-language/en', follow_redirects=True)
        self.assertEqual(res_en.status_code, 200)
        with self.client.session_transaction() as sess:
            self.assertEqual(sess.get('lang'), 'en')

    def test_tutorials_page(self):
        response = self.client.get('/tutorials')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Smartphone Basics', response.data)

    def test_tutorial_detail_page(self):
        response = self.client.get('/tutorials/1')
        self.assertEqual(response.status_code, 200)

    def test_telugu_tutorial_rendering(self):
        self.client.get('/set-language/te', follow_redirects=True)
        response = self.client.get('/tutorials/1')
        self.assertEqual(response.status_code, 200)
        self.assertIn('ఆన్ చేయడం'.encode('utf-8'), response.data)

    def test_payment_safety_page(self):
        response = self.client.get('/payment-safety')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'UPI', response.data)

    def test_scam_awareness_page(self):
        response = self.client.get('/scam-awareness')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Scam', response.data)

    def test_quiz_submission(self):
        payload = {
            'score': 5,
            'total_questions': 5,
            'topic': 'Unit Test Quiz'
        }
        response = self.client.post('/quiz/submit', json=payload)
        self.assertEqual(response.status_code, 200)
        json_data = response.get_json()
        self.assertTrue(json_data.get('success'))
        self.assertEqual(json_data.get('percentage'), 100.0)

    def test_registration_validation(self):
        mismatch_res = self.client.post('/register', data={
            'full_name': 'Test User',
            'email': 'newuser1@example.com',
            'mobile_number': '9876543210',
            'password': 'Password123',
            'confirm_password': 'WrongPassword',
            'role': 'senior',
            'preferred_language': 'en'
        }, follow_redirects=True)
        self.assertIn(b'Passwords do not match', mismatch_res.data)

        duplicate_res = self.client.post('/register', data={
            'full_name': 'Duplicate User',
            'email': 'ramarao@example.com',
            'mobile_number': '9876543210',
            'password': 'Password123',
            'confirm_password': 'Password123',
            'role': 'senior',
            'preferred_language': 'en'
        }, follow_redirects=True)
        self.assertIn(b'already exists', duplicate_res.data)

    def test_login_invalid_credentials(self):
        response = self.client.post('/login', data={
            'email': 'nonexistent@example.com',
            'password': 'wrongpassword'
        }, follow_redirects=True)
        self.assertIn(b'Invalid email address or password', response.data)

    def test_senior_login_and_dashboard(self):
        response = self.client.post('/login', data={
            'email': 'ramarao@example.com',
            'password': 'Senior@123'
        }, follow_redirects=True)
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Ramachandra Rao', response.data)

        dash_res = self.client.get('/dashboard')
        self.assertEqual(dash_res.status_code, 200)

        logout_res = self.client.get('/logout', follow_redirects=True)
        self.assertIn(b'logged out', logout_res.data)

    def test_admin_access_control(self):
        unauth_res = self.client.get('/admin/dashboard')
        self.assertEqual(unauth_res.status_code, 302)

        self.client.post('/login', data={
            'email': 'ramarao@example.com',
            'password': 'Senior@123'
        }, follow_redirects=True)
        forbidden_res = self.client.get('/admin/dashboard')
        self.assertEqual(forbidden_res.status_code, 403)
        self.client.get('/logout')

        self.client.post('/login', data={
            'email': 'admin@digitalsaathi.org',
            'password': 'Admin@123'
        }, follow_redirects=True)
        admin_res = self.client.get('/admin/dashboard')
        self.assertEqual(admin_res.status_code, 200)
        self.assertIn(b'Administration', admin_res.data)
        self.client.get('/logout')

    def test_volunteer_dashboard_access(self):
        self.client.post('/login', data={
            'email': 'ananya.volunteer@digitalsaathi.org',
            'password': 'Volunteer@123'
        }, follow_redirects=True)
        vol_res = self.client.get('/volunteer/dashboard')
        self.assertEqual(vol_res.status_code, 200)
        self.assertIn(b'Volunteer Dashboard', vol_res.data)
        self.client.get('/logout')

    def test_help_request_creation_and_history(self):
        self.client.post('/login', data={
            'email': 'ramarao@example.com',
            'password': 'Senior@123'
        }, follow_redirects=True)

        req_res = self.client.post('/request-help', data={
            'subject': 'Automated Test Help Request',
            'description': 'This is a test request created by automated test suite.',
            'preferred_contact_method': 'Phone Call',
            'preferred_contact_time': 'Morning 11 AM'
        }, follow_redirects=True)
        self.assertEqual(req_res.status_code, 200)
        self.assertIn(b'Automated Test Help Request', req_res.data)

        history_res = self.client.get('/help-history')
        self.assertEqual(history_res.status_code, 200)
        self.assertIn(b'Automated Test Help Request', history_res.data)
        self.client.get('/logout')

    def test_about_and_contact_pages(self):
        res_about = self.client.get('/about')
        self.assertEqual(res_about.status_code, 200)
        self.assertIn(b'Vasireddy Venkatadri', res_about.data)

        res_contact = self.client.get('/contact')
        self.assertEqual(res_contact.status_code, 200)
        self.assertIn(b'1930', res_contact.data)

    def test_health_endpoint(self):
        response = self.client.get('/health')
        self.assertEqual(response.status_code, 200)
        data = response.get_json()
        self.assertEqual(data.get('status'), 'healthy')
        self.assertEqual(data.get('database'), 'connected')

    def test_404_page(self):
        response = self.client.get('/nonexistent-page-route')
        self.assertEqual(response.status_code, 404)
        self.assertIn(b'404', response.data)

if __name__ == '__main__':
    unittest.main()
