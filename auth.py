from functools import wraps
from flask import session, redirect, url_for, flash, request, abort
from werkzeug.security import generate_password_hash, check_password_hash

def hash_password(password):
    return generate_password_hash(password, method='scrypt')

def verify_password(stored_hash, password):
    return check_password_hash(stored_hash, password)

def is_authenticated():
    return 'user_id' in session

def current_user():
    if not is_authenticated():
        return None
    return {
        'id': session.get('user_id'),
        'name': session.get('user_name'),
        'email': session.get('user_email'),
        'role': session.get('user_role'),
        'lang': session.get('lang', 'en')
    }

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not is_authenticated():
            flash('Please log in to access this page.', 'warning')
            return redirect(url_for('login', next=request.path))
        return f(*args, **kwargs)
    return decorated_function

def role_required(allowed_roles):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if not is_authenticated():
                flash('Please log in to access this page.', 'warning')
                return redirect(url_for('login', next=request.path))
            user_role = session.get('user_role')
            if user_role not in allowed_roles:
                return abort(403)
            return f(*args, **kwargs)
        return decorated_function
    return decorator
