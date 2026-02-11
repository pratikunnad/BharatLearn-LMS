from flask import Flask, render_template, request, redirect, url_for, jsonify, flash, session, abort
import mysql.connector
from datetime import datetime, timedelta, date, timezone
from werkzeug.security import generate_password_hash, check_password_hash
import os
from werkzeug.utils import secure_filename
import calendar

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

BASE_DIR = os.path.abspath(os.path.dirname(__file__))

UPLOAD_FOLDER = os.path.join(BASE_DIR, "static", "uploads", "profile")

app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "webp"}

def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


# --------------------
# ROUTES
# --------------------

@app.context_processor
def inject_year():
    return {"current_year": datetime.now().year}


@app.route("/")
def home():
    if session.get("user_id"):
        if session.get("role") == "learner":
            return redirect("/learner/dashboard")
        elif session.get("role") == "admin":
            return redirect("/admin/dashboard")
    return render_template("home.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    error = None

    if request.method == "POST":
        email = request.form["email"].strip()
        password = request.form["password"].strip()

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Only check email
        cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
        user = cursor.fetchone()

        cursor.close()
        conn.close()

        # Check password in Python
        if user and check_password_hash(user["password"], password):
            session["user_id"] = user["id"]
            session["role"] = user["role"]

            if user["role"] == "admin":
                return redirect(url_for("admin_dashboard"))
            else:
                return redirect(url_for("learner_dashboard"))
        else:
            flash("Invalid email or password", "danger")

    return render_template("login.html", error=error)


def admin_required():
    if "role" not in session or session["role"] != "admin":
        return redirect("/login")


@app.route("/register", methods=["GET", "POST"])
def register():
    message = None

    if request.method == "POST":
        name = request.form["name"].strip()
        email = request.form["email"].strip()
        password = request.form["password"].strip()
        confirm_password = request.form["confirm_password"].strip()

        hashed_password = generate_password_hash(password)

        # Password mismatch check
        if password != confirm_password:
            message = "Passwords do not match."
            return render_template("register.html", message=message)

        conn = get_db_connection()
        cursor = conn.cursor()

        try:
            cursor.execute(
                "INSERT INTO users (name, email, password) VALUES (%s, %s, %s)",
                (name, email, hashed_password)
            )

            conn.commit()
            message = "Registration successful. Please login."

        except:
            message = "Email already exists."

        finally:
            cursor.close()
            conn.close()

    return render_template("register.html", message=message)

@app.route("/admin/dashboard")
def admin_dashboard():
    if "role" not in session or session["role"] != "admin":
        return redirect("/login")
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT COUNT(*) AS total FROM courses")
    total_courses = cursor.fetchone()["total"]

    cursor.execute("SELECT COUNT(*) AS total FROM enrollments")
    total_enrollments = cursor.fetchone()["total"]

    cursor.execute("SELECT COUNT(*) AS total FROM users WHERE role='learner'")
    total_learners = cursor.fetchone()["total"]

    cursor.execute("SELECT * FROM courses")
    courses = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("admin_dashboard.html", courses=courses, total_enrollments=total_enrollments, total_learners=total_learners)


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

        return redirect("/admin/add-course")

    return render_template("add_course.html")


@app.route("/admin/enrollments")
def admin_enrollments():
    if "role" not in session or session["role"] != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            e.id AS enrollment_id,
            u.name AS learner_name,
            u.email AS learner_email,
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

    return render_template("admin_enrollments.html", enrollments=enrollments)


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


@app.route("/admin/enrollment-analytics")
def admin_enrollment_analytics():
    # Optional: protect with admin check
    if session.get("role") != "admin":
        return redirect("/login")
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Total enrollments
    cursor.execute("SELECT COUNT(*) AS total_enrollments FROM enrollments")
    total_enrollments = cursor.fetchone()["total_enrollments"]

    # Total unique learners
    cursor.execute("SELECT COUNT(DISTINCT user_id) AS total_learners FROM enrollments")
    total_learners = cursor.fetchone()["total_learners"]

    # Total courses enrolled
    cursor.execute("SELECT COUNT(DISTINCT course_id) AS total_courses FROM enrollments")
    total_courses = cursor.fetchone()["total_courses"]

    # Today's enrollments
    cursor.execute("""
        SELECT COUNT(*) AS today_enrollments
        FROM enrollments
        WHERE DATE(enrolled_at) = CURDATE()
    """)
    today_enrollments = cursor.fetchone()["today_enrollments"]

    # Enrollments per course
    cursor.execute("""
    SELECT c.title AS title, COUNT(e.id) AS total
    FROM courses c
    LEFT JOIN enrollments e ON c.id = e.course_id
    GROUP BY c.id, c.title
    ORDER BY total DESC
""")
    course_data = cursor.fetchall()

    # Enrollments by difficulty
    cursor.execute("""
    SELECT c.difficulty AS difficulty, COUNT(e.id) AS total
    FROM courses c
    LEFT JOIN enrollments e ON c.id = e.course_id
    GROUP BY c.difficulty
""")
    difficulty_data = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "admin_enrollment_analytics.html",
        total_enrollments=total_enrollments,
        total_learners=total_learners,
        total_courses=total_courses,
        today_enrollments=today_enrollments,
        course_data=course_data,
        difficulty_data=difficulty_data
    )


