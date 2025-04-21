<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Recipe - Recipe Review</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <header class="header">
        <div class="header-container">
            <a href="index.jsp" class="logo">Recipe Review</a>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="search-recipes.jsp">Recipes</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </div>
    </header>

    <div class="container">
        <div class="form-container fade-in">
            <h2 class="form-title">Add a New Recipe</h2>

            <% 
                if (session == null || session.getAttribute("userId") == null) {
                    response.sendRedirect("login.jsp?message=Please login to add a recipe.");
                    return;
                }
                String message = request.getParameter("message");
                if (message != null) { 
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= message %>
                </div>
            <% } %>

            <form action="add-recipe" method="post">
                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                
                <div class="form-group">
                    <label for="title" class="form-label">Title:</label>
                    <input type="text" id="title" name="title" class="form-input" required maxlength="100" pattern="[^<>]*">
                </div>

                <div class="form-group">
                    <label for="description" class="form-label">Description:</label>
                    <textarea id="description" name="description" class="form-textarea" required maxlength="2000"></textarea>
                </div>

                <div class="form-group">
                    <label for="ingredients" class="form-label">Ingredients:</label>
                    <textarea id="ingredients" name="ingredients" class="form-textarea" required maxlength="1000"></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="cuisine" class="form-label"><i class="fas fa-globe-americas"></i> Cuisine:</label>
                        <input type="text" id="cuisine" name="cuisine" class="form-input" maxlength="50" pattern="[A-Za-z\s,]*" placeholder="Italian, Indian, Mexican...">
                    </div>

                    <div class="form-group">
                        <label for="category" class="form-label"><i class="fas fa-tag"></i> Category:</label>
                        <input type="text" id="category" name="category" class="form-input" maxlength="50" pattern="[A-Za-z\s,]*" placeholder="Breakfast, Dessert, Vegetarian...">
                    </div>
                </div>

                <div class="form-group">
                    <label for="imageUrl" class="form-label"><i class="fas fa-image"></i> Image URL:</label>
                    <input type="url" id="imageUrl" name="imageUrl" class="form-input" pattern="https?://.+" maxlength="255" placeholder="https://example.com/image.jpg">
                </div>

                <button type="submit" class="btn btn-block"><i class="fas fa-plus-circle"></i> Add Recipe</button>
            </form>

            <div class="form-footer">
                <a href="profile.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to Profile</a>
            </div>
        </div>
    </div>
</body>
</html>