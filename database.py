import os
import mysql.connector

def get_db_connection():
    return mysql.connector.connect(
        MYSQL_HOST=os.environ.get("turntable.proxy.rlwy.net"),
        MYSQL_USER=os.environ.get("root"),
        MYSQL_PASSWORD=os.environ.get("OzovYlCXSoNwiMHdJdInuOOuBLEvempI"),
        MYSQL_DATABASE=os.environ.get("railway"),
        MYSQL_PORT=os.environ.get("46671"),
        ssl_disabled=False
    )