@app.route("/admin/learner-analytics")
def learner_analytics():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Total learners
    cursor.execute("SELECT COUNT(*) AS total FROM users WHERE role='learner'")
    total_learners = cursor.fetchone()["total"]

    # Learners with enrollments
    cursor.execute("""
        SELECT COUNT(DISTINCT user_id) AS total
        FROM enrollments
    """)
    enrolled_learners = cursor.fetchone()["total"]

    # Learners without enrollments
    learners_without_enrollments = total_learners - enrolled_learners

    # Average enrollments per learner
    cursor.execute("""
        SELECT COUNT(*) / COUNT(DISTINCT user_id) AS avg_enrollments
        FROM enrollments
    """)
    avg_enrollments = cursor.fetchone()["avg_enrollments"] or 0

    # Learner-wise enrollment details
    cursor.execute("""
        SELECT 
            u.id,
            u.name,
            u.email,
            COUNT(e.id) AS total_enrollments,
            GROUP_CONCAT(c.title SEPARATOR ', ') AS courses
        FROM users u
        LEFT JOIN enrollments e ON u.id = e.user_id
        LEFT JOIN courses c ON e.course_id = c.id
        WHERE u.role = 'learner'
        GROUP BY u.id
        ORDER BY total_enrollments DESC
    """)
    learner_data = cursor.fetchall()

    cursor.close()

    return render_template(
        "learner_wise_analytics.html",
        total_learners=total_learners,
        enrolled_learners=enrolled_learners,
        learners_without_enrollments=learners_without_enrollments,
        avg_enrollments=round(avg_enrollments, 2),
        learner_data=learner_data
    )


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
    sort = request.args.get("sort", "newest").strip()

    user_id = session.get("user_id")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Base query
    base_query = """
        FROM courses c
        LEFT JOIN enrollments e ON c.id = e.course_id
        WHERE 1=1
    """
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

    # Sorting
    if sort == "popular":
        order_by = "ORDER BY COUNT(e.id) DESC"
    else:
        order_by = "ORDER BY c.id DESC"

    # Total count
    count_query = "SELECT COUNT(DISTINCT c.id) AS total " + base_query
    cursor.execute(count_query, params)
    total = cursor.fetchone()["total"]

    total_pages = max(1, (total + limit - 1) // limit)

    if page > total_pages:
        page = total_pages
        offset = (page - 1) * limit

    # Fetch courses
    if user_id:
        data_query = f"""
            SELECT
                c.*,
                COUNT(e.id) AS enroll_count,
                MAX(CASE WHEN e.user_id = %s THEN 1 ELSE 0 END) AS is_enrolled
            {base_query}
            GROUP BY c.id
            {order_by}
            LIMIT %s OFFSET %s
        """
        cursor.execute(data_query, [user_id] + params + [limit, offset])
    else:
        data_query = f"""
            SELECT
                c.*,
                COUNT(e.id) AS enroll_count,
                0 AS is_enrolled
            {base_query}
            GROUP BY c.id
            {order_by}
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
        selected_source=selected_source,
        sort=sort
    )


@app.route("/admin/add-reference-book", methods=["GET", "POST"])
def add_reference_book():
    if "user_id" not in session or session["role"] != "admin":
        return redirect("/login")

    if request.method == "POST":
        title = request.form["title"]
        language = request.form["language"]
        author = request.form["author"]
        pdf_file = request.files["pdf"]
        image_file = request.files["image"]

        # ---- SAVE FILES ----
        pdf_filename = secure_filename(pdf_file.filename)
        image_filename = secure_filename(image_file.filename)

        pdf_path = os.path.join("static/reference_books/pdfs", pdf_filename)
        image_path = os.path.join("static/reference_books/images", image_filename)

        pdf_file.save(pdf_path)
        image_file.save(image_path)

        # ---- DB INSERT ----
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO reference_books (title, author, language, pdf_path, image_path)
            VALUES (%s, %s, %s, %s, %s)
        """, (
            title,
            author,
            language,
            f"reference_books/pdfs/{pdf_filename}",
            f"reference_books/images/{image_filename}"
        ))

        conn.commit()
        cursor.close()
        conn.close()

        # SUCCESS MESSAGE
        flash("Book added successfully", "success")

        # IMPORTANT: redirect to SAME page
        return redirect(url_for("add_reference_book"))

    return render_template("add_reference_book.html")


