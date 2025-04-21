<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tap.model.Recipe, com.tap.model.Review, com.tap.model.User, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recipe Details - Recipe Review</title>
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
                <% if (session.getAttribute("userId") != null) { %>
                    <li><a href="profile.jsp">Profile</a></li>
                    <li><a href="logout">Logout</a></li>
                <% } else { %>
                    <li><a href="login.jsp">Login</a></li>
                    <li><a href="signup.jsp">Sign Up</a></li>
                <% } %>
            </ul>
        </div>
    </header>

    <div class="container">
        <%
            Recipe recipe = (Recipe) request.getAttribute("recipe");
            List<Review> reviews = (List<Review>) request.getAttribute("reviews");

            if (recipe != null) {
        %>
        <div class="form-container fade-in" style="max-width: 800px;">
            <div class="recipe-header">
                <% if (recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty()) { %>
                    <div class="recipe-image-container" style="margin-bottom: 20px;">
                        <img src="<%= recipe.getImageUrl() %>" alt="<%= recipe.getTitle() %>" style="width: 100%; height: auto; max-height: 400px; object-fit: cover; border-radius: 8px;">
                        <% if (recipe.getAvgRating() >= 4.5) { %>
                            <div class="card-badge">Top Rated</div>
                        <% } %>
                    </div>
                <% } %>
                
                <h2 class="form-title" style="text-align: left; margin-bottom: 10px;"><%= recipe.getTitle() %></h2>
                
                <div class="recipe-meta" style="margin-bottom: 20px;">
                    <span><i class="fas fa-utensils"></i> <%= recipe.getCuisine() %></span>
                    <span><i class="fas fa-tag"></i> <%= recipe.getCategory() %></span>
                    <div class="rating">
                        <i class="fas fa-star"></i>
                        <span class="rating-score"><%= recipe.getAvgRating() %></span>
                    </div>
                </div>
                
                <div class="tags">
                    <span class="tag"><%= recipe.getCategory() %></span>
                    <span class="tag"><%= recipe.getCuisine() %></span>
                    <span class="tag">Homemade</span>
                </div>
            </div>
            
            <div class="recipe-content" style="margin-top: 20px;">
                <h3 style="color: var(--primary-red); margin-bottom: 10px;">Description</h3>
                <p style="margin-bottom: 20px;"><%= recipe.getDescription() %></p>
                
                <h3 style="color: var(--primary-red); margin-bottom: 10px;">Ingredients</h3>
                <div style="background-color: var(--light-gray); padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                    <% if (recipe.getIngredients() != null && !recipe.getIngredients().isEmpty()) { 
                        String[] ingredients = recipe.getIngredients().split("\n");
                        for (String ingredient : ingredients) {
                            if (!ingredient.trim().isEmpty()) {
                    %>
                        <div style="display: flex; align-items: center; margin-bottom: 8px;">
                            <i class="fas fa-check-circle" style="color: var(--primary-red); margin-right: 10px;"></i>
                            <span><%= ingredient.trim() %></span>
                        </div>
                    <% 
                            }
                        }
                    } %>
                </div>
            </div>
            
            <div class="reviews-section" style="margin-top: 30px;">
                <h3 style="color: var(--primary-red); margin-bottom: 15px;">Reviews</h3>
                
                <% if (reviews != null && !reviews.isEmpty()) { %>
                    <div class="reviews-container" style="max-height: 400px; overflow-y: auto; margin-bottom: 20px;">
                        <% for (Review rev : reviews) { %>
                            <div class="review" style="background-color: var(--light-gray); padding: 15px; border-radius: 8px; margin-bottom: 15px;">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                                    <div style="display: flex; align-items: center;">
                                        <i class="fas fa-user-circle" style="font-size: 24px; color: var(--dark-gray); margin-right: 10px;"></i>
                                        <span style="font-weight: 600;">User <%= rev.getUserId() %></span>
                                    </div>
                                    <div class="rating" style="margin: 0;">
                                        <i class="fas fa-star"></i>
                                        <span class="rating-score"><%= rev.getRating() %></span>
                                    </div>
                                </div>
                                <p style="font-style: italic;">"<%= rev.getComment() %>"</p>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="alert alert-error">
                        <i class="fas fa-info-circle"></i> No reviews yet. Be the first to review this recipe!
                    </div>
                <% } %>
                
                <% if (session.getAttribute("userId") != null) { %>
                    <div style="margin-top: 20px;">
                        <a href="add-review.jsp?recipeId=<%= recipe.getRecipeId() %>" class="btn btn-block">
                            <i class="fas fa-star"></i> Write a Review
                        </a>
                    </div>
                <% } else { %>
                    <div class="alert alert-error" style="margin-top: 20px;">
                        <i class="fas fa-lock"></i> <a href="login.jsp" style="color: inherit; text-decoration: underline;">Log in</a> to rate and comment on this recipe.
                    </div>
                <% } %>
            </div>
            
            <div class="form-footer" style="margin-top: 30px;">
                <a href="index" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to All Recipes</a>
            </div>
        </div>
        <% } else { %>
            <div class="alert alert-error" style="max-width: 600px; margin: 40px auto;">
                <i class="fas fa-exclamation-circle"></i> Recipe not found. The recipe you're looking for may have been removed or doesn't exist.
                <div style="margin-top: 15px;">
                    <a href="index" class="btn btn-secondary"><i class="fas fa-home"></i> Go to Homepage</a>
                </div>
            </div>
        <% } %>
    </div>
</body>
</html>