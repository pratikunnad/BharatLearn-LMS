from flask import Flask, render_template, request, redirect, url_for, jsonify
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

@app.route("/student/dashboard")
def student_dashboard():
    if "role" not in session or session["role"] != "student":
        return redirect("/login")
    return render_template("student_dashboard.html")

@app.route("/some-route")
def some_function():
    # ALL CODE MUST BE HERE
    conn = get_db_connection()
    cursor = conn.cursor()
    return render_template("file.html")


@app.route("/courses")
def courses():
    # Pagination
    page = request.args.get("page", 1, type=int)
    limit = 6
    offset = (page - 1) * limit

    # Filters
    search = request.args.get("search", "").strip()
    selected_programming_language = request.args.get("programming_language", "").strip()
    selected_difficulty = request.args.get("difficulty", "").strip()
    selected_source = request.args.get("source", "").strip()

    user_id = session.get("user_id")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Base query (alias is IMPORTANT)
    base_query = "FROM courses c WHERE 1=1"
    params = []

    # Search
    if search:
        base_query += " AND (c.title LIKE %s OR c.description LIKE %s)"
        params.extend([f"%{search}%", f"%{search}%"])

    if selected_programming_language:
        base_query += " AND c.programming_language = %s"
        params.append(selected_programming_language)

    if selected_difficulty:
        base_query += " AND c.difficulty = %s"
        params.append(selected_difficulty)

    if selected_source:
        base_query += " AND c.source = %s"
        params.append(selected_source)

    # Total count
    count_query = "SELECT COUNT(*) AS total " + base_query
    cursor.execute(count_query, params)
    total = cursor.fetchone()["total"]

    total_pages = max(1, (total + limit - 1) // limit)

    if page > total_pages:
        page = total_pages
        offset = (page - 1) * limit

    # Fetch courses with enrollment status
    if user_id:
        data_query = """
            SELECT c.*,
            IF(
                EXISTS (
                    SELECT 1 FROM enrollments e
                    WHERE e.course_id = c.id AND e.user_id = %s
                ),
                1, 0
            ) AS is_enrolled
        """ + base_query + """
            ORDER BY c.id DESC
            LIMIT %s OFFSET %s
        """
        cursor.execute(data_query, [user_id] + params + [limit, offset])
    else:
        data_query = """
            SELECT c.*, 0 AS is_enrolled
        """ + base_query + """
            ORDER BY c.id DESC
            LIMIT %s OFFSET %s
        """
        cursor.execute(data_query, params + [limit, offset])

    courses = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "courses.html",
        courses=courses,
        page=page,
        total_pages=total_pages,
        search=search,
        selected_programming_language=selected_programming_language,
        selected_difficulty=selected_difficulty,
        selected_source=selected_source
    )


@app.route("/enroll/<int:course_id>", methods=["POST"])
def enroll(course_id):
    if "user_id" not in session:
        return jsonify({"success": False}), 401

    user_id = session["user_id"]

    conn = get_db_connection()
    cursor = conn.cursor()

    # prevent duplicate enroll
    cursor.execute(
        "SELECT 1 FROM enrollments WHERE user_id=%s AND course_id=%s",
        (user_id, course_id)
    )
    if cursor.fetchone():
        cursor.close()
        conn.close()
        return jsonify({"success": True})

    cursor.execute(
        "INSERT INTO enrollments (user_id, course_id, enrolled_at) VALUES (%s, %s, NOW())",
        (user_id, course_id)
    )

    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({"success": True})



@app.route("/my-enrollments")
def my_enrollments():
    if "user_id" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    query = """
        SELECT 
            c.*,
            e.enrolled_at
        FROM enrollments e
        JOIN courses c ON c.id = e.course_id
        WHERE e.user_id = %s
        ORDER BY e.enrolled_at DESC
    """
    cursor.execute(query, (session["user_id"],))
    courses = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("my_enrollments.html", courses=courses)

@app.route("/unenroll/<int:course_id>", methods=["POST"])
def unenroll(course_id):
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute(
        "DELETE FROM enrollments WHERE user_id=%s AND course_id=%s",
        (user_id, course_id)
    )

    conn.commit()
    cursor.close()
    conn.close()

    return redirect("/my-enrollments")


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


@app.route("/admin/enrollments")
def admin_enrollments():
    if "role" not in session or session["role"] != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            e.id AS enrollment_id,
            u.id AS user_id,
            u.name AS student_name,
            u.email,
            c.id AS course_id,
            c.title AS course_title,
            e.enrolled_at
        FROM enrollments e
        JOIN users u ON e.user_id = u.id
        JOIN courses c ON e.course_id = c.id
        ORDER BY e.enrolled_at DESC
    """)

    enrollments = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "admin_enrollments.html",
        enrollments=enrollments
    )

@app.route("/admin/unenroll/<int:enrollment_id>", methods=["POST"])
def admin_unenroll(enrollment_id):
    if "role" not in session or session["role"] != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute(
        "DELETE FROM enrollments WHERE id = %s",
        (enrollment_id,)
    )

    conn.commit()
    cursor.close()
    conn.close()

    return redirect("/admin/enrollments")


if __name__ == "__main__":
    app.run(debug=True)
