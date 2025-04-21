<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession, com.tap.dao.RecipeDAO, com.tap.daoimpl.RecipeDAOImpl, com.tap.model.Recipe" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Recipe - TastyThreads</title>
    <link rel="icon" type="image/png" href="templates/images/Tasty Threads.png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&family=Roboto+Slab&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="templates/css/style.css">
    <link rel="stylesheet" href="templates/css/edit-recipe.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <% 
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?message=Please login to edit your recipes.");
            return;
        }

        String recipeIdParam = request.getParameter("recipeId");
        int recipeId;
        
        try {
            if (recipeIdParam == null || recipeIdParam.trim().isEmpty()) {
                throw new NumberFormatException();
            }
            recipeId = Integer.parseInt(recipeIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("view-my-recipes.jsp?message=Invalid recipe ID.");
            return;
        }

        RecipeDAO recipeDAO = new RecipeDAOImpl();
        Recipe recipe = recipeDAO.getRecipeById(recipeId);

        if (recipe == null || recipe.getUserId() != (int) session.getAttribute("userId")) {
            response.sendRedirect("view-my-recipes.jsp?message=Unauthorized access.");
            return;
        }
    %>

    <%!
        public String escapeHtml(String input) {
            if (input == null) {
                return "";
            }
            return input.replace("&", "&amp;")
                       .replace("<", "&lt;")
                       .replace(">", "&gt;")
                       .replace("\"", "&quot;")
                       .replace("'", "&#x27;");
        }
    %>
    
    <header class="header">
        <div class="header-container">
            <a href="index" class="logo"><img src="templates/images/Tasty Threads.png" alt="TastyThreads Logo"></a>
            <nav>
                <ul class="nav-links">
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="view-recipe.jsp" class="active">Recipes</a></li>
                    <li><a href="about.jsp">About Us</a></li>
                    <li><a href="profile.jsp">Profile</a></li>
                    <li><a href="logout.jsp">Logout</a></li>
                    <li><a href="add-recipe.jsp" class="btn-primary">Add Recipe</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main>
        <section class="edit-recipe-section">
            <div class="container">
                <div class="form-container">
                    <h2 class="form-title">Edit Recipe</h2>
                    <form action="edit-recipe" method="post">
                        <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                        <input type="hidden" name="recipeId" value="<%= recipe.getRecipeId() %>">
                        
                        <div class="form-group">
                            <label for="title" class="form-label"><i class="fas fa-heading"></i> Title</label>
                            <input type="text" id="title" name="title" class="form-input" 
                                   value="<%= escapeHtml(recipe.getTitle()) %>"
                                   required maxlength="100" pattern="[^<>]*">
                        </div>

                        <div class="form-group">
                            <label for="description" class="form-label"><i class="fas fa-align-left"></i> Description</label>
                            <textarea id="description" name="description" class="form-textarea" 
                                    required maxlength="2000"><%= escapeHtml(recipe.getDescription()) %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="ingredients" class="form-label"><i class="fas fa-list"></i> Ingredients</label>
                            <textarea id="ingredients" name="ingredients" class="form-textarea" 
                                    required maxlength="1000"><%= escapeHtml(recipe.getIngredients()) %></textarea>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="cuisine" class="form-label"><i class="fas fa-globe-americas"></i> Cuisine</label>
                                <input type="text" id="cuisine" name="cuisine" class="form-input" 
                                       value="<%= escapeHtml(recipe.getCuisine()) %>"
                                       maxlength="50" pattern="[A-Za-z\s,]*">
                            </div>

                            <div class="form-group">
                                <label for="category" class="form-label"><i class="fas fa-tag"></i> Category</label>
                                <input type="text" id="category" name="category" class="form-input" 
                                       value="<%= escapeHtml(recipe.getCategory()) %>"
                                       maxlength="50" pattern="[A-Za-z\s,]*">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="imageUrl" class="form-label"><i class="fas fa-image"></i> Image URL</label>
                            <input type="url" id="imageUrl" name="imageUrl" class="form-input" 
                                   value="<%= escapeHtml(recipe.getImageUrl()) %>"
                                   pattern="https?://.+" maxlength="255">
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-save"></i> Update Recipe
                            </button>
                            <a href="view-my-recipes.jsp" class="btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </section>
    </main>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2024 TastyThreads. All rights reserved.</p>
        </div>
    </footer>
</body>
</html> 