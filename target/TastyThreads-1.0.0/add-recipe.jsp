<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Recipe - TastyThreads</title>
    <link rel="icon" type="image/png" href="templates/images/Tasty Threads.png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&family=Roboto+Slab&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="templates/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <% 
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp?message=Please login to add a recipe.");
        return;
    }
    %>
    
    <header class="header">
        <div class="header-container">
            <a href="index" class="logo"><img src="templates/images/Tasty Threads.png" alt="TastyThreads Logo"></a>
            <nav>
                <ul class="nav-links">
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="view-recipe.jsp">Recipes</a></li>
                    <li><a href="about.jsp">About Us</a></li>
                    <li><a href="profile.jsp">Profile</a></li>
                    <li><a href="logout.jsp">Logout</a></li>
                    <li><a href="add-recipe.jsp" class="btn-primary active">Add Recipe</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <section class="add-recipe-section">
        <div class="container">
            <div class="form-container">
                <h2>Add New Recipe</h2>
                
                <% 
                String message = request.getParameter("message");
                if (message != null) { 
                %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> <%= message %>
                    </div>
                <% } %>
                
                <form id="recipe-form" class="recipe-form" action="add-recipe" method="POST">
                    <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                    
                    <div class="form-group">
                        <label for="title">Recipe Title*</label>
                        <input type="text" id="title" name="title" maxlength="100" required placeholder="Enter recipe title (max 100 characters)" pattern="[^<>]*">
                    </div>

                    <div class="form-group">
                        <label for="cuisine">Cuisine*</label>
                        <select id="cuisine" name="cuisine" required>
                            <option value="">Select Cuisine</option>
                            <option value="Indian">Indian</option>
                            <option value="Italian">Italian</option>
                            <option value="Chinese">Chinese</option>
                            <option value="Mexican">Mexican</option>
                            <option value="Japanese">Japanese</option>
                            <option value="Thai">Thai</option>
                            <option value="Mediterranean">Mediterranean</option>
                            <option value="American">American</option>
                            <option value="French">French</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="category">Category*</label>
                        <select id="category" name="category" required>
                            <option value="">Select Category</option>
                            <option value="Breakfast">Breakfast</option>
                            <option value="Appetizer">Appetizer</option>
                            <option value="Main Course">Main Course</option>
                            <option value="Side Dish">Side Dish</option>
                            <option value="Dessert">Dessert</option>
                            <option value="Beverage">Beverage</option>
                            <option value="Snack">Snack</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="description">Description*</label>
                        <textarea id="description" name="description" rows="3" maxlength="2000" required placeholder="Enter recipe description"></textarea>
                        <span class="character-count"><span id="description-count">0</span>/2000 characters</span>
                    </div>

                    <div class="form-group">
                        <label for="ingredients">Ingredients*</label>
                        <textarea id="ingredients" name="ingredients" rows="4" required placeholder="Enter ingredients (one per line)" maxlength="1000"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="imageUrl">Recipe Image URL</label>
                        <input type="url" id="imageUrl" name="imageUrl" pattern="https?://.+" maxlength="255" placeholder="https://example.com/image.jpg">
                    </div>
                    
                    <div class="form-actions">
                        <a href="profile.jsp" class="btn-secondary"><i class="fas fa-arrow-left"></i> Back to Profile</a>
                        <button type="submit" class="btn-primary"><i class="fas fa-plus-circle"></i> Add Recipe</button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <script>
        // Character counter for description
        document.getElementById('description').addEventListener('input', function() {
            const maxLength = this.getAttribute('maxlength');
            const currentLength = this.value.length;
            document.getElementById('description-count').textContent = currentLength;
        });

        // Form submission handler
        document.getElementById('recipe-form').addEventListener('submit', function(event) {
            // Validate all fields
            const title = document.getElementById('title').value.trim();
            const cuisine = document.getElementById('cuisine').value;
            const category = document.getElementById('category').value;
            const description = document.getElementById('description').value.trim();
            const ingredients = document.getElementById('ingredients').value.trim();
            
            if (!title || !cuisine || !category || !description || !ingredients) {
                event.preventDefault();
                alert('Please fill in all required fields marked with *');
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html> 