<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.tap.dao.RecipeDAO, com.tap.daoimpl.RecipeDAOImpl, com.tap.model.Recipe" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Recipes - Recipe Review</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <header class="header">
        <div class="header-container">
            <a href="index.jsp" class="logo">Recipe Review</a>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="search-recipes.jsp" class="active">Recipes</a></li>
                <li><a href="login.jsp">Login</a></li>
                <li><a href="signup.jsp">Sign Up</a></li>
            </ul>
        </div>
    </header>

    <div class="container">
        <h2 class="form-title">Find Your Perfect Recipe</h2>
        
        <div class="card">
            <div class="card-body">
                <form action="search-recipes" method="get" class="search-form">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="query" class="form-label">Search by Title or Ingredients:</label>
                            <div class="search-bar">
                                <input type="text" id="query" name="query" class="search-input" placeholder="Search recipes or ingredients..." value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
                                <button type="submit" class="search-btn"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="cuisine" class="form-label"><i class="fas fa-globe-americas"></i> Filter by Cuisine:</label>
                            <input type="text" id="cuisine" name="cuisine" class="form-input" placeholder="Italian, Indian, Mexican..." value="<%= request.getParameter("cuisine") != null ? request.getParameter("cuisine") : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="category" class="form-label"><i class="fas fa-tag"></i> Filter by Category:</label>
                            <input type="text" id="category" name="category" class="form-input" placeholder="Breakfast, Dessert, Vegetarian..." value="<%= request.getParameter("category") != null ? request.getParameter("category") : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="rating" class="form-label"><i class="fas fa-star"></i> Minimum Rating:</label>
                            <input type="number" id="rating" name="rating" min="1" max="5" step="0.1" class="form-input" placeholder="4.5" value="<%= request.getParameter("rating") != null ? request.getParameter("rating") : "" %>">
                        </div>
                    </div>
                    
                    <button type="submit" class="btn"><i class="fas fa-search"></i> Search Recipes</button>
                </form>
            </div>
        </div>

        <% 
            String query = request.getParameter("query");
            String cuisine = request.getParameter("cuisine");
            String category = request.getParameter("category");
            String ratingParam = request.getParameter("rating");
            
            if (query != null || cuisine != null || category != null || ratingParam != null) {
                RecipeDAO recipeDAO = new RecipeDAOImpl();
                List<Recipe> recipes = recipeDAO.searchRecipes(query, cuisine, category, ratingParam != null ? Float.parseFloat(ratingParam) : 0);
        %>
        
        <div class="search-results">
            <h3 class="section-title">Search Results</h3>
            
            <% if (recipes.isEmpty()) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> No recipes found matching your criteria. Try adjusting your search parameters.
                </div>
            <% } else { %>
                <div class="grid">
                    <% for (Recipe recipe : recipes) { %>
                        <div class="card fade-in">
                            <% if (recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty()) { %>
                                <div class="recipe-image-container">
                                    <img src="<%= recipe.getImageUrl() %>" alt="<%= recipe.getTitle() %>" class="recipe-image">
                                    <% if (recipe.getAvgRating() >= 4.5) { %>
                                        <div class="card-badge">Top Rated</div>
                                    <% } %>
                                </div>
                            <% } %>
                            <div class="card-header">
                                <h3 class="card-title"><%= recipe.getTitle() %></h3>
                            </div>
                            <div class="card-body">
                                <div class="recipe-meta">
                                    <span><i class="fas fa-utensils"></i> <%= recipe.getCuisine() %></span>
                                    <span><i class="fas fa-tag"></i> <%= recipe.getCategory() %></span>
                                </div>
                                
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <span class="rating-score"><%= recipe.getAvgRating() %></span>
                                </div>
                                
                                <% if (recipe.getDescription() != null && !recipe.getDescription().isEmpty()) { %>
                                    <div class="recipe-description">
                                        <%= recipe.getDescription().length() > 100 ? recipe.getDescription().substring(0, 100) + "..." : recipe.getDescription() %>
                                    </div>
                                <% } %>
                                
                                <div class="tags">
                                    <span class="tag"><%= recipe.getCategory() %></span>
                                    <span class="tag"><%= recipe.getCuisine() %></span>
                                </div>
                            </div>
                            <div class="card-footer">
                                <a href="view-recipe.jsp?recipeId=<%= recipe.getRecipeId() %>" class="btn">View Recipe</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
        <% } %>
        
        <div class="form-footer">
            <a href="profile.jsp" class="btn btn-secondary"><i class="fas fa-user"></i> Back to Profile</a>
        </div>
    </div>
</body>
</html>