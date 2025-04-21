<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Recipe Review</title>
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
                <li><a href="profile.jsp" class="active">Profile</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </div>
    </header>

    <div class="container">
        <div class="profile-container fade-in">
            <% 
                if (session == null || session.getAttribute("userId") == null) {
                    response.sendRedirect("login.jsp?message=Please login to view your profile.");
                    return;
                }
                
                String username = (String) session.getAttribute("username");
                Integer userId = (Integer) session.getAttribute("userId");
            %>

            <div class="profile-header">
                <h2 class="form-title"><i class="fas fa-user-circle"></i> Welcome, <%= escapeHtml(username) %>!</h2>
            </div>

            <div class="profile-actions">
                <a href="add-recipe.jsp" class="btn btn-primary">
                    <i class="fas fa-plus-circle"></i> Add New Recipe
                </a>
                <a href="view-my-recipes.jsp" class="btn btn-secondary">
                    <i class="fas fa-book"></i> My Recipes
                </a>
                <a href="my-reviews.jsp" class="btn btn-secondary">
                    <i class="fas fa-star"></i> My Reviews
                </a>
            </div>

            <div class="profile-settings">
                <h3><i class="fas fa-cog"></i> Account Settings</h3>
                <div class="settings-actions">
                    <a href="edit-profile.jsp" class="btn btn-outline">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </a>
                    <a href="change-password.jsp" class="btn btn-outline">
                        <i class="fas fa-key"></i> Change Password
                    </a>
                    <form action="logout" method="post" style="display: inline;">
                        <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

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
</body>
</html>
