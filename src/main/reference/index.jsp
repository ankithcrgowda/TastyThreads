<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Recipe" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recipe Review</title>
    <link rel="stylesheet" href="css/style.css">
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
    
    <header class="header">
        <div class="header-container">
            <a href="index.jsp" class="logo">Recipe Review</a>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="search-recipes.jsp">Recipes</a></li>
                <li><a href="login.jsp">Login</a></li>
                <li><a href="signup.jsp">Sign Up</a></li>
            </ul>
        </div>
    </header>

    <div class="container">
        <h2 class="form-title">Discover Delicious Recipes</h2>

        <%
            List<Recipe> recipes = (List<Recipe>) request.getAttribute("recipes");
            if (recipes != null && !recipes.isEmpty()) {
        %>
            <div class="grid">
                <% for (Recipe recipe : recipes) { %>
                    <div class="card fade-in">
                        <% if (recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty()) { %>
                            <div class="recipe-image-container">
                                <img src="<%= escapeHtml(recipe.getImageUrl()) %>" 
                                     alt="<%= escapeHtml(recipe.getTitle()) %>" 
                                     class="recipe-image">
                                <% if (recipe.getAvgRating() >= 4.5) { %>
                                    <div class="card-badge">Top Rated</div>
                                <% } %>
                            </div>
                        <% } %>
                        <div class="card-header">
                            <h3 class="card-title"><%= escapeHtml(recipe.getTitle()) %></h3>
                        </div>
                        <div class="card-body">
                            <div class="recipe-meta">
                                <span><i class="fas fa-utensils"></i> <%= escapeHtml(recipe.getCuisine()) %></span>
                                <span><i class="fas fa-tag"></i> <%= escapeHtml(recipe.getCategory()) %></span>
                            </div>
                            
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <span class="rating-score"><%= recipe.getAvgRating() %></span>
                            </div>
                            
                            <% if (recipe.getDescription() != null && !recipe.getDescription().isEmpty()) { %>
                                <div class="recipe-description">
                                    <%= escapeHtml(recipe.getDescription().length() > 100 ? 
                                        recipe.getDescription().substring(0, 100) + "..." : 
                                        recipe.getDescription()) %>
                                </div>
                            <% } %>
                            
                            <div class="tags">
                                <span class="tag">Quick</span>
                                <span class="tag">Healthy</span>
                                <% if (recipe.getCategory() != null) { %>
                                    <span class="tag"><%= escapeHtml(recipe.getCategory()) %></span>
                                <% } %>
                            </div>
                        </div>
                        <div class="card-footer">
                            <a href="view-recipe?recipeId=<%= recipe.getRecipeId() %>" class="btn">View Recipe</a>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> No recipes available at this time. Check back later!
            </div>
        <% } %>

        <div class="form-footer" style="margin-top: 30px;">
            <a href="search-recipes.jsp" class="btn btn-secondary"><i class="fas fa-search"></i> Search Recipes</a>
        </div>
    </div>
  </body>
</html>
