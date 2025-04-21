<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Recipe Review</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="header">
        <div class="header-container">
            <a href="index.jsp" class="logo">Recipe Review</a>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="search-recipes.jsp">Recipes</a></li>
                <li><a href="signup.jsp">Sign Up</a></li>
            </ul>
        </div>
    </header>

    <div class="container">
        <div class="form-container">
            <h2 class="form-title">Login</h2>
            <p class="form-subtitle">Enter your credentials to access your account</p>
            
            <% String message = request.getParameter("message");
               if (message != null) { %>
                <div class="alert alert-error">
                    <%= message %>
                </div>
            <% } %>
            
            <form action="login" method="post">
                <div class="form-group">
                    <label for="email" class="form-label">Email:</label>
                    <input type="email" id="email" name="email" class="form-input" required>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">Password:</label>
                    <input type="password" id="password" name="password" class="form-input" required>
                </div>
                
                <button type="submit" class="btn btn-block">Sign In</button>
                
                <div class="form-footer">
                    Don't have an account? <a href="signup.jsp">Register here</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>