import os, random, string
from flask import Flask
from datetime import timedelta

from app.database.oracle_db_connector import OracleDBConnector

from dotenv import load_dotenv

# Cargar configuraciones desde el archivo .env
load_dotenv()

def create_app():
    app = Flask(__name__)

    # Database
    app.config['oracle_db_connector'] = OracleDBConnector(
        username=os.getenv('DB_USERNAME'),
        password=os.getenv('DB_PASS'),
        connect_string=os.getenv('DB_NAME')
    )
    # Secret key
    SECRET_KEY = ''.join(random.choice( string.ascii_lowercase  ) for i in range( 32 ))
    app.config['SECRET_KEY'] = SECRET_KEY

    app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(minutes=30)

    return app

app = create_app()
