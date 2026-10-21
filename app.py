import os
import re
from flask import (
    Flask, render_template, request, redirect, url_for,
    flash, session, jsonify, abort
)
from config import Config
from db import query_db, test_db_connection
from auth import (
    hash_password, verify_password, login_required,
    role_required, current_user, is_authenticated
)
from translations import get_text, TRANSLATIONS

app = Flask(__name__)
app.config.from_object(Config)

@app.context_processor
def inject_context():
    lang = session.get('lang', 'en')
    user = current_user()
    db_connected, _ = test_db_connection()
    return {
        'current_user': user,
        'is_auth': is_authenticated(),
        'lang': lang,
        't': lambda key, default='': get_text(key, lang, default),
        'db_connected': db_connected
    }

@app.route('/set-language/<lang>', methods=['GET', 'POST'])
def set_language(lang):
    if lang in ['en', 'te']:
        session['lang'] = lang
        if is_authenticated():
            user_id = session.get('user_id')
            try:
                query_db("UPDATE users SET preferred_language = %s WHERE id = %s", (lang, user_id), commit=True)
            except Exception:
                pass
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        return jsonify({'success': True, 'lang': session.get('lang', 'en')})
    referrer = request.referrer
    if referrer and ('login' in referrer or 'register' in referrer or 'set-language' not in referrer):
        return redirect(referrer)
    return redirect(url_for('index'))

@app.route('/')
def index():
    recent_tutorials = []
    try:
        recent_tutorials = query_db(
            "SELECT id, category, title_en, title_te, description_en, description_te, icon FROM tutorials ORDER BY display_order ASC LIMIT 4"
        )
    except Exception:
        recent_tutorials = []

    return render_template('index.html', recent_tutorials=recent_tutorials)

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/smartphone-basics')
def smartphone_basics():
    return render_template('smartphone_basics.html')

@app.route('/payment-safety')
def payment_safety():
    return render_template('payment_safety.html')

@app.route('/scam-awareness')
def scam_awareness():
    return render_template('scam_awareness.html')

@app.route('/quiz')
def quiz_page():
    return render_template('quiz.html')