@app.route("/admin/reference-books")
def admin_reference_books():
    if "user_id" not in session or session["role"] != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT id, title, author, language, pdf_path, image_path, created_at
        FROM reference_books
        ORDER BY created_at DESC
    """)
    books = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "reference_books_list.html",
        books=books
    )


@app.route("/admin/delete-reference-book/<int:book_id>")
def delete_reference_book(book_id):
    if "user_id" not in session or session["role"] != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("DELETE FROM reference_books WHERE id=%s", (book_id,))
    conn.commit()

    cursor.close()
    conn.close()

    flash("Book deleted successfully", "success")
    return redirect("/admin/reference-books")


@app.route("/learner/profile")
def learner_profile():
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # User details
    cursor.execute("SELECT * FROM users WHERE id=%s", (user_id,))
    user = cursor.fetchone()

    # Earned badges
    cursor.execute("""
        SELECT b.*
        FROM badges b
        JOIN user_badges ub ON b.id = ub.badge_id
        WHERE ub.user_id = %s
        ORDER BY b.id
    """, (user_id,))
    earned_badges = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "learner_profile.html",
        user=user,
        earned_badges=earned_badges
    )


@app.route("/learner/profile/edit", methods=["GET", "POST"])
def edit_profile():
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == "POST":
        name = request.form["name"]
        dob = request.form["dob"]
        bio = request.form["bio"]

        image = request.files.get("profile_image")
        image_name = None

        # Ensure upload folder exists
        os.makedirs(app.config["UPLOAD_FOLDER"], exist_ok=True)

        if image and allowed_file(image.filename):
            filename = secure_filename(image.filename)
            ext = filename.rsplit(".", 1)[1].lower()
            image_name = f"user_{user_id}.{ext}"

            image_path = os.path.join(app.config["UPLOAD_FOLDER"], image_name)
            image.save(image_path)

        if image_name:
            cursor.execute("""
                UPDATE users
                SET name=%s, dob=%s, bio=%s, profile_image=%s
                WHERE id=%s
            """, (name, dob, bio, image_name, user_id))
        else:
            cursor.execute("""
                UPDATE users
                SET name=%s, dob=%s, bio=%s
                WHERE id=%s
            """, (name, dob, bio, user_id))

        conn.commit()
        flash("Profile updated successfully 🎉", "success")
        return redirect("/learner/profile")

    cursor.execute("SELECT * FROM users WHERE id=%s", (user_id,))
    user = cursor.fetchone()

    cursor.close()
    conn.close()

    return render_template("edit_profile.html", user=user)


@app.route("/learner/dashboard")
def learner_dashboard():
    if "user_id" not in session or session["role"] != "learner":
        return redirect("/login")

    user_id = session["user_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # -------------------------------
    # 1. Completed courses
    # -------------------------------
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM enrollments
        WHERE user_id=%s AND completed=1
    """, (user_id,))
    completed_courses = cursor.fetchone()["total"]

    # -------------------------------
    # 2. Advanced courses
    # -------------------------------
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM enrollments e
        JOIN courses c ON e.course_id = c.id
        WHERE e.user_id=%s AND e.completed=1 AND c.difficulty='Advanced'
    """, (user_id,))
    advanced_completed = cursor.fetchone()["total"]

    # -------------------------------
    # 3. Earned badges
    # -------------------------------
    cursor.execute("""
        SELECT b.*
        FROM badges b
        JOIN user_badges ub ON b.id = ub.badge_id
        WHERE ub.user_id=%s
    """, (user_id,))
    earned_badges = cursor.fetchall()

    # -------------------------------
    # 4. Fetch learning activity
    # -------------------------------
    cursor.execute("""
        SELECT activity_date, is_frozen
        FROM learning_activity
        WHERE user_id=%s
    """, (user_id,))
    rows = cursor.fetchall()

    streak_map = {}
    for r in rows:
        streak_map[r["activity_date"].strftime("%Y-%m-%d")] = r["is_frozen"]

    # -------------------------------
    # 5. Fetch streak safely
    # -------------------------------
    today = datetime.now(timezone.utc).date()

    cursor.execute("""
        SELECT current_streak, last_activity_date
        FROM learning_streaks
        WHERE user_id = %s
    """, (user_id,))

    streak_data = cursor.fetchone()

    # ALWAYS DEFINE BOTH VARIABLES
    current_streak = 0
    display_streak = 0

    if streak_data:
        current_streak = streak_data["current_streak"]
        last_date = streak_data["last_activity_date"]

        if last_date is None:
            display_streak = 0
        elif last_date == today or last_date == today - timedelta(days=1):
            display_streak = current_streak
        else:
            display_streak = 0

    # -------------------------------
    # 6. Calendar helpers
    # -------------------------------
    year = today.year
    month = today.month
    first_weekday, days_in_month = calendar.monthrange(year, month)

    cursor.close()
    conn.close()

    return render_template(
        "learner_dashboard.html",
        completed_courses=completed_courses,
        advanced_completed=advanced_completed,
        earned_badges=earned_badges,
        current_streak=current_streak,
        display_streak=display_streak,
        streak_map=streak_map,
        year=year,
        month=month,
        first_weekday=first_weekday,
        days_in_month=days_in_month
    )


@app.route("/learner/profile/update", methods=["POST"])
def update_profile():
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]
    full_name = request.form["full_name"]
    dob = request.form["dob"]
    bio = request.form["bio"]

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO user_profiles (user_id, full_name, dob, bio)
        VALUES (%s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            full_name = VALUES(full_name),
            dob = VALUES(dob),
            bio = VALUES(bio)
    """, (user_id, full_name, dob, bio))

    conn.commit()
    cursor.close()
    conn.close()

    flash("Profile updated successfully", "success")
    return redirect("/learner/profile")

 
