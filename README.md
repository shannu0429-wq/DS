# DigitalSaathi — Digital Literacy and Online Safety for Senior Citizens

**DigitalSaathi** is an accessible, bilingual web application designed specifically for senior citizens and elderly individuals to master smartphone fundamentals, understand digital payment security, recognize online frauds, and request one-on-one volunteer assistance.

---

## 1. Technology Restrictions & Enforced Stack

- **Frontend:** HTML5, CSS3, Vanilla JavaScript (responsive, accessible, large fonts, Noto Sans Telugu)
- **Backend:** Python 3 with Flask
- **Database:** MySQL 8.0 (`mysql-connector-python`)
- **Session Management:** Flask client sessions with secure cookie options
- **Authentication:** Werkzeug `scrypt` password hashing
- **Deployment:** Gunicorn WSGI server, Procfile, TLS/SSL remote MySQL connection ready
- **Zero AI / External APIs:** 100% self-contained application without third-party LLMs or paid external services
- **Code Standards:** Clean, professional, comments-free source code

---

## 2. Complete Multi-Page Application Architecture

DigitalSaathi is structured into 23 functional pages and dedicated views:

### Public Pages
1. **Home (`/`)**: Introduction to DigitalSaathi, key feature highlights, core learning links, quick calls-to-action.
2. **About (`/about`)**: Explanation of mission, challenges faced by seniors, and our accessible bilingual approach.
3. **Learn (`/tutorials`)**: Filterable educational tutorial catalogue with category filtering and completion indicators.
4. **Smartphone Basics (`/smartphone-basics`)**: Dedicated guide covering calling, contacts, WhatsApp, Wi-Fi, volume/screen settings, and accessibility.
5. **Digital Payment Safety (`/payment-safety`)**: Golden rule of UPI, OTP protection, QR code security, and immediate scam response steps.
6. **Online Scam Awareness (`/scam-awareness`)**: Real-world fraud patterns: fake customer care numbers, screen sharing (AnyDesk), urgent power bill threats, fake lotteries.
7. **Quiz (`/quiz`)**: Dedicated interactive quiz with immediate scoring, detailed explanations, and score saving.
8. **Contact (`/contact`)**: Functional contact inquiry form and official national helpline directory (1930, 14567, 112, cybercrime.gov.in).
9. **Login (`/login`)**: Secure user authentication with redirect preservation.
10. **Register (`/register`)**: User registration with role selection (Senior Citizen or Volunteer) and validation.
11. **Forgot Password (`/forgot-password`)**: Self-contained password recovery by verifying registered email and mobile number.

### Authenticated Senior Citizen Pages
12. **User Dashboard (`/dashboard`)**: Welcome panel, learning progress percentage bar, enrolled tutorial shortcuts, recent help requests overview.
13. **Tutorial Details (`/tutorials/<id>`)**: Step-by-step instructions in English and Telugu with "Mark as Completed" button.
14. **Request Help (`/request-help`)**: Form to request personal assistance (phone call, WhatsApp, SMS, or in-person).
15. **My Help Requests (`/help-history`)**: Complete history of submitted requests, assigned volunteer name and phone, and resolution notes.
16. **Profile and Settings (`/profile`)**: Manage personal details, phone number, preferred language, and optional password update.

### Volunteer Pages
17. **Volunteer Dashboard (`/volunteer/dashboard`)**: Summary metrics of assigned requests (Pending, In Progress, Resolved) and request management cards.
18. **Request Details (`/volunteer/requests/<id>`)**: Complete request information, senior citizen contact details, and resolution summary update form.

### Administrator Pages
19. **Admin Dashboard (`/admin/dashboard`)**: Accurate metrics computed from real database records (registered users, seniors, volunteers, open/resolved requests).
20. **Manage Users (`/admin/users`)**: Search/filter users by role, toggle account active status.
21. **Manage Tutorials (`/admin/tutorials`)**: Create new bilingual tutorials and view the content catalogue.
22. **Edit Tutorial (`/admin/tutorials/<id>/edit`)**: Edit existing tutorial content and display ordering.
23. **Manage Help Requests (`/admin/requests`)**: View all help requests, filter by status, and assign volunteers.
24. **Manage Categories (`/admin/categories`)**: Maintain and create tutorial categories (slug, English name, Telugu name).

