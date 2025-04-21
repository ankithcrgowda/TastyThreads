<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.util.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.jsp.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-Content-Type-Options" content="nosniff">
    <meta http-equiv="X-Frame-Options" content="DENY">
    <meta http-equiv="Content-Security-Policy" content="default-src 'self'">
    <title>Sign Up - Tasty Threads</title>
    <link rel="icon" type="image/png" href="templates/images/Tasty Threads.png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&family=Roboto+Slab&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="templates/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <header class="header">
        <div class="header-container">
            <a href="index.jsp" class="logo"><img src="templates/images/Tasty Threads.png" alt="TastyThreads Logo"></a>
            <nav>
                <ul class="nav-links">
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="view-recipe.jsp">Recipes</a></li>
                    <li><a href="about.jsp">About Us</a></li>
                    <li><a href="login.jsp">Login</a></li>
                    <li><a href="add-recipe.jsp" class="btn-primary">Add Recipe</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <section class="login-section">
        <div class="container">
            <div class="login-container">
                <h2>Create Account</h2>
                <p>Join our community of food lovers</p>
                
                <% String message = request.getParameter("message");
                   if (message != null) { %>
                    <div class="alert alert-error">
                        <%= message %>
                    </div>
                <% } %>
                
                <form class="login-form" action="${pageContext.request.contextPath}/signup" method="post" onsubmit="return validateForm()" id="signupForm">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-group">
                            <i class="fas fa-user"></i>
                            <input type="text" id="username" name="username" placeholder="Choose a username" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <div class="input-group">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" placeholder="Enter your email" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-group">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" placeholder="Create a password" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="profilePic">Profile Picture</label>
                        <div class="input-group">
                            <i class="fas fa-image"></i>
                            <input type="file" id="profilePic" name="profilePic" accept="image/*">
                        </div>
                        <div id="image-preview" class="image-preview"></div>
                    </div>
                    <button type="submit" class="btn-primary btn-full">Sign Up</button>
                </form>
                <div class="signup-prompt">
                    Already have an account? <a href="login.jsp">Log In</a>
                </div>
            </div>
        </div>
    </section>

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
        
        // Image preview functionality
        document.getElementById('profilePic').addEventListener('change', function(e) {
            const file = e.target.files[0];
            const preview = document.getElementById('image-preview');
            
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.innerHTML = `<img src="${e.target.result}" alt="Profile picture preview" style="max-width: 100%; height: 150px; object-fit: cover; border-radius: 8px; margin-top: 10px;">`;
                }
                reader.readAsDataURL(file);
            } else {
                preview.innerHTML = '';
            }
        });
    </script>
</body>
</html> 