@app.route("/learner/change-password", methods=["GET", "POST"])
def change_password():
    if "user_id" not in session:
        return redirect("/login")

    if request.method == "POST":
        current_password = request.form["current_password"]
        new_password = request.form["new_password"]
        confirm_password = request.form["confirm_password"]

        if new_password != confirm_password:
            flash("Passwords do not match", "danger")
            return redirect("/learner/change-password")

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute(
            "SELECT password FROM users WHERE id=%s",
            (session["user_id"],)
        )
        user = cursor.fetchone()

        # Hash new password
        hashed_new_password = generate_password_hash(new_password)

        # Verify current password
        if not check_password_hash(user["password"], current_password):
            flash("Current password is incorrect", "danger")
            return redirect("/learner/change-password")
        else:
            cursor.execute(
                "UPDATE users SET password=%s WHERE id=%s",
                (hashed_new_password, session["user_id"])
            )
            conn.commit()
            flash("Password updated successfully ✅", "success")

        cursor.close()
        conn.close()

        return redirect("/learner/profile")

    return render_template("change_password.html")


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

    cursor.execute("""
        SELECT
            e.id AS enrollment_id,
            c.*,
            e.enrolled_at,
            e.completed
        FROM enrollments e
        JOIN courses c ON c.id = e.course_id
        WHERE e.user_id = %s
        ORDER BY e.enrolled_at DESC
    """, (session["user_id"],))

    courses = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template("my_enrollments.html", courses=courses)