---

## 3. Directory Structure

```
website/
├── .env                  # Environment variables (ignored by Git)
├── .env.example          # Sample environment configuration template
├── .gitignore            # Git exclusion rules
├── app.py                # Main Flask application and routes
├── auth.py               # Authentication helpers & role decorators
├── config.py             # Configuration loader
├── create_admin.py       # CLI script for administrator creation
├── db.py                 # MySQL database connection & query utilities
├── init_remote_db.py     # Remote cloud database initializer
├── Procfile              # Production WSGI process specification
├── README.md             # Complete beginner-friendly documentation
├── requirements.txt      # Python dependencies
├── reset_db.py           # Safe database inspection and reset utility
├── schema.sql            # Complete database schema and seed data
├── seed_data.py          # Intentional sample demo records
├── static/
│   ├── css/
│   │   └── style.css     # Responsive styles, accessibility, dropdowns
│   ├── images/
│   │   └── logo.png      # Official DigitalSaathi brand logo
│   └── js/
│       └── app.js        # Language toggle, accessibility controls, quiz
├── templates/            # Jinja2 HTML templates
│   ├── 403.html
│   ├── 404.html
│   ├── 500.html
│   ├── about.html
│   ├── admin_dashboard.html
│   ├── base.html
│   ├── contact.html
│   ├── dashboard.html
│   ├── edit_tutorial.html
│   ├── forgot_password.html
│   ├── help_history.html
│   ├── index.html
│   ├── login.html
│   ├── manage_categories.html
│   ├── manage_requests.html
│   ├── manage_tutorials.html
│   ├── manage_users.html
│   ├── payment_safety.html
│   ├── profile.html
│   ├── quiz.html
│   ├── register.html
│   ├── request_help.html
│   ├── scam_awareness.html
│   ├── smartphone_basics.html
│   ├── tutorial_detail.html
│   ├── tutorials.html
│   ├── volunteer_dashboard.html
│   └── volunteer_request_detail.html
└── tests/
    ├── __init__.py
    └── test_app.py       # Comprehensive 21-test automated suite
```

---

## 4. Section A: Installation

### Prerequisites
- Python 3.10+ installed on Windows.
- MySQL Server 8.0 running locally (or remote MySQL credentials).

### 1. Open Windows PowerShell or Command Prompt
```powershell
cd C:\vvit\3-1\CSP\website
```

### 2. Create and Activate a Python Virtual Environment
```powershell
python -m venv venv
.\venv\Scripts\activate
```

### 3. Install Required Dependencies
```powershell
pip install -r requirements.txt
```

---

## 5. Section B: Fresh Database Setup

The application uses the database named `digitalsaathi_db`.

### 1. Configure `.env`
Create or update your `.env` file in `C:\vvit\3-1\CSP\website\.env`:
```ini
FLASK_ENV=development
SECRET_KEY=digitalsaathi_local_secret_key_2026
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=root
MYSQL_DATABASE=digitalsaathi_db
```

### 2. Inspect and Reset to a Fresh Database
Before performing any reset, `reset_db.py` inspects the database to prevent accidental data loss:
```powershell
python reset_db.py
```

To confirm and generate a completely clean, fresh database with all tables, initial categories, tutorials, quiz questions, and default administrator:
```powershell
python reset_db.py --confirm-reset
```

### 3. Initial Administrator Credentials
The fresh reset automatically provisions the default administrator account:
- **Email:** `admin@digitalsaathi.org`
- **Password:** `Admin@123`

You can also create or update any custom administrator account using `create_admin.py`:
```powershell
python create_admin.py --name "Platform Admin" --email "myadmin@example.com" --mobile "9876543210" --password "SecurePass@123"
```

---

## 6. Section C: Running the Website Locally

Run the following commands in your terminal:
```powershell
cd C:\vvit\3-1\CSP\website
python app.py
```