@app.route('/quiz/submit', methods=['POST'])
def quiz_submit():
    data = request.get_json() or {}
    score = int(data.get('score', 0))
    total = int(data.get('total_questions', 5))
    topic = data.get('topic', 'Scam Awareness Quiz')
    percentage = round((score / total) * 100, 2) if total > 0 else 0

    user_id = session.get('user_id')
    try:
        query_db(
            "INSERT INTO quiz_results (user_id, score, total_questions, percentage, topic) VALUES (%s, %s, %s, %s, %s)",
            (user_id, score, total, percentage, topic),
            commit=True
        )
        return jsonify({'success': True, 'score': score, 'total': total, 'percentage': percentage})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        email = request.form.get('email', '').strip()
        subject = request.form.get('subject', '').strip()
        message = request.form.get('message', '').strip()

        if not name or not email or not subject or not message:
            flash('Please complete all required fields.', 'warning')
            return render_template('contact.html')

        flash('Thank you for reaching out to DigitalSaathi. Your message has been received.', 'success')
        return redirect(url_for('contact'))

    return render_template('contact.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if is_authenticated():
        role = session.get('user_role')
        if role == 'admin':
            return redirect(url_for('admin_dashboard'))
        elif role == 'volunteer':
            return redirect(url_for('volunteer_dashboard'))
        return redirect(url_for('dashboard'))

    if request.method == 'POST':
        full_name = request.form.get('full_name', '').strip()
        email = request.form.get('email', '').strip().lower()
        mobile = request.form.get('mobile_number', '').strip()
        password = request.form.get('password', '')
        confirm_password = request.form.get('confirm_password', '')
        preferred_lang = request.form.get('preferred_language', 'en')
        role = request.form.get('role', 'senior')

        if not full_name or not email or not mobile or not password or not confirm_password:
            flash('All required fields must be completed.', 'danger')
            return render_template('register.html')

        email_regex = r'^[\w\.-]+@[\w\.-]+\.\w+$'
        if not re.match(email_regex, email):
            flash('Please provide a valid email address.', 'danger')
            return render_template('register.html')

        digits_mobile = re.sub(r'\D', '', mobile)
        if len(digits_mobile) < 10:
            flash('Please enter a valid 10-digit mobile number.', 'danger')
            return render_template('register.html')

        if len(password) < 6:
            flash('Password must be at least 6 characters long.', 'danger')
            return render_template('register.html')

        if password != confirm_password:
            flash('Passwords do not match. Please re-enter carefully.', 'danger')
            return render_template('register.html')

        if role not in ['senior', 'volunteer']:
            role = 'senior'

        if preferred_lang not in ['en', 'te']:
            preferred_lang = 'en'

        try:
            existing = query_db("SELECT id FROM users WHERE email = %s", (email,), one=True)
            if existing:
                flash('An account with this email address already exists. Please log in.', 'warning')
                return render_template('register.html')

            p_hash = hash_password(password)
            query_db(
                "INSERT INTO users (full_name, email, mobile_number, password_hash, role, preferred_language) VALUES (%s, %s, %s, %s, %s, %s)",
                (full_name, email, digits_mobile, p_hash, role, preferred_lang),
                commit=True
            )
            flash('Registration successful! Please log in with your credentials.', 'success')
            return redirect(url_for('login'))
        except Exception:
            flash('Database service is currently unavailable. Please verify MySQL configuration.', 'danger')
            return render_template('register.html')

    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if is_authenticated():
        role = session.get('user_role')
        if role == 'admin':
            return redirect(url_for('admin_dashboard'))
        elif role == 'volunteer':
            return redirect(url_for('volunteer_dashboard'))
        return redirect(url_for('dashboard'))

    if request.method == 'POST':
        email = request.form.get('email', '').strip().lower()
        password = request.form.get('password', '')

        if not email or not password:
            flash('Please provide both email and password.', 'warning')
            return render_template('login.html')

        try:
            user = query_db(
                "SELECT id, full_name, email, password_hash, role, preferred_language, is_active FROM users WHERE email = %s",
                (email,),
                one=True
            )

            if not user or not verify_password(user['password_hash'], password):
                flash('Invalid email address or password. Please try again.', 'danger')
                return render_template('login.html')

            if not user['is_active']:
                flash('Your account has been deactivated. Please contact support.', 'danger')
                return render_template('login.html')

            session.clear()
            session['user_id'] = user['id']
            session['user_name'] = user['full_name']
            session['user_email'] = user['email']
            session['user_role'] = user['role']
            session['lang'] = user['preferred_language'] or 'en'

            flash(f"Welcome back, {user['full_name']}!", 'success')

            next_page = request.args.get('next')
            if next_page and next_page.startswith('/'):
                return redirect(next_page)

            if user['role'] == 'admin':
                return redirect(url_for('admin_dashboard'))
            elif user['role'] == 'volunteer':
                return redirect(url_for('volunteer_dashboard'))
            return redirect(url_for('dashboard'))

        except Exception:
            flash('Database connection failed. Please ensure MySQL server is running.', 'danger')
            return render_template('login.html')

    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out safely.', 'info')
    return redirect(url_for('login'))

@app.route('/forgot-password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form.get('email', '').strip().lower()
        mobile = request.form.get('mobile_number', '').strip()
        new_password = request.form.get('new_password', '')
        confirm_password = request.form.get('confirm_password', '')

        if not email or not mobile or not new_password or not confirm_password:
            flash('All fields are required.', 'warning')
            return render_template('forgot_password.html')

        if new_password != confirm_password:
            flash('New passwords do not match.', 'danger')
            return render_template('forgot_password.html')

        if len(new_password) < 6:
            flash('Password must be at least 6 characters long.', 'danger')
            return render_template('forgot_password.html')

        digits_mobile = re.sub(r'\D', '', mobile)

        try:
            user = query_db(
                "SELECT id FROM users WHERE email = %s AND mobile_number = %s AND is_active = 1",
                (email, digits_mobile),
                one=True
            )
            if not user:
                flash('No active account matches the provided email and mobile number.', 'danger')
                return render_template('forgot_password.html')

            p_hash = hash_password(new_password)
            query_db(
                "UPDATE users SET password_hash = %s WHERE id = %s",
                (p_hash, user['id']),
                commit=True
            )
            flash('Your password has been reset successfully. Please log in with your new password.', 'success')
            return redirect(url_for('login'))
        except Exception:
            flash('Failed to reset password due to database error.', 'danger')

    return render_template('forgot_password.html')

@app.route('/dashboard')
@login_required
def dashboard():
    user_id = session.get('user_id')
    user_name = session.get('user_name')

    total_tutorials = 0
    completed_tutorials = 0
    progress_percentage = 0
    my_requests = []
    tutorials_list = []

    try:
        tot_res = query_db("SELECT COUNT(*) as count FROM tutorials", one=True)
        if tot_res:
            total_tutorials = tot_res['count']

        comp_res = query_db("SELECT COUNT(*) as count FROM tutorial_progress WHERE user_id = %s AND completed = 1", (user_id,), one=True)
        if comp_res:
            completed_tutorials = comp_res['count']

        if total_tutorials > 0:
            progress_percentage = round((completed_tutorials / total_tutorials) * 100)

        my_requests = query_db(
            "SELECT hr.id, hr.subject, hr.description, hr.preferred_contact_method, hr.preferred_contact_time, hr.status, hr.resolution_summary, hr.created_at, u.full_name as volunteer_name, u.mobile_number as volunteer_mobile FROM help_requests hr LEFT JOIN users u ON hr.volunteer_id = u.id WHERE hr.user_id = %s ORDER BY hr.created_at DESC",
            (user_id,)
        )

        tutorials_list = query_db(
            "SELECT t.id, t.category, t.title_en, t.title_te, t.description_en, t.description_te, t.icon, (CASE WHEN tp.id IS NOT NULL THEN 1 ELSE 0 END) as is_completed FROM tutorials t LEFT JOIN tutorial_progress tp ON t.id = tp.tutorial_id AND tp.user_id = %s ORDER BY t.display_order ASC",
            (user_id,)
        )
    except Exception:
        pass

    return render_template(
        'dashboard.html',
        user_name=user_name,
        total_tutorials=total_tutorials,
        completed_tutorials=completed_tutorials,
        progress_percentage=progress_percentage,
        my_requests=my_requests,
        tutorials=tutorials_list
    )

@app.route('/profile', methods=['GET', 'POST'])
@login_required
def profile():
    user_id = session.get('user_id')
    user = query_db("SELECT id, full_name, email, mobile_number, role, preferred_language FROM users WHERE id = %s", (user_id,), one=True)
    if not user:
        abort(404)

    if request.method == 'POST':
        full_name = request.form.get('full_name', '').strip()
        mobile = request.form.get('mobile_number', '').strip()
        preferred_lang = request.form.get('preferred_language', 'en')
        current_pwd = request.form.get('current_password', '')
        new_pwd = request.form.get('new_password', '')
        confirm_pwd = request.form.get('confirm_password', '')

        if not full_name or not mobile:
            flash('Name and mobile number are required.', 'warning')
            return render_template('profile.html', user=user)

        digits_mobile = re.sub(r'\D', '', mobile)
        if len(digits_mobile) < 10:
            flash('Please enter a valid 10-digit mobile number.', 'warning')
            return render_template('profile.html', user=user)

        if preferred_lang not in ['en', 'te']:
            preferred_lang = 'en'

        try:
            if new_pwd:
                if not current_pwd:
                    flash('Current password is required to set a new password.', 'warning')
                    return render_template('profile.html', user=user)

                auth_user = query_db("SELECT password_hash FROM users WHERE id = %s", (user_id,), one=True)
                if not auth_user or not verify_password(auth_user['password_hash'], current_pwd):
                    flash('Current password is incorrect.', 'danger')
                    return render_template('profile.html', user=user)

                if new_pwd != confirm_pwd:
                    flash('New passwords do not match.', 'danger')
                    return render_template('profile.html', user=user)

                if len(new_pwd) < 6:
                    flash('New password must be at least 6 characters.', 'danger')
                    return render_template('profile.html', user=user)

                p_hash = hash_password(new_pwd)
                query_db(
                    "UPDATE users SET full_name = %s, mobile_number = %s, preferred_language = %s, password_hash = %s WHERE id = %s",
                    (full_name, digits_mobile, preferred_lang, p_hash, user_id),
                    commit=True
                )
            else:
                query_db(
                    "UPDATE users SET full_name = %s, mobile_number = %s, preferred_language = %s WHERE id = %s",
                    (full_name, digits_mobile, preferred_lang, user_id),
                    commit=True
                )

            session['user_name'] = full_name
            session['lang'] = preferred_lang
            flash('Profile updated successfully.', 'success')
            return redirect(url_for('profile'))
        except Exception:
            flash('Error updating profile.', 'danger')

    return render_template('profile.html', user=user)

@app.route('/tutorials')
def tutorials():
    category = request.args.get('category')
    user_id = session.get('user_id')

    try:
        if category:
            tutorials_data = query_db(
                "SELECT t.id, t.category, t.title_en, t.title_te, t.description_en, t.description_te, t.icon, (CASE WHEN tp.id IS NOT NULL THEN 1 ELSE 0 END) as is_completed FROM tutorials t LEFT JOIN tutorial_progress tp ON t.id = tp.tutorial_id AND tp.user_id = %s WHERE t.category = %s ORDER BY t.display_order ASC",
                (user_id, category)
            )
        else:
            tutorials_data = query_db(
                "SELECT t.id, t.category, t.title_en, t.title_te, t.description_en, t.description_te, t.icon, (CASE WHEN tp.id IS NOT NULL THEN 1 ELSE 0 END) as is_completed FROM tutorials t LEFT JOIN tutorial_progress tp ON t.id = tp.tutorial_id AND tp.user_id = %s ORDER BY t.display_order ASC",
                (user_id,)
            )
    except Exception:
        tutorials_data = []

    return render_template('tutorials.html', tutorials=tutorials_data, selected_category=category)

@app.route('/tutorials/<int:tutorial_id>')
def tutorial_detail(tutorial_id):
    user_id = session.get('user_id')
    tutorial = None
    is_completed = False

    try:
        tutorial = query_db("SELECT * FROM tutorials WHERE id = %s", (tutorial_id,), one=True)
        if not tutorial:
            abort(404)

        if user_id:
            prog = query_db("SELECT id FROM tutorial_progress WHERE user_id = %s AND tutorial_id = %s AND completed = 1", (user_id, tutorial_id), one=True)
            if prog:
                is_completed = True
    except Exception:
        abort(404)

    return render_template('tutorial_detail.html', tutorial=tutorial, is_completed=is_completed)

@app.route('/tutorials/<int:tutorial_id>/complete', methods=['POST'])
@login_required
def complete_tutorial(tutorial_id):
    user_id = session.get('user_id')
    try:
        query_db(
            "INSERT INTO tutorial_progress (user_id, tutorial_id, completed) VALUES (%s, %s, 1) ON DUPLICATE KEY UPDATE completed = 1, completed_at = CURRENT_TIMESTAMP",
            (user_id, tutorial_id),
            commit=True
        )
        flash('Tutorial marked as completed! Keep up the great learning.', 'success')
    except Exception:
        flash('Could not update tutorial progress.', 'danger')
    return redirect(url_for('tutorial_detail', tutorial_id=tutorial_id))

@app.route('/request-help', methods=['GET', 'POST'])
@login_required
def request_help():
    user_id = session.get('user_id')

    if request.method == 'POST':
        subject = request.form.get('subject', '').strip()
        description = request.form.get('description', '').strip()
        preferred_contact = request.form.get('preferred_contact_method', 'Phone Call')
        preferred_time = request.form.get('preferred_contact_time', '').strip()

        if not subject or not description:
            flash('Please enter both subject and description of your request.', 'warning')
            return render_template('request_help.html')

        if preferred_contact not in ['Phone Call', 'WhatsApp', 'SMS', 'In-Person']:
            preferred_contact = 'Phone Call'

        try:
            query_db(
                "INSERT INTO help_requests (user_id, subject, description, preferred_contact_method, preferred_contact_time, status) VALUES (%s, %s, %s, %s, %s, 'Pending')",
                (user_id, subject, description, preferred_contact, preferred_time),
                commit=True
            )
            flash('Your help request has been submitted. A dedicated volunteer will contact you shortly.', 'success')
            return redirect(url_for('help_history'))
        except Exception:
            flash('Failed to submit help request due to a database error.', 'danger')

    return render_template('request_help.html')

@app.route('/help-history')
@login_required
def help_history():
    user_id = session.get('user_id')
    try:
        requests = query_db(
            "SELECT hr.id, hr.subject, hr.description, hr.preferred_contact_method, hr.preferred_contact_time, hr.status, hr.resolution_summary, hr.created_at, u.full_name as volunteer_name, u.mobile_number as volunteer_mobile FROM help_requests hr LEFT JOIN users u ON hr.volunteer_id = u.id WHERE hr.user_id = %s ORDER BY hr.created_at DESC",
            (user_id,)
        )
    except Exception:
        requests = []
    return render_template('help_history.html', requests=requests)

@app.route('/volunteer/dashboard')
@role_required(['volunteer', 'admin'])
def volunteer_dashboard():
    volunteer_id = session.get('user_id')
    user_role = session.get('user_role')

    try:
        if user_role == 'admin':
            assigned_requests = query_db(
                "SELECT hr.id, hr.subject, hr.description, hr.preferred_contact_method, hr.preferred_contact_time, hr.status, hr.resolution_summary, hr.created_at, hr.user_id, senior.full_name as senior_name, senior.mobile_number as senior_mobile, senior.email as senior_email FROM help_requests hr JOIN users senior ON hr.user_id = senior.id ORDER BY hr.created_at DESC"
            )
        else:
            assigned_requests = query_db(
                "SELECT hr.id, hr.subject, hr.description, hr.preferred_contact_method, hr.preferred_contact_time, hr.status, hr.resolution_summary, hr.created_at, hr.user_id, senior.full_name as senior_name, senior.mobile_number as senior_mobile, senior.email as senior_email FROM help_requests hr JOIN users senior ON hr.user_id = senior.id WHERE hr.volunteer_id = %s ORDER BY hr.created_at DESC",
                (volunteer_id,)
            )

        pending_count = sum(1 for r in assigned_requests if r['status'] == 'Pending' or r['status'] == 'Assigned')
        in_progress_count = sum(1 for r in assigned_requests if r['status'] == 'In Progress')
        resolved_count = sum(1 for r in assigned_requests if r['status'] == 'Resolved')

    except Exception:
        assigned_requests = []
        pending_count = 0
        in_progress_count = 0
        resolved_count = 0

    return render_template(
        'volunteer_dashboard.html',
        requests=assigned_requests,
        pending_count=pending_count,
        in_progress_count=in_progress_count,
        resolved_count=resolved_count
    )

@app.route('/volunteer/requests/<int:request_id>')
@role_required(['volunteer', 'admin'])
def volunteer_request_detail(request_id):
    volunteer_id = session.get('user_id')
    user_role = session.get('user_role')

    try:
        req = query_db(
            "SELECT hr.*, senior.full_name as senior_name, senior.mobile_number as senior_mobile, senior.email as senior_email, vol.full_name as volunteer_name FROM help_requests hr JOIN users senior ON hr.user_id = senior.id LEFT JOIN users vol ON hr.volunteer_id = vol.id WHERE hr.id = %s",
            (request_id,),
            one=True
        )
        if not req:
            abort(404)

        if user_role != 'admin' and req['volunteer_id'] != volunteer_id:
            abort(403)

        return render_template('volunteer_request_detail.html', req=req)
    except Exception:
        abort(404)

@app.route('/volunteer/request/<int:request_id>/update', methods=['POST'])
@role_required(['volunteer', 'admin'])
def update_request_status(request_id):
    new_status = request.form.get('status')
    resolution_summary = request.form.get('resolution_summary', '').strip()
    volunteer_id = session.get('user_id')
    user_role = session.get('user_role')

    if new_status not in ['In Progress', 'Resolved', 'Closed']:
        flash('Invalid status selection.', 'warning')
        return redirect(url_for('volunteer_dashboard'))

    try:
        if user_role != 'admin':
            req = query_db("SELECT id, volunteer_id FROM help_requests WHERE id = %s", (request_id,), one=True)
            if not req or req['volunteer_id'] != volunteer_id:
                flash('You are not authorized to update this request.', 'danger')
                return redirect(url_for('volunteer_dashboard'))

        query_db(
            "UPDATE help_requests SET status = %s, resolution_summary = %s WHERE id = %s",
            (new_status, resolution_summary, request_id),
            commit=True
        )
        flash('Request status updated successfully.', 'success')
    except Exception:
        flash('Failed to update request.', 'danger')

    return redirect(url_for('volunteer_dashboard'))

@app.route('/admin/dashboard')
@role_required(['admin'])
def admin_dashboard():
    total_users = 0
    total_seniors = 0
    total_volunteers = 0
    total_requests = 0
    pending_requests = 0
    resolved_requests = 0
    recent_requests = []
    volunteers_list = []

    try:
        u_res = query_db("SELECT COUNT(*) as count FROM users", one=True)
        total_users = u_res['count'] if u_res else 0

        s_res = query_db("SELECT COUNT(*) as count FROM users WHERE role = 'senior'", one=True)
        total_seniors = s_res['count'] if s_res else 0

        v_res = query_db("SELECT COUNT(*) as count FROM users WHERE role = 'volunteer'", one=True)
        total_volunteers = v_res['count'] if v_res else 0

        r_res = query_db("SELECT COUNT(*) as count FROM help_requests", one=True)
        total_requests = r_res['count'] if r_res else 0

        p_res = query_db("SELECT COUNT(*) as count FROM help_requests WHERE status IN ('Pending', 'Assigned')", one=True)
        pending_requests = p_res['count'] if p_res else 0

        res_res = query_db("SELECT COUNT(*) as count FROM help_requests WHERE status = 'Resolved'", one=True)
        resolved_requests = res_res['count'] if res_res else 0

        recent_requests = query_db(
            "SELECT hr.id, hr.subject, hr.status, hr.created_at, senior.full_name as senior_name, vol.full_name as volunteer_name FROM help_requests hr JOIN users senior ON hr.user_id = senior.id LEFT JOIN users vol ON hr.volunteer_id = vol.id ORDER BY hr.created_at DESC LIMIT 8"
        )

        volunteers_list = query_db("SELECT id, full_name, mobile_number FROM users WHERE role = 'volunteer' AND is_active = 1")
    except Exception:
        pass

    return render_template(
        'admin_dashboard.html',
        total_users=total_users,
        total_seniors=total_seniors,
        total_volunteers=total_volunteers,
        total_requests=total_requests,
        pending_requests=pending_requests,
        resolved_requests=resolved_requests,
        recent_requests=recent_requests,
        volunteers=volunteers_list
    )

@app.route('/admin/users')
@role_required(['admin'])
def manage_users():
    role_filter = request.args.get('role')
    try:
        if role_filter in ['senior', 'volunteer', 'admin']:
            users = query_db("SELECT id, full_name, email, mobile_number, role, preferred_language, is_active, created_at FROM users WHERE role = %s ORDER BY created_at DESC", (role_filter,))
        else:
            users = query_db("SELECT id, full_name, email, mobile_number, role, preferred_language, is_active, created_at FROM users ORDER BY created_at DESC")
    except Exception:
        users = []
    return render_template('manage_users.html', users=users, selected_role=role_filter)

@app.route('/admin/users/<int:user_id>/toggle', methods=['POST'])
@role_required(['admin'])
def toggle_user(user_id):
    if user_id == session.get('user_id'):
        flash('You cannot deactivate your own administrative account.', 'warning')
        return redirect(url_for('manage_users'))

    try:
        user = query_db("SELECT id, is_active FROM users WHERE id = %s", (user_id,), one=True)
        if user:
            new_status = 0 if user['is_active'] else 1
            query_db("UPDATE users SET is_active = %s WHERE id = %s", (new_status, user_id), commit=True)
            flash('User active status updated.', 'success')
    except Exception:
        flash('Error updating user status.', 'danger')
    return redirect(url_for('manage_users'))

@app.route('/admin/tutorials', methods=['GET', 'POST'])
@role_required(['admin'])
def manage_tutorials():
    if request.method == 'POST':
        category = request.form.get('category', 'smartphone_basics')
        title_en = request.form.get('title_en', '').strip()
        title_te = request.form.get('title_te', '').strip()
        desc_en = request.form.get('description_en', '').strip()
        desc_te = request.form.get('description_te', '').strip()
        content_en = request.form.get('content_en', '').strip()
        content_te = request.form.get('content_te', '').strip()
        display_order = int(request.form.get('display_order', 0))
        icon = request.form.get('icon', 'book')

        if not title_en or not title_te or not desc_en or not desc_te or not content_en or not content_te:
            flash('All English and Telugu content fields are required.', 'warning')
            return redirect(url_for('manage_tutorials'))

        try:
            query_db(
                "INSERT INTO tutorials (category, title_en, title_te, description_en, description_te, content_en, content_te, display_order, icon) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
                (category, title_en, title_te, desc_en, desc_te, content_en, content_te, display_order, icon),
                commit=True
            )
            flash('New tutorial published successfully in English and Telugu.', 'success')
        except Exception:
            flash('Failed to create tutorial.', 'danger')
        return redirect(url_for('manage_tutorials'))

    try:
        all_tutorials = query_db("SELECT * FROM tutorials ORDER BY category, display_order ASC")
    except Exception:
        all_tutorials = []
    return render_template('manage_tutorials.html', tutorials=all_tutorials)

@app.route('/admin/tutorials/<int:tutorial_id>/edit', methods=['GET', 'POST'])
@role_required(['admin'])
def edit_tutorial(tutorial_id):
    try:
        tutorial = query_db("SELECT * FROM tutorials WHERE id = %s", (tutorial_id,), one=True)
        if not tutorial:
            abort(404)
    except Exception:
        abort(404)

    if request.method == 'POST':
        category = request.form.get('category', tutorial['category'])
        title_en = request.form.get('title_en', '').strip()
        title_te = request.form.get('title_te', '').strip()
        desc_en = request.form.get('description_en', '').strip()
        desc_te = request.form.get('description_te', '').strip()
        content_en = request.form.get('content_en', '').strip()
        content_te = request.form.get('content_te', '').strip()
        display_order = int(request.form.get('display_order', tutorial['display_order']))
        icon = request.form.get('icon', tutorial['icon'])

        if not title_en or not title_te or not desc_en or not desc_te or not content_en or not content_te:
            flash('All English and Telugu content fields are required.', 'warning')
            return render_template('edit_tutorial.html', tutorial=tutorial)

        try:
            query_db(
                "UPDATE tutorials SET category = %s, title_en = %s, title_te = %s, description_en = %s, description_te = %s, content_en = %s, content_te = %s, display_order = %s, icon = %s WHERE id = %s",
                (category, title_en, title_te, desc_en, desc_te, content_en, content_te, display_order, icon, tutorial_id),
                commit=True
            )
            flash('Tutorial updated successfully.', 'success')
            return redirect(url_for('manage_tutorials'))
        except Exception:
            flash('Failed to update tutorial.', 'danger')

    return render_template('edit_tutorial.html', tutorial=tutorial)

@app.route('/admin/tutorials/<int:tutorial_id>/delete', methods=['POST'])
@role_required(['admin'])
def delete_tutorial(tutorial_id):
    try:
        query_db("DELETE FROM tutorials WHERE id = %s", (tutorial_id,), commit=True)
        flash('Tutorial deleted successfully.', 'info')
    except Exception:
        flash('Failed to delete tutorial.', 'danger')
    return redirect(url_for('manage_tutorials'))

@app.route('/admin/requests')
@role_required(['admin'])
def admin_requests():
    status_filter = request.args.get('status')
    try:
        all_reqs = query_db(
            "SELECT hr.*, senior.full_name as senior_name, senior.mobile_number as senior_mobile, vol.full_name as volunteer_name FROM help_requests hr JOIN users senior ON hr.user_id = senior.id LEFT JOIN users vol ON hr.volunteer_id = vol.id ORDER BY hr.created_at DESC"
        )
        volunteers = query_db("SELECT id, full_name FROM users WHERE role = 'volunteer' AND is_active = 1")
    except Exception:
        all_reqs = []
        volunteers = []

    all_count = len(all_reqs)
    pending_count = sum(1 for r in all_reqs if r['status'] == 'Pending')
    assigned_count = sum(1 for r in all_reqs if r['status'] == 'Assigned')
    in_progress_count = sum(1 for r in all_reqs if r['status'] == 'In Progress')
    resolved_count = sum(1 for r in all_reqs if r['status'] == 'Resolved')

    if status_filter:
        filtered_reqs = [r for r in all_reqs if r['status'] == status_filter]
    else:
        filtered_reqs = all_reqs

    return render_template(
        'manage_requests.html',
        requests=filtered_reqs,
        volunteers=volunteers,
        selected_status=status_filter,
        all_count=all_count,
        pending_count=pending_count,
        assigned_count=assigned_count,
        in_progress_count=in_progress_count,
        resolved_count=resolved_count
    )

@app.route('/admin/requests/<int:request_id>/assign', methods=['POST'])
@role_required(['admin'])
def assign_request(request_id):
    volunteer_id = request.form.get('volunteer_id')
    if not volunteer_id:
        flash('Please select a volunteer.', 'warning')
        return redirect(request.referrer or url_for('admin_dashboard'))

    try:
        query_db(
            "UPDATE help_requests SET volunteer_id = %s, status = 'Assigned' WHERE id = %s",
            (volunteer_id, request_id),
            commit=True
        )
        try:
            admin_id = session.get('user_id')
            query_db(
                "INSERT INTO request_assignments (request_id, volunteer_id, assigned_by) VALUES (%s, %s, %s)",
                (request_id, volunteer_id, admin_id),
                commit=True
            )
        except Exception:
            pass
        flash('Help request assigned to volunteer.', 'success')
    except Exception:
        flash('Failed to assign volunteer.', 'danger')

    return redirect(request.referrer or url_for('admin_dashboard'))

@app.route('/admin/categories', methods=['GET', 'POST'])
@role_required(['admin'])
def manage_categories():
    if request.method == 'POST':
        slug = request.form.get('slug', '').strip().lower()
        name_en = request.form.get('name_en', '').strip()
        name_te = request.form.get('name_te', '').strip()
        desc_en = request.form.get('description_en', '').strip()
        desc_te = request.form.get('description_te', '').strip()

        if not slug or not name_en or not name_te:
            flash('Slug, English name, and Telugu name are required.', 'warning')
            return redirect(url_for('manage_categories'))

        slug = re.sub(r'[^a-z0-9_]', '', slug)
        try:
            query_db(
                "INSERT INTO tutorial_categories (slug, name_en, name_te, description_en, description_te) VALUES (%s, %s, %s, %s, %s)",
                (slug, name_en, name_te, desc_en, desc_te),
                commit=True
            )
            flash('Category created successfully.', 'success')
        except Exception:
            flash('Failed to create category or category slug already exists.', 'danger')
        return redirect(url_for('manage_categories'))

    try:
        categories = query_db("SELECT * FROM tutorial_categories ORDER BY id ASC")
    except Exception:
        categories = []

    return render_template('manage_categories.html', categories=categories)

@app.route('/health')
def health_check():
    db_ok, msg = test_db_connection()
    status_code = 200 if db_ok else 503
    return jsonify({
        'status': 'healthy' if db_ok else 'degraded',
        'database': 'connected' if db_ok else 'disconnected',
        'message': msg
    }), status_code

@app.errorhandler(403)
def error_403(e=None):
    return render_template('403.html'), 403

@app.errorhandler(404)
def error_404(e=None):
    return render_template('404.html'), 404

@app.errorhandler(500)
def error_500(e=None):
    return render_template('500.html'), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
