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
    # Pagination
    page = request.args.get("page", 1, type=int)
    limit = 6
    offset = (page - 1) * limit

    # Filters
    selected_programming_language = request.args.get("programming_language", "").strip()
    selected_difficulty = request.args.get("difficulty", "").strip()
    selected_source = request.args.get("source", "").strip()

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    base_query = "FROM courses WHERE 1=1"
    params = []

    if selected_programming_language:
        base_query += " AND programming_language = %s"
        params.append(selected_programming_language)

    if selected_difficulty:
        base_query += " AND difficulty = %s"
        params.append(selected_difficulty)

    if selected_source:
        base_query += " AND source = %s"
        params.append(selected_source)

    # ✅ Total count (FILTERED)
    count_query = "SELECT COUNT(*) AS total " + base_query
    cursor.execute(count_query, params)
    total = cursor.fetchone()["total"]

    total_pages = max(1, (total + limit - 1) // limit)

    # ✅ Prevent invalid page numbers
    if page > total_pages:
        page = total_pages
        offset = (page - 1) * limit

    # ✅ Fetch paginated data
    data_query = (
        "SELECT * " + base_query +
        " ORDER BY id DESC LIMIT %s OFFSET %s"
    )
    cursor.execute(data_query, params + [limit, offset])
    courses = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "courses.html",
        courses=courses,
        page=page,
        total_pages=total_pages,
        selected_programming_language=selected_programming_language,
        selected_difficulty=selected_difficulty,
        selected_source=selected_source
    )



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
