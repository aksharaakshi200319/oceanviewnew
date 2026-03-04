<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Login | Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body {
            background: url('https://images.unsplash.com/photo-1586375300773-8384e3e4916f?q=80&w=1920') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex; justify-content: center; align-items: center;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 40px; width: 400px; border-radius: 20px;
            color: white; text-align: center;
        }
        .error-msg {
            background: rgba(255, 75, 43, 0.2);
            color: #ffcccb;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.8rem;
            border: 1px solid rgba(255, 75, 43, 0.3);
        }
        .input-group { text-align: left; margin-bottom: 20px; }
        .input-group label { display: block; margin-bottom: 5px; font-size: 0.85rem; }
        .input-group input {
            width: 100%; padding: 12px; border-radius: 10px; border: none;
            background: rgba(255, 255, 255, 0.2); color: white;
        }
        .btn-submit {
            width: 100%; padding: 12px; border: none; border-radius: 10px;
            background: #00d4ff; color: #031e23; font-weight: 600; cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <h2>Staff Login</h2>
        <p style="margin-bottom: 20px; opacity: 0.8;">Enter credentials to enter Galle Portal</p>

        <%-- Error Message Display Logic --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-msg">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <form action="LoginServlet" method="POST">
            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="admin" required>
            </div>
            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn-submit">Login</button>
        </form>
        <a href="index.jsp" style="display:block; margin-top:20px; color:white; text-decoration:none; font-size:0.8rem; opacity:0.7;">← Back to Home</a>
    </div>
</body>
</html>