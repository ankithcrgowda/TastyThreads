<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.tap.dao.RecipeDAO, com.tap.daoimpl.RecipeDAOImpl, com.tap.model.Recipe" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Recipes - TastyThreads</title>
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
                    <li><a href="search-recipes.jsp" class="active">Recipes</a></li>
                    <li><a href="about.jsp">About Us</a></li>
                    <% if (session.getAttribute("userId") != null) { %>
                        <li><a href="profile.jsp">Profile</a></li>
                        <li><a href="logout.jsp">Logout</a></li>
                    <% } else { %>
                        <li><a href="login.jsp">Login</a></li>
                    <% } %>
                    <li><a href="add-recipe.jsp" class="btn-primary">Add Recipe</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main>
        <section class="search-section">
            <div class="container">
                <h2 class="section-title">Find Your Perfect Recipe</h2>
                
                <div class="search-container">
                    <form action="search-recipes" method="get" class="search-form">
                        <div class="search-row">
                            <div class="search-group">
                                <label for="query" class="search-label">Search by Title or Ingredients</label>
                                <div class="search-bar-container">
                                    <i class="fas fa-search"></i>
                                    <input type="text" id="query" name="query" class="search-input" 
                                           placeholder="Search recipes or ingredients..." 
                                           value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
                                </div>
                            </div>
                        </div>
                        
                        <div class="filters-row">
                            <div class="filter-group">
                                <label for="cuisine" class="filter-label"><i class="fas fa-globe-americas"></i> Cuisine</label>
                                <input type="text" id="cuisine" name="cuisine" class="filter-input" 
                                       placeholder="Italian, Indian, Mexican..." 
                                       value="<%= request.getParameter("cuisine") != null ? request.getParameter("cuisine") : "" %>">
                            </div>
                            
                            <div class="filter-group">
                                <label for="category" class="filter-label"><i class="fas fa-tag"></i> Category</label>
                                <input type="text" id="category" name="category" class="filter-input" 
                                       placeholder="Breakfast, Dessert, Vegetarian..." 
                                       value="<%= request.getParameter("category") != null ? request.getParameter("category") : "" %>">
                            </div>
                            
                            <div class="filter-group">
                                <label for="rating" class="filter-label"><i class="fas fa-star"></i> Min Rating</label>
                                <input type="number" id="rating" name="rating" min="1" max="5" step="0.1" class="filter-input" 
                                       placeholder="4.5" 
                                       value="<%= request.getParameter("rating") != null ? request.getParameter("rating") : "" %>">
                            </div>
                        </div>
                        
                        <button type="submit" class="btn-primary search-button">
                            <i class="fas fa-search"></i> Search Recipes
                        </button>
                    </form>
                </div>

                <% 
                    String query = request.getParameter("query");
                    String cuisine = request.getParameter("cuisine");
                    String category = request.getParameter("category");
                    String ratingParam = request.getParameter("rating");
                    
                    if (query != null || cuisine != null || category != null || ratingParam != null) {
                        RecipeDAO recipeDAO = new RecipeDAOImpl();
                        Float minRating = 0f;
                        try {
                            minRating = ratingParam != null && !ratingParam.isEmpty() ? Float.parseFloat(ratingParam) : 0;
                        } catch (NumberFormatException e) {
                            minRating = 0f;
                        }
                        List<Recipe> recipes = recipeDAO.searchRecipes(query, cuisine, category, minRating);
                %>
                
                <div class="search-results">
                    <h3 class="results-title">Search Results</h3>
                    
                    <% if (recipes.isEmpty()) { %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i> No recipes found matching your criteria. Try adjusting your search parameters.
                        </div>
                    <% } else { %>
                        <div class="grid">
                            <% for (Recipe recipe : recipes) { %>
                                <div class="card">
                                    <% if (recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty()) { %>
                                        <div class="recipe-image-container">
                                            <img src="<%= recipe.getImageUrl() %>" alt="<%= recipe.getTitle() %>" class="recipe-image">
                                            <% if (recipe.getAvgRating() >= 4.5) { %>
                                                <div class="card-badge">Top Rated</div>
                                            <% } %>
                                        </div>
                                    <% } %>
                                    <div class="card-body">
                                        <h3><%= recipe.getTitle() %></h3>
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
                                        
                                        <a href="view-recipe.jsp?recipeId=<%= recipe.getRecipeId() %>" class="btn-secondary">View Recipe</a>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>
                <% } %>
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