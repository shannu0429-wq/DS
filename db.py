import mysql.connector
from mysql.connector import Error
from config import Config

def get_db_connection():
    try:
        connect_kwargs = {
            'host': Config.MYSQL_HOST,
            'port': Config.MYSQL_PORT,
            'user': Config.MYSQL_USER,
            'password': Config.MYSQL_PASSWORD,
            'database': Config.MYSQL_DATABASE,
            'charset': 'utf8mb4',
            'collation': 'utf8mb4_unicode_ci',
            'autocommit': False,
            'connection_timeout': 10
        }
        if Config.MYSQL_SSL_CA:
            connect_kwargs['ssl_ca'] = Config.MYSQL_SSL_CA
            connect_kwargs['ssl_disabled'] = False
        elif Config.MYSQL_SSL_REQUIRED:
            import certifi
            connect_kwargs['ssl_ca'] = certifi.where()
            connect_kwargs['ssl_disabled'] = False
        elif Config.MYSQL_SSL_DISABLED:
            connect_kwargs['ssl_disabled'] = True

        return mysql.connector.connect(**connect_kwargs)
    except Error as e:
        return None

def query_db(query, args=(), one=False, commit=False):
    connection = get_db_connection()
    if connection is None:
        raise ConnectionError("Unable to connect to MySQL database.")
    cursor = connection.cursor(dictionary=True)
    try:
        cursor.execute(query, args)
        if commit:
            connection.commit()
            last_id = cursor.lastrowid
            affected = cursor.rowcount
            return last_id if last_id else affected
        rv = cursor.fetchall()
        return (rv[0] if rv else None) if one else rv
    except Error as e:
        if commit:
            connection.rollback()
        raise e
    finally:
        cursor.close()
        connection.close()

def test_db_connection():
    try:
        connection = get_db_connection()
        if connection and connection.is_connected():
            connection.close()
            return True, "Database connected successfully"
        return False, "Database connection failed"
    except Exception as e:
        return False, str(e)
