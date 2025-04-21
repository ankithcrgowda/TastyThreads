<!--  -->%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Review - Recipe Review</title>
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
            <h2 class="form-title">Add a Review</h2>

            <% 
                if (session == null || session.getAttribute("userId") == null) {
                    response.sendRedirect("login.jsp?message=Please login to leave a review.");
                    return;
                }
                String recipeId = request.getParameter("recipeId");
                if (recipeId == null || recipeId.trim().isEmpty()) {
                    response.sendRedirect("search-recipes.jsp?message=Invalid recipe selected.");
                    return;
                }
            %>

            <form action="add-review" method="post">
                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                <input type="hidden" name="recipeId" value="<%= recipeId %>">

                <div class="form-group">
                    <label for="rating" class="form-label"><i class="fas fa-star"></i> Rating:</label>
                    <div class="rating-input">
                        <select id="rating" name="rating" class="form-input" required>
                            <option value="">Select a rating</option>
                            <option value="5">5 - Excellent</option>
                            <option value="4">4 - Very Good</option>
                            <option value="3">3 - Good</option>
                            <option value="2">2 - Fair</option>
                            <option value="1">1 - Poor</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="comment" class="form-label"><i class="fas fa-comment"></i> Your Review:</label>
                    <textarea id="comment" name="comment" class="form-textarea" 
                            maxlength="1000" pattern="[^<>]*"
                            placeholder="Share your experience with this recipe..." 
                            required></textarea>
                </div>

                <button type="submit" class="btn btn-block"><i class="fas fa-paper-plane"></i> Submit Review</button>
            </form>

            <div class="form-footer">
                <a href="view-recipe.jsp?recipeId=<%= recipeId %>" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to Recipe</a>
            </div>
        </div>
    </div>
</body>
</html>