<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.util.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.jsp.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-Content-Type-Options" content="nosniff">
    <meta http-equiv="X-Frame-Options" content="DENY">
    <meta http-equiv="Content-Security-Policy" content="default-src 'self'">
    <title>Signup - Recipe Review</title>
    <link rel="stylesheet" href="css/style.css">
    <script>
        function validateForm() {
            const username = document.getElementById('username').value;
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            if (username.length < 3) {
                alert('Username must be at least 3 characters long');
                return false;
            }
            
            if (password.length < 8) {
                alert('Password must be at least 8 characters long');
                return false;
            }
            
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                alert('Please enter a valid email address');
                return false;
            }
            
            return true;
        }
    </script>
</head>
<body>
    <header class="header">
        <div class="header-container">
            <a href="index.jsp" class="logo">Recipe Review</a>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="search-recipes.jsp">Recipes</a></li>
                <li><a href="login.jsp">Login</a></li>
            </ul>
        </div>
    </header>

    <div class="container">
        <div class="form-container">
            <h2 class="form-title">User Registration</h2>
            
            <% String message = request.getParameter("message");
               if (message != null) { %>
                <div class="alert alert-error">
                    <%= message %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/signup" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <div class="form-group">
                    <label for="username" class="form-label">Username:</label>
                    <input type="text" id="username" name="username" class="form-input" required>
                </div>
                
                <div class="form-group">
                    <label for="email" class="form-label">Email:</label>
                    <input type="email" id="email" name="email" class="form-input" required>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">Password:</label>
                    <input type="password" id="password" name="password" class="form-input" required>
                </div>
                
                <div class="form-group">
                    <label for="profilePic" class="form-label">Profile Picture URL (optional):</label>
                    <input type="text" id="profilePic" name="profilePic" class="form-input">
                </div>
                
                <button type="submit" class="btn btn-block">Register</button>
                
                <div class="form-footer">
                    Already have an account? <a href="login.jsp">Login here</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>