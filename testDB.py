import os, oracledb
from dotenv import load_dotenv

load_dotenv()

if __name__ == "__main__":
    username=os.getenv('DB_USERNAME')
    password=os.getenv('DB_PASS')
    connect_string=os.getenv('DB_NAME')
    connection = oracledb.connect(user=username, password=password, dsn=connect_string)

    cursor = connection.cursor()

    for row in cursor.execute("SELECT * FROM MMMB_EMPLEADO"):
        print(row)