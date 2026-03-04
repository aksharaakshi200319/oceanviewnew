<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort | Management Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body {
            background: url('https://images.unsplash.com/photo-1586375300773-8384e3e4916f?q=80&w=1920') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            overflow: hidden;
        }
        .overlay {
            background: rgba(0, 0, 0, 0.6); 
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            text-align: center;
        }
        .container { padding: 20px; animation: fadeIn 1.5s ease-in; }
        h1 { font-size: 3.5rem; letter-spacing: 2px; margin-bottom: 10px; text-transform: uppercase; }
        h1 span { color: #00d4ff; }
        p { font-size: 1.2rem; margin-bottom: 40px; font-weight: 300; letter-spacing: 1px; }
        .btn-login {
            text-decoration: none;
            color: white;
            background: transparent;
            border: 2px solid #00d4ff;
            padding: 15px 50px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 30px;
            transition: all 0.3s ease;
            display: inline-block;
        }
        .btn-login:hover {
            background: #00d4ff;
            color: #031e23;
            box-shadow: 0 0 25px rgba(0, 212, 255, 0.5);
            transform: scale(1.05);
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="overlay">
        <div class="container">
            <h1>OCEAN VIEW <span>RESORT</span></h1>
            <p>Galle's Premier Guest Reservation System</p>
            <a href="Login.jsp" class="btn-login">Access Staff Portal</a>
        </div>
        <footer style="position: absolute; bottom: 20px; font-size: 0.8rem; opacity: 0.6;">
            &copy; 2026 Ocean View Resort Management System | Galle, Sri Lanka
        </footer>
    </div>
</body>
</html>