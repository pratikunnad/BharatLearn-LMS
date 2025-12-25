from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)

# --------------------
# DATABASE CONNECTION
# --------------------
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",          # put your MySQL password if any
        database="lms_db"     # change if your DB name is different
    )

# --------------------
# ROUTES
# --------------------
@app.route("/")
def home():
    return render_template("home.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    error = None

    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        query = "SELECT * FROM users WHERE email=%s AND password=%s"
        cursor.execute(query, (email, password))
        user = cursor.fetchone()

        cursor.close()
        conn.close()

        if user:
            return redirect(url_for("dashboard"))
        else:
            error = "Invalid email or password"

    return render_template("login.html", error=error)


@app.route("/dashboard")
def dashboard():
    return render_template("dashboard.html")


@app.route("/courses")
def courses():
    return render_template("courses.html")


if __name__ == "__main__":
    app.run(debug=True)