# --------------------
# LEARNER PROGRESS
# --------------------
@app.route("/learner/progress")
def learner_progress():
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT COUNT(*) AS total FROM enrollments WHERE user_id=%s", (user_id,))
    total_courses = cursor.fetchone()["total"]

    cursor.execute("""
        SELECT COUNT(*) AS completed
        FROM enrollments
        WHERE user_id=%s AND completed=1
    """, (user_id,))
    completed_courses = cursor.fetchone()["completed"]

    pending_courses = total_courses - completed_courses
    completion_percent = round((completed_courses / total_courses) * 100, 1) if total_courses else 0

    cursor.execute("""
        SELECT c.title, e.completed
        FROM enrollments e
        JOIN courses c ON c.id = e.course_id
        WHERE e.user_id=%s
    """, (user_id,))
    course_progress = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "learner_progress.html",
        total_courses=total_courses,
        completed_courses=completed_courses,
        pending_courses=pending_courses,
        completion_percent=completion_percent,
        course_progress=course_progress
    )


@app.route("/learner/visit-course/<int:course_id>")
def visit_course(course_id):
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]

    # This handles everything about daily activity logging and streaks in one place, ensuring it's always up-to-date when user visits any course
    log_daily_activity(user_id)

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT course_link FROM courses WHERE id=%s",
        (course_id,)
    )
    course = cursor.fetchone()

    cursor.close()
    conn.close()

    return redirect(course["course_link"])


