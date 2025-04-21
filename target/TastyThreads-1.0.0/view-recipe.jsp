<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tap.model.Recipe, com.tap.model.Review, com.tap.model.User, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recipe Details - TastyThreads</title>
    <link rel="icon" type="image/png" href="templates/images/Tasty Threads.png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&family=Roboto+Slab&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="templates/css/style.css">
    <link rel="stylesheet" href="templates/css/recipe-detail.css">
    <link rel="stylesheet" href="templates/css/animations.css">
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
        <section class="recipe-detail-section">
            <div class="container">
                <%
                    Recipe recipe = (Recipe) request.getAttribute("recipe");
                    List<Review> reviews = (List<Review>) request.getAttribute("reviews");

                    if (recipe != null) {
                %>
                <div class="recipe-detail-container">
                    <div class="recipe-header">
                        <% if (recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty()) { %>
                            <div class="recipe-image-container">
                                <img src="<%= recipe.getImageUrl() %>" alt="<%= recipe.getTitle() %>" class="recipe-image">
                                <% if (recipe.getAvgRating() >= 4.5) { %>
                                    <div class="card-badge">Top Rated</div>
                                <% } %>
                            </div>
                        <% } %>
                        
                        <h1 class="recipe-title"><%= recipe.getTitle() %></h1>
                        
                        <div class="recipe-meta">
                            <span><i class="fas fa-utensils"></i> <%= recipe.getCuisine() %></span>
                            <span><i class="fas fa-tag"></i> <%= recipe.getCategory() %></span>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <span class="rating-score"><%= recipe.getAvgRating() %></span>
                                <% if (reviews != null) { %>
                                    <span>(<%= reviews.size() %> reviews)</span>
                                <% } %>
                            </div>
                        </div>
                        
                        <div class="tags">
                            <span class="tag"><%= recipe.getCategory() %></span>
                            <span class="tag"><%= recipe.getCuisine() %></span>
                            <span class="tag">Homemade</span>
                        </div>
                    </div>
                    
                    <div class="recipe-content">
                        <section class="recipe-section">
                            <h2><i class="fas fa-info-circle"></i> Description</h2>
                            <p><%= recipe.getDescription() %></p>
                        </section>

                        <section class="recipe-section">
                            <h2><i class="fas fa-list"></i> Ingredients</h2>
                            <div class="ingredients-list">
                                <% if (recipe.getIngredients() != null && !recipe.getIngredients().isEmpty()) { 
                                    String[] ingredients = recipe.getIngredients().split("\n");
                                    for (String ingredient : ingredients) {
                                        if (!ingredient.trim().isEmpty()) {
                                %>
                                    <div class="ingredient-item">
                                        <i class="fas fa-check-circle"></i>
                                        <span><%= ingredient.trim() %></span>
                                    </div>
                                <% 
                                        }
                                    }
                                } %>
                            </div>
                        </section>

                        <section class="recipe-section reviews-section">
                            <h2><i class="fas fa-comments"></i> Reviews</h2>
                            
                            <% if (reviews != null && !reviews.isEmpty()) { %>
                                <div class="reviews-container">
                                    <% for (Review rev : reviews) { %>
                                        <div class="review-card">
                                            <div class="review-header">
                                                <div class="reviewer-info">
                                                    <i class="fas fa-user-circle"></i>
                                                    <span class="reviewer-name">User <%= rev.getUserId() %></span>
                                                </div>
                                                <div class="rating">
                                                    <i class="fas fa-star"></i>
                                                    <span class="rating-score"><%= rev.getRating() %></span>
                                                </div>
                                            </div>
                                            <p class="review-text">"<%= rev.getComment() %>"</p>
                                        </div>
                                    <% } %>
                                </div>
                            <% } else { %>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle"></i> No reviews yet. Be the first to review this recipe!
                                </div>
                            <% } %>

                            <div class="review-prompt">
                                <% if (session.getAttribute("userId") != null) { %>
                                    <a href="add-review.jsp?recipeId=<%= recipe.getRecipeId() %>" class="btn-primary">
                                        <i class="fas fa-star"></i> Write a Review
                                    </a>
                                <% } else { %>
                                    <p>Want to share your experience? <a href="login.jsp" class="btn-primary">Login to Review</a></p>
                                <% } %>
                            </div>
                        </section>
                        
                        <div class="navigation-buttons">
                            <a href="index.jsp" class="btn-secondary"><i class="fas fa-arrow-left"></i> Back to Recipes</a>
                        </div>
                    </div>
                </div>
                <% } else { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> Recipe not found. The recipe you're looking for may have been removed or doesn't exist.
                        <div class="navigation-buttons">
                            <a href="index.jsp" class="btn-secondary"><i class="fas fa-home"></i> Go to Homepage</a>
                        </div>
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