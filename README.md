# DigitalSaathi — Digital Literacy and Online Safety for Senior Citizens

**DigitalSaathi** is a community-focused web platform created as a Community Service Project (CSP) at **Vasireddy Venkatadri Institute of Technology (VVIT)**. It is designed specifically for elderly citizens to comfortably learn smartphone essentials, master safe UPI payments, identify online cyber frauds, and request one-on-one assistance from student volunteers.

---

## 1. Technology Stack

- **Frontend:** HTML5, CSS3, Vanilla JavaScript (responsive, accessible, large fonts, Noto Sans Telugu)
- **Backend:** Python 3 (Flask)
- **Database:** MySQL 8.0 (Relational schema with foreign keys, utf8mb4 encoding)
- **Connector:** `mysql-connector-python`
- **Session Management:** Secure Flask sessions
- **Authentication:** Werkzeug `scrypt` password hashing

---

## 2. Key Features

1. **Bilingual English & Telugu Support:**
   - Real-time language switching from the navbar.
   - Centralized local translation dictionary for interface labels.
   - Dual-language database storage (`_en` and `_te` fields) for tutorials and educational lessons.
2. **Senior-Friendly Accessibility:**
   - 1-Click Font Size controls (`A`, `A+`, `A++`) with persistent preference.
   - High Contrast vision mode for seniors with low vision or cataracts.
   - Emergency National Cyber Crime Helpline (`1930`) banner.
3. **Role-Based Portals:**
   - **Senior Citizen Dashboard:** Learning progress tracker, quick help request form, previous request history.
   - **Volunteer Dashboard:** Assigned help requests, contact senior citizen via phone/WhatsApp, update progress and resolution notes.
   - **Administrator Control Panel:** Real-time database metrics, user management (active/inactive toggle), tutorial CRUD (English + Telugu), help request assignment.
4. **Interactive Learning & Assessment:**
   - Step-by-step smartphone guides with completion tracking.
   - Digital Payment Safety (UPI PIN golden rules, OTP secrecy).
   - Interactive Online Scam Awareness Quiz with immediate feedback and explanation.
5. **Real Field Photos & Community Impact:**
   - Gallery of actual community visits, surveys, and digital literacy workshops.

---

## 3. Project Directory Structure

```
website/
├── .env                  # Local environment configuration
├── .env.example          # Template environment file
├── .gitignore            # Git exclusion rules
├── app.py                # Main Flask application and routes
├── auth.py               # Authentication helpers & role decorators
├── config.py             # Configuration loader
├── create_admin.py       # CLI script for administrator creation
├── db.py                 # MySQL database connection & query utilities
├── README.md             # Project documentation and guide
├── requirements.txt      # Python dependencies
├── schema.sql            # MySQL schema and initial tutorials
├── seed_data.py          # Demo users, requests, and quiz results
├── static/
│   ├── css/
│   │   └── style.css     # Accessible, responsive styles
│   ├── images/
│   │   ├── logo.png      # Official DigitalSaathi logo
│   │   └── activities/   # Field survey photos
│   └── js/
│       └── app.js        # Language toggle, accessibility, and quiz engine
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
│   ├── help_history.html
│   ├── index.html
│   ├── login.html
│   ├── manage_tutorials.html
│   ├── manage_users.html
│   ├── payment_safety.html
│   ├── register.html
│   ├── request_help.html
│   ├── scam_awareness.html
│   ├── tutorial_detail.html
│   ├── tutorials.html
│   └── volunteer_dashboard.html
└── tests/
    └── test_app.py       # Automated unit and integration test suite
```

---

## 4. Setup and Installation on Windows

Follow these exact terminal commands in PowerShell or Command Prompt:

### Step 1: Open the Project Directory
```powershell
cd C:\vvit\3-1\CSP\website
```

### Step 2: Create and Activate Python Virtual Environment
```powershell
python -m venv venv
.\venv\Scripts\activate
```

### Step 3: Install Required Dependencies
```powershell
pip install -r requirements.txt
```

### Step 4: Configure the MySQL Database
Ensure your local MySQL service (`MySQL80`) is running. Then create and initialize the database:
```powershell
mysql -u root -p < schema.sql
```
*(Enter your MySQL root password when prompted)*

### Step 5: Configure Environment Variables
Copy `.env.example` to `.env` if not already present and configure your database password:
```ini
SECRET_KEY=digitalsaathi_super_secret_csp_key_2026_secure
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=admin
MYSQL_DATABASE=digitalsaathi_db
FLASK_ENV=development
```

### Step 6: Create Admin Account and Seed Demo Data
```powershell
python create_admin.py --email admin@digitalsaathi.org --password Admin@123
python seed_data.py
```

### Step 7: Run Automated Verification Tests
```powershell
python tests/test_app.py
```

### Step 8: Start the Flask Web Server
```powershell
python app.py
```

### Step 9: Open in Browser
Open your browser and navigate to:
```
http://127.0.0.1:5000
```

---

## 5. Demo Accounts

| Role | Email | Password | Access Area |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin@digitalsaathi.org` | `Admin@123` | `/admin/dashboard`, `/admin/users`, `/admin/tutorials` |
| **Senior Citizen** | `ramarao@example.com` | `Senior@123` | `/dashboard`, `/tutorials`, `/request-help`, `/help-history` |
| **Student Volunteer** | `ananya.volunteer@digitalsaathi.org` | `Volunteer@123` | `/volunteer/dashboard` |

---

## 6. Verification and Test Results

Run `python tests/test_app.py` to execute the full automated test suite covering:
- MySQL database connectivity
- Homepage loading and live statistics
- Language toggle (English & Telugu)
- Bilingual tutorial retrieval
- Digital payment safety guide
- Scam awareness and quiz scoring
- User registration and duplicate email protection
- Authentication and session handling
- Role-based route access controls (Senior, Volunteer, Admin)
- Volunteer assignment and help request tracking
- Custom 403, 404, and 500 error pages
