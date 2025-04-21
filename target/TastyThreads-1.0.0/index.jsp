<%-- 
   This JSP now uses Map instead of Recipe class to avoid ClassNotFoundException issues
   with Jakarta EE 10 / Tomcat 10.x
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TastyThreads - Discover Delicious Recipes</title>
    <link rel="icon" type="image/png" href="templates/images/Tasty Threads.png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&family=Roboto+Slab&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="templates/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="templates/js/carousel.js" defer></script>
    
    <script>
        window.onload = function() {
            // Redirect to the IndexServlet to load recipes
            if (!window.location.href.includes("/index?")) {
                window.location.href = "index";
            }
        }
    </script>
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
            <a href="index" class="logo"><img src="templates/images/Tasty Threads.png" alt="TastyThreads Logo"></a>
            <nav>
                <ul class="nav-links">
                    <li><a href="index.jsp" class="active">Home</a></li>
                    <li><a href="view-recipe.jsp">Recipes</a></li>
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
        <section class="hero">
            <div class="carousel">
                <div class="carousel-slide active" style="background-image: url('templates/images/caroursel_1.jpg')"></div>
                <div class="carousel-slide" style="background-image: url('templates/images/carousel_2.jpg')"></div>
                <div class="carousel-slide" style="background-image: url('templates/images/carousel_3.jpg')"></div>
                <div class="carousel-slide" style="background-image: url('templates/images/carousel_4.jpg')"></div>
                <div class="carousel-dots">
                    <div class="carousel-dot active"></div>
                    <div class="carousel-dot"></div>
                    <div class="carousel-dot"></div>
                    <div class="carousel-dot"></div>
                </div>
            </div>
            <div class="container">
                <h1>Discover & Share Amazing Recipes</h1>
                <p>Join our community of food lovers and find your next favorite dish</p>
                <div class="search-bar">
                    <form action="search-recipes.jsp" method="get">
                        <input type="text" name="query" placeholder="Search for recipes...">
                        <button type="submit" class="btn-primary"><i class="fas fa-search"></i> Search</button>
                    </form>
                </div>
            </div>
        </section>

        <section class="featured-recipes">
            <div class="container">
                <h2>Featured Recipes</h2>
                
                <%
                    List<Map<String, Object>> recipeList = (List<Map<String, Object>>) request.getAttribute("recipeList");
                    if (recipeList == null || recipeList.isEmpty()) {
                %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> No recipes available at this time. Check back later!
                    </div>
                <%
                    } else {
                %>
                    <div class="grid">
                        <% for (Map<String, Object> recipe : recipeList) { %>
                            <div class="card">
                                <% if (recipe.get("imageUrl") != null && !((String)recipe.get("imageUrl")).isEmpty()) { %>
                                    <div class="recipe-image-container">
                                        <img src="<%= escapeHtml((String)recipe.get("imageUrl")) %>" 
                                             alt="<%= escapeHtml((String)recipe.get("title")) %>" 
                                             class="recipe-image">
                                        <% if ((Float)recipe.get("avgRating") >= 4.5f) { %>
                                            <div class="card-badge">Top Rated</div>
                                        <% } %>
                                    </div>
                                <% } %>
                                <div class="card-body">
                                    <h3><%= escapeHtml((String)recipe.get("title")) %></h3>
                                    <div class="recipe-meta">
                                        <span><i class="fas fa-utensils"></i> <%= escapeHtml((String)recipe.get("cuisine")) %></span>
                                        <span><i class="fas fa-tag"></i> <%= escapeHtml((String)recipe.get("category")) %></span>
                                    </div>
                                    
                                    <div class="rating">
                                        <i class="fas fa-star"></i>
                                        <span class="rating-score"><%= recipe.get("avgRating") %></span>
                                    </div>
                                    
                                    <% if (recipe.get("description") != null && !((String)recipe.get("description")).isEmpty()) { %>
                                        <div class="recipe-description">
                                            <%
                                                String desc = (String)recipe.get("description");
                                                if (desc.length() > 100) {
                                                    desc = desc.substring(0, 100) + "...";
                                                }
                                            %>
                                            <%= escapeHtml(desc) %>
                                        </div>
                                    <% } %>
                                    
                                    <a href="view-recipe?recipeId=<%= recipe.get("recipeId") %>" class="btn-secondary">View Recipe</a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
                
                <div class="view-all-container">
                    <a href="search-recipes.jsp" class="btn-primary"><i class="fas fa-search"></i> Browse All Recipes</a>
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