Open your browser and visit:
```
http://127.0.0.1:5000/
```

---

## 7. Section D: Using the Website by Role

### As a Visitor (Logged Out)
- **Browse Guides:** Access Home, About, Tutorials, Smartphone Basics, Payment Safety, and Scam Awareness.
- **Switch Languages:** Toggle between English and తెలుగు using the pill selector in the navbar.
- **Accessibility:** Use `A`, `A+`, `A++` to resize fonts, or click `Contrast` for high-contrast viewing.
- **Take Safety Quiz:** Open the Safety Quiz page to test fraud awareness with immediate explanations.
- **Contact:** Send an inquiry via the Contact form or access emergency helplines (1930, 14567, 112).

### As a Registered Senior Citizen
- **Register / Log In:** Register as a Senior Citizen or log in.
- **Track Progress:** View tutorial completion percentage on the dashboard.
- **Request Help:** Submit assistance requests with preferred contact method (Phone, WhatsApp, SMS, In-Person) and preferred time.
- **Track Requests:** View My Requests to see assigned volunteer name, mobile number, and resolution notes.
- **Manage Profile:** Update mobile number, preferred language, or password.

### As a Volunteer
- **Access Volunteer Portal:** Log in with volunteer credentials.
- **Assigned Requests:** View all senior citizen requests assigned to you.
- **Contact Senior:** Call or message the senior via phone or WhatsApp.
- **Update Status:** Change request status to `In Progress`, `Resolved`, or `Closed`, and record resolution notes.

### As an Administrator
- **Dashboard Metrics:** View real-time user count, senior count, volunteer count, total requests, pending, and resolved requests.
- **Manage Users:** Filter users by role, activate or deactivate accounts.
- **Manage Tutorials:** Publish new tutorials in English and Telugu, edit existing tutorials, or delete outdated content.
- **Manage Requests:** Review all incoming requests and assign volunteers from a dropdown.
- **Manage Categories:** Add new educational categories with English and Telugu names.

---

## 8. Section E: Troubleshooting Common Problems

1. **MySQL Connection Error (`Access denied` or `Can't connect to MySQL server`)**:
   - Check that the MySQL service is running in Windows Services (`services.msc` -> `MySQL80`).
   - Verify `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, and `MYSQL_PASSWORD` in your `.env` file.
2. **Missing Python Packages**:
   - Run `pip install -r requirements.txt`.
3. **Port 5000 Already in Use**:
   - Run `app.py` on a different port: `app.run(port=5001)`.
4. **Login Fails**:
   - Verify that your account is active (`is_active = 1`).
   - Reset the password using `/forgot-password` by entering your registered email and mobile number.
5. **Telugu Characters Not Displaying Correctly**:
   - Ensure the database is using `utf8mb4` encoding: `CREATE DATABASE digitalsaathi_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`.

---

## 9. Section F: Production Deployment to Render & Remote MySQL

1. **Remote Cloud MySQL (e.g., TiDB Cloud Serverless or Aiven)**:
   - Create a free MySQL cluster on TiDB Cloud or Aiven.
   - Note host, port, user, password, and database.
   - Run `python init_remote_db.py` pointed at the remote database to create tables and seed default content.
2. **Push to GitHub**:
   ```powershell
   git add .
   git commit -m "Production release of DigitalSaathi"
   git push origin main
   ```
3. **Deploy on Render**:
   - Create a new **Web Service** linked to your GitHub repository.
   - Build Command: `pip install -r requirements.txt`
   - Start Command: `gunicorn app:app`
   - Set Environment Variables:
     - `FLASK_ENV=production`
     - `SECRET_KEY=<strong-random-key>`
     - `MYSQL_HOST=<remote-host>`
     - `MYSQL_PORT=<remote-port>`
     - `MYSQL_USER=<remote-user>`
     - `MYSQL_PASSWORD=<remote-password>`
     - `MYSQL_DATABASE=<remote-database>`
     - `MYSQL_SSL_REQUIRED=true`
     - `SESSION_COOKIE_SECURE=true`
   - Render automatically provisions free HTTPS/TLS certificates.
