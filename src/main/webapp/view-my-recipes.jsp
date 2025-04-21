<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession, java.util.List, com.tap.dao.RecipeDAO, com.tap.daoimpl.RecipeDAOImpl, com.tap.model.Recipe" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Recipes - TastyThreads</title>
    <link rel="icon" type="image/png" href="templates/images/Tasty Threads.png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&family=Roboto+Slab&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="templates/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
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

    <% 
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?message=Please login to view your recipes.");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        RecipeDAO recipeDAO = new RecipeDAOImpl();
        List<Recipe> recipes = recipeDAO.getRecipesByUserId(userId);
    %>

    <header class="header">
        <div class="header-container">
            <a href="index" class="logo"><img src="templates/images/Tasty Threads.png" alt="TastyThreads Logo"></a>
            <nav>
                <ul class="nav-links">
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="view-recipe.jsp">Recipes</a></li>
                    <li><a href="about.jsp">About Us</a></li>
                    <li><a href="profile.jsp" class="active">Profile</a></li>
                    <li><a href="logout.jsp">Logout</a></li>
                    <li><a href="add-recipe.jsp" class="btn-primary">Add Recipe</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main>
        <section class="my-recipes-section">
            <div class="container">
                <h2 class="section-title">My Recipes</h2>
                
                <div class="actions-bar">
                    <a href="add-recipe.jsp" class="btn-primary"><i class="fas fa-plus"></i> Add New Recipe</a>
                </div>

                <% if (recipes.isEmpty()) { %>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> You have not added any recipes yet. Use the button above to add your first recipe!
                    </div>
                <% } else { %>
                    <div class="grid">
                        <% for (Recipe recipe : recipes) { %>
                            <div class="card">
                                <% if (recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty()) { %>
                                    <div class="recipe-image-container">
                                        <img src="<%= escapeHtml(recipe.getImageUrl()) %>" 
                                             alt="<%= escapeHtml(recipe.getTitle()) %>" 
                                             class="recipe-image">
                                    </div>
                                <% } %>
                                <div class="card-body">
                                    <h3><%= escapeHtml(recipe.getTitle()) %></h3>
                                    <div class="recipe-meta">
                                        <span><i class="fas fa-utensils"></i> <%= escapeHtml(recipe.getCuisine()) %></span>
                                        <span><i class="fas fa-tag"></i> <%= escapeHtml(recipe.getCategory()) %></span>
                                    </div>
                                    
                                    <div class="rating">
                                        <i class="fas fa-star"></i>
                                        <% if (recipe.getAvgRating() > 0) { %>
                                            <span class="rating-score"><%= recipe.getAvgRating() %></span>
                                        <% } else { %>
                                            <span>No ratings yet</span>
                                        <% } %>
                                    </div>
                                    
                                    <div class="recipe-actions">
                                        <a href="view-recipe?recipeId=<%= recipe.getRecipeId() %>" class="btn-action">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                        <a href="edit-recipe.jsp?recipeId=<%= recipe.getRecipeId() %>" class="btn-action">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <form action="delete-recipe" method="post" style="display: inline;">
                                            <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                                            <input type="hidden" name="recipeId" value="<%= recipe.getRecipeId() %>">
                                            <button type="submit" class="btn-action btn-danger" 
                                                    onclick="return confirm('Are you sure you want to delete this recipe?')">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>

                <div class="navigation-buttons">
                    <a href="profile.jsp" class="btn-secondary"><i class="fas fa-user"></i> Back to Profile</a>
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