<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - ArchStudio</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:#0f1117; --panel:#161b27; --panel2:#1e2535; --border:#2a3347;
            --accent:#4f8ef7; --accent2:#f7964f; --green:#3dd68c; --red:#f74f4f;
            --text:#e2e8f0; --muted:#94a3b8;
        }
        body {
            background: var(--bg); color: var(--text); font-family: 'DM Sans', sans-serif;
            display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0;
        }
        .container {
            background: var(--panel); padding: 40px; border-radius: 12px;
            border: 1px solid var(--border); width: 340px; text-align: center;
            box-shadow: 0 12px 30px rgba(0,0,0,0.35);
        }
        h2 { margin-top: 0; color: var(--accent); letter-spacing: 0.5px; }
        input {
            width: 100%; padding: 11px 12px; margin: 8px 0; border: 1px solid var(--border);
            background: var(--panel2); color: #fff; border-radius: 8px; box-sizing: border-box;
            transition: border-color .15s, box-shadow .15s;
        }
        input:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 2px rgba(79,142,247,0.15); }
        button {
            width: 100%; padding: 11px; background: var(--green); color: #161b27;
            border: 1px solid var(--green); border-radius: 8px; cursor: pointer; font-weight: 700; margin-top: 15px;
            transition: transform .1s ease, box-shadow .15s;
        }
        button:hover { transform: translateY(-1px); box-shadow: 0 8px 18px rgba(61,214,140,0.25); }
        .error { color: var(--red); font-size: 13px; margin-bottom: 10px; }
        a { color: var(--accent); text-decoration: none; font-size: 13px;}
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h2>ArchStudio</h2>
        <p style="font-size:14px; color:#94a3b8; margin-bottom:20px;">Create a new account</p>
        
        <% if (session.getAttribute("error") != null) { %>
            <div class="error"><%= session.getAttribute("error") %></div>
            <% session.removeAttribute("error"); %>
        <% } %>

        <form action="auth?action=register" method="POST">
            <input type="text" name="username" placeholder="Username" required>
            <input type="email" name="email" placeholder="Email Address" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="password" name="confirm" placeholder="Confirm Password" required>
            <button type="submit">Create Account</button>
        </form>
        <p style="margin-top: 20px;">
            <a href="login.jsp">Already have an account? Login</a>
        </p>
    </div>
</body>
</html>
