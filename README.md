# 🇮🇳 BharatLearn – The Learning Management System

## A modern, gamified Learning Management System (LMS) built using Flask and MySQL to enhance student engagement and track learning progress effectively.

## Project Overview

**BharatLearn is a web-based Learning Management System designed to provide learners with a structured, engaging, and motivational learning environment.**

**The platform allows users to:**

1. Register and log in securely

2. Browse and enroll in courses

3. Mark courses as completed

4. Track daily learning streaks

5. Earn achievement badges

6. View progress on a personalized dashboard

The system also includes administrative functionalities for managing courses and users.

## Objectives of the Project

To design and develop a complete LMS using Flask.

To implement secure authentication and role-based access control.

To integrate gamification elements like streaks and badges.

To track user learning activity using database logic.

To create a clean and responsive user interface.

To demonstrate real-world backend and database integration.

## 🛠️ Tech Stack

**🔹 Backend**

Python

Flask

MySQL

Jinja2 Template Engine

**🔹 Frontend**

HTML5

CSS3

JavaScript

**🔹 Database**

MySQL

## ----------------: Key Features :----------------

User Authentication

User Registration

Secure Login System

Role-based Access (Admin / Learner)

Session Management

## ---------------: Course Management :---------------

Browse available courses

Filter courses by difficulty/source

Enroll in courses

Unenroll from courses

Visit external course links

## ---------------: Course Completion System :---------------

Mark course as completed

Button auto-disables after completion

Completion badge indicator

Completion timestamp stored in database

## ---------------: Learning Streak System :---------------

Tracks daily activity

Prevents duplicate activity logging in one day

Automatically increments streak for consecutive days

Resets streak if user skips a day

Displays real-time streak on dashboard

Monthly activity calendar view

## -----------------------Badge System--------------------------

**Earn badges for:**

Course completion milestones

Advanced course completion

Streak achievements

Badge notifications using flash messages

Stores earned badges in database

## 📊 Learner Dashboard
Total completed courses

Advanced courses completed

Earned badges display

Current learning streak

Calendar visualization

Activity tracking system

## 🗂️ Project Structure
```
BharatLearn/
│
├── app.py
├── requirements.txt
├── README.md
│
├── templates/
│   ├── base.html
│   ├── learner_dashboard.html
│   ├── my_enrollments.html
│   └── ...
│
├── static/
│   ├── css/
│   ├── images/
│   └── js/
│
└── database/
    └── schema.sql
```

## 🗃️ Database Tables Used

users

courses

enrollments

badges

user_badges

learning_activity

learning_streaks

Each table is relationally connected to maintain proper LMS functionality.

## ⚙️ Installation Guide

**1️⃣ Clone the Repository**
```
git clone https://github.com/your-username/BharatLearn.git
```
```
cd BharatLearn
```

**2️⃣ Create Virtual Environment**
```
python -m venv venv
```
**For Windows**
```
venv\Scripts\activate
```

**3️⃣ Install Dependencies**
```
pip install -r requirements.txt
```

**4️⃣ Setup MySQL Database**
```
1. Create a database named bharatlearn

2. Import the SQL schema

3. Update database credentials inside app.py
```

**5️⃣ Run the Application**
```
python app.py
```
**Open browser and visit:**
```
http://127.0.0.1:5000
```

1. User Roles
   
2. Learner
   
3. Enroll in courses

4. Track progress

5. Maintain learning streak

7.Earn badges

8. View personalized dashboard

👨‍🏫 Admin
Manage courses

Monitor enrollments

Manage users

🎮 Gamification Elements
🔥 Daily Learning Streak

🏅 Achievement Badges

✔ Course Completion Indicators

📅 Activity Calendar

These features motivate consistent and disciplined learning behavior.

📈 Future Enhancements
Email verification system

Certificate generation after course completion

Leaderboard system

Course progress percentage tracking

Password reset functionality

API-based course integration

Deployment with custom domain

👨‍💻 Developed By
Akash Kusekar

Pratik Unnad

Academic Project – Learning Management System

📜 License
This project is developed for educational purposes only.

🌟 Conclusion
BharatLearn demonstrates:

Full-stack web development

Flask backend integration

MySQL database management

Authentication and session handling

CRUD operations

Streak logic implementation

Badge gamification system

Real-world LMS workflow implementation

It reflects practical knowledge of building scalable and structured web applications.