def log_daily_activity(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    today = datetime.now(timezone.utc).date()

    # Check if activity already logged today
    cursor.execute("""
        SELECT id
        FROM learning_activity
        WHERE user_id = %s AND activity_date = %s
    """, (user_id, today))

    already_logged = cursor.fetchone()

    if already_logged:
        cursor.close()
        conn.close()
        return  # Already counted today

    # Insert today's activity
    cursor.execute("""
        INSERT INTO learning_activity (user_id, activity_date)
        VALUES (%s, %s)
    """, (user_id, today))

    # Fetch streak info
    cursor.execute("""
        SELECT current_streak, last_activity_date
        FROM learning_streaks
        WHERE user_id = %s
    """, (user_id,))

    streak = cursor.fetchone()

    # Calculate new streak
    if not streak:
        # First activity ever
        cursor.execute("""
            INSERT INTO learning_streaks 
            (user_id, current_streak, last_activity_date, updated_at)
            VALUES (%s, 1, %s, NOW())
        """, (user_id, today))
    else:
        last_date = streak["last_activity_date"]

        if last_date == today - timedelta(days=1):
            new_streak = streak["current_streak"] + 1
        elif last_date == today:
            new_streak = streak["current_streak"]
        else:
            new_streak = 1

        cursor.execute("""
            UPDATE learning_streaks
            SET current_streak = %s,
                last_activity_date = %s,
                updated_at = NOW()
            WHERE user_id = %s
        """, (new_streak, today, user_id))

    conn.commit()
    cursor.close()
    conn.close()


def mark_lesson_completed(user_id, lesson_id):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        INSERT IGNORE INTO lesson_progress (user_id, lesson_id, completed_at)
        VALUES (%s, %s, NOW())
    """, (user_id, lesson_id))

    conn.commit()
    cursor.close()
    conn.close()


def update_streak(user):
    today = datetime.now(timezone.utc).date()

    last_date = user["last_streak_date"]
    streak = user["streak"]
    freeze = user["streak_freeze"]

    if last_date is None:
        return streak + 1, today, freeze

    days_gap = (today - last_date).days

    # Same day → do nothing
    if days_gap == 0:
        return streak, last_date, freeze

    # Perfect streak
    if days_gap == 1:
        return streak + 1, today, freeze

    # Missed one day → use freeze
    if days_gap == 2 and freeze > 0:
        return streak + 1, today, freeze - 1

    # Missed too many days → reset
    return 1, today, freeze


@app.after_request
def clear_badge_toasts(response):
    session.pop("badge_toasts", None)
    return response


@app.route("/learner/complete-lesson/<int:lesson_id>", methods=["POST"])
def complete_lesson(lesson_id):
    user_id = session.get("user_id")

    # lesson completion logic here
    mark_lesson_completed(user_id, lesson_id)

    # streak update
    update_streak(user_id)

    flash("Lesson completed!", "success")
    return redirect(url_for("learner_dashboard"))


@app.route("/learner/mark-completed/<int:enrollment_id>", methods=["POST"])
def mark_completed(enrollment_id):
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Fetch enrollment FIRST
    cursor.execute("""
        SELECT id, completed
        FROM enrollments
        WHERE id=%s AND user_id=%s
    """, (enrollment_id, user_id))

    enrollment = cursor.fetchone()

    if not enrollment:
        flash("Invalid enrollment ❌", "danger")
        cursor.close()
        conn.close()
        return redirect("/my-enrollments")

    if enrollment["completed"] == 1:
        flash("Course already completed ✅", "info")
        cursor.close()
        conn.close()
        return redirect("/my-enrollments")

    # Mark as completed
    cursor.execute("""
        UPDATE enrollments
        SET completed=1, completed_at=NOW()
        WHERE id=%s
    """, (enrollment_id,))

    conn.commit()

    # Award badges
    new_badges = award_badges(user_id)

    flash("🎉 Course marked as completed!", "success")
    for badge in new_badges:
        flash(f"New badge unlocked: {badge}", "badge")

    cursor.close()
    conn.close()

    return redirect("/my-enrollments")


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


def award_badges(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    new_badges = []

    # Completed courses count
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM enrollments
        WHERE user_id=%s AND completed=1
    """, (user_id,))
    completed_courses = cursor.fetchone()["total"]

    # Advanced courses completed
    cursor.execute("""
        SELECT COUNT(*) AS total
        FROM enrollments e
        JOIN courses c ON e.course_id = c.id
        WHERE e.user_id=%s AND e.completed=1 AND c.difficulty='Advanced'
    """, (user_id,))
    advanced_completed = cursor.fetchone()["total"]

    # Current streak
    cursor.execute("""
        SELECT current_streak
        FROM learning_streaks
        WHERE user_id=%s
    """, (user_id,))
    streak_row = cursor.fetchone()
    current_streak = streak_row["current_streak"] if streak_row else 0

    # Fetch all badges
    cursor.execute("SELECT * FROM badges")
    badges = cursor.fetchall()

    for badge in badges:
        eligible = False

        if badge["rule_type"] == "course_count" and completed_courses >= badge["rule_value"]:
            eligible = True

        elif badge["rule_type"] == "advanced_course" and advanced_completed >= badge["rule_value"]:
            eligible = True

        elif badge["rule_type"] == "streak_days" and current_streak >= badge["rule_value"]:
            eligible = True

        if eligible:
            # check if already earned
            cursor.execute("""
                SELECT 1 FROM user_badges
                WHERE user_id=%s AND badge_id=%s
            """, (user_id, badge["id"]))

            if not cursor.fetchone():
                cursor.execute("""
                    INSERT INTO user_badges (user_id, badge_id)
                    VALUES (%s, %s)
                """, (user_id, badge["id"]))

                new_badges.append(badge["name"])

    conn.commit()
    cursor.close()
    conn.close()

    return new_badges


