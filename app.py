from flask import Flask, render_template, request, redirect, url_for
from flask import session
import mysql.connector

app = Flask(__name__)

app.secret_key = "bharatlearn_secret_key"

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

        if user and user["password"] == password:
            session["user_id"] = user["id"]
            session["role"] = user["role"]

            if user["role"] == "admin":
                return redirect(url_for("admin_dashboard"))
            else:
                return redirect(url_for("student_dashboard"))
        else:
            error = "Invalid email or password"

    return render_template("login.html", error=error)

@app.route("/register", methods=["GET", "POST"])
def register():
    message = None

    if request.method == "POST":
        name = request.form["name"]
        email = request.form["email"]
        password = request.form["password"]

        conn = get_db_connection()
        cursor = conn.cursor()

        try:
            query = """
            INSERT INTO users (name, email, password, role)
            VALUES (%s, %s, %s, 'student')
            """
            cursor.execute(query, (name, email, password))
            conn.commit()
            message = "Registration successful. Please login."
        except:
            message = "Email already exists."
        finally:
            cursor.close()
            conn.close()

    return render_template("register.html", message=message)

@app.route("/student")
def student_dashboard():
    if "role" not in session or session["role"] != "student":
        return redirect("/login")
    return render_template("student_dashboard.html")

@app.route("/dashboard")
def dashboard():
    return render_template("dashboard.html")


@app.route("/courses")
def courses():
    programming_language = request.args.get("programming_language")
    difficulty = request.args.get("difficulty")
    source = request.args.get("source")

    query = "SELECT * FROM courses WHERE 1=1"
    params = []

    if programming_language:
        query += " AND LOWER(programming_language) = LOWER(%s)"
        params.append(programming_language)

    if difficulty:
        query += " AND LOWER(difficulty) = LOWER(%s)"
        params.append(difficulty)

    if source:
        query += " AND LOWER(source) = LOWER(%s)"
        params.append(source)

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(query, params)
    courses = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template("courses.html", courses=courses)


@app.route("/admin/add-course", methods=["GET", "POST"])
def add_course():
    if "role" not in session or session["role"] != "admin":
        return redirect("/login")
    
    if request.method == "POST":
        title = request.form["title"]
        description = request.form["description"]
        programming_language = request.form["programming_language"]
        audio_language = request.form["audio_language"]
        difficulty = request.form["difficulty"]
        source = request.form["source"]
        course_link = request.form["course_link"]
        image_url = request.form["image_url"]

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO courses 
            (title, description, programming_language, audio_language, difficulty, source, course_link, image_url)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            title, description, programming_language,
            audio_language, difficulty, source,
            course_link, image_url
        ))

        conn.commit()
        cursor.close()
        conn.close()

        return redirect("/admin/dashboard")

    return render_template("add_course.html")


@app.route("/student/courses")
def view_courses():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM courses")
    courses = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("student_courses.html", courses=courses)

@app.route("/admin/dashboard")
def admin_dashboard():
    if "role" not in session or session["role"] != "admin":
        return redirect("/login")
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM courses")
    courses = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("admin_dashboard.html", courses=courses)

@app.route("/logout")
def logout():
    session.clear()
    return redirect("/login")



if __name__ == "__main__":
    app.run(debug=True)