def get_current_streak(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT activity_date
        FROM user_activity
        WHERE user_id=%s
        ORDER BY activity_date DESC
    """, (user_id,))

    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    streak = 0
    today = date.today()

    for row in rows:
        if row["activity_date"] == today:
            streak += 1
            today = today.replace(day=today.day - 1)
        else:
            break

    return streak

STREAK_BADGES = {
    3: "3-Day Streak",
    7: "7-Day Streak",
    30: "30-Day Streak"
}


def award_streak_badges(user_id):
    streak = get_current_streak(user_id)

    conn = get_db_connection()
    cursor = conn.cursor()

    for days, badge_name in STREAK_BADGES.items():
        if streak >= days:
            cursor.execute("""
                INSERT INTO user_badges (user_id, badge_name)
                VALUES (%s, %s)
                ON DUPLICATE KEY UPDATE id=id
            """, (user_id, badge_name))

            if cursor.rowcount == 1:
                flash(f"🏆 Badge Earned: {badge_name}", "badge")

        conn.commit()
        cursor.close()
        conn.close()
    

@app.route("/learner/courses")
def view_courses():
    return redirect(url_for("courses"))


@app.route("/basic-programs")
def basic_programs():
    if "user_id" not in session or session["role"] != "learner":
        return redirect("/login")
    return render_template("basic_programs.html")

@app.route("/programs/python")
def python_programs():
    return render_template("programs_python.html")

@app.route("/programs/c")
def c_programs():
    return render_template("programs_c.html")

@app.route("/programs/cpp")
def cpp_programs():
    return render_template("programs_cpp.html")

@app.route("/programs/java")
def java_programs():
    return render_template("programs_java.html")

@app.route("/programs/csharp")
def csharp_programs():
    return render_template("programs_csharp.html")

@app.route("/programs/go")
def go_programs():
    return render_template("programs_go.html")


@app.route("/learner/reference-books")
def reference_books_main():
    if "user_id" not in session or session["role"] != "learner":
        return redirect("/login")

    page = request.args.get("page", 1, type=int)
    per_page = 8
    offset = (page - 1) * per_page

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # total count
    cursor.execute("SELECT COUNT(*) AS total FROM reference_books")
    total_books = cursor.fetchone()["total"]

    total_pages = (total_books + per_page - 1) // per_page

    # paginated books
    cursor.execute("""
        SELECT * FROM reference_books
        ORDER BY id DESC
        LIMIT %s OFFSET %s
    """, (per_page, offset))

    books = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "reference_books/reference_books.html",
        books=books,
        current_page=page,
        total_pages=total_pages
    )


@app.route("/learner/view-book/<int:book_id>")
def view_book(book_id):
    if "user_id" not in session or session["role"] != "learner":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM reference_books WHERE id = %s",
        (book_id,)
    )
    book = cursor.fetchone()

    cursor.close()
    conn.close()

    if not book:
        abort(404)

    return render_template(
        "reference_books/view_book.html",
        book=book
    )


@app.route("/about")
def about():
    return render_template("about.html")

@app.route("/privacy-policy")
def privacy_policy():
    return render_template("privacy_policy.html")

@app.route("/terms")
def terms():
    return render_template("terms.html")

@app.route("/help")
def support():
    return render_template("help_center.html")

@app.route("/disclaimer")
def disclaimer():
    return render_template("disclaimer.html")


@app.route("/some-route")
def some_function():
    # ALL CODE MUST BE HERE
    conn = get_db_connection()
    cursor = conn.cursor()
    return render_template("file.html")


@app.route("/logout")
def logout():
    session.clear()
    flash("Logged out successfully", "info")
    return redirect("/login")


if __name__ == "__main__":
    app.run(debug=True)
    