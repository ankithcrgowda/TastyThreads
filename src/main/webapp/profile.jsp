<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - TastyThreads</title>
    <link rel="icon" type="image/png" href="templates/images/Tasty Threads.png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&family=Roboto+Slab&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="templates/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <% 
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?message=Please login to view your profile.");
            return;
        }
        
        String username = (String) session.getAttribute("username");
        Integer userId = (Integer) session.getAttribute("userId");
        String profilePic = (String) session.getAttribute("profilePic");
        String message = request.getParameter("message");
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
                    <li><a href="view-recipe.jsp">Recipes</a></li>
                    <li><a href="about.jsp">About Us</a></li>
                    <li><a href="profile.jsp" class="active">Profile</a></li>
                    <li><a href="logout.jsp">Logout</a></li>
                    <li><a href="add-recipe.jsp" class="btn-primary">Add Recipe</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <section class="profile-section">
        <div class="container">
            <% if (message != null && !message.isEmpty()) { %>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> <%= escapeHtml(message) %>
                </div>
            <% } %>
            
            <div class="profile-container">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <% if (profilePic != null && !profilePic.isEmpty()) { %>
                            <img id="avatar-preview" src="<%= escapeHtml(profilePic) %>" alt="Profile Picture">
                        <% } else { %>
                            <img id="avatar-preview" src="templates/images/dp.png" alt="Profile Picture">
                        <% } %>
                        <div class="avatar-upload">
                            <form id="profile-pic-form" action="update-profile-pic" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                                <label for="avatar-upload" class="btn-secondary">
                                    <i class="fas fa-camera"></i> Change Photo
                                </label>
                                <input type="file" id="avatar-upload" name="profilePic" accept="image/*" style="display: none;">
                            </form>
                        </div>
                    </div>
                    <div class="profile-info">
                        <h2 id="username"><%= escapeHtml(username) %></h2>
                        <p class="member-since">Member ID: <span id="join-date"><%= userId %></span></p>
                    </div>
                </div>

                <div class="profile-content">
                    <div class="profile-tabs">
                        <button class="tab-btn active" data-tab="actions">Quick Actions</button>
                        <button class="tab-btn" data-tab="settings">Settings</button>
                    </div>

                    <div class="tab-content" id="actions-content">
                        <div class="action-buttons">
                            <a href="add-recipe.jsp" class="btn-primary">
                                <i class="fas fa-plus-circle"></i> Add New Recipe
                            </a>
                            <a href="view-my-recipes.jsp" class="btn-secondary">
                                <i class="fas fa-book"></i> My Recipes
                            </a>
                            <a href="my-reviews.jsp" class="btn-secondary">
                                <i class="fas fa-star"></i> My Reviews
                            </a>
                        </div>
                    </div>

                    <div class="tab-content hidden" id="settings-content">
                        <form id="settings-form" action="update-profile" method="POST" class="settings-form" onsubmit="return validateProfileUpdate()">
                            <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                            <div class="form-group">
                                <label for="username-input">Username</label>
                                <input type="text" id="username-input" name="username" value="<%= escapeHtml(username) %>" required>
                            </div>
                            <div class="form-group">
                                <label for="current-password">Current Password</label>
                                <input type="password" id="current-password" name="currentPassword" required>
                            </div>
                            <div class="form-group">
                                <label for="new-password">New Password</label>
                                <input type="password" id="new-password" name="newPassword">
                                <small>Leave blank if you don't want to change your password</small>
                            </div>
                            <div class="form-group">
                                <label for="confirm-password">Confirm New Password</label>
                                <input type="password" id="confirm-password" name="confirmPassword">
                            </div>
                            <button type="submit" class="btn-primary">Save Changes</button>
                        </form>
                        
                        <div class="logout-section">
                            <form action="logout" method="POST">
                                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                                <button type="submit" class="btn-danger">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <script>
        // Tab switching functionality
        document.querySelectorAll('.tab-btn').forEach(button => {
            button.addEventListener('click', () => {
                // Remove active class from all buttons and hide all content
                document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
                document.querySelectorAll('.tab-content').forEach(content => content.classList.add('hidden'));
                
                // Add active class to clicked button and show corresponding content
                button.classList.add('active');
                document.getElementById(`${button.dataset.tab}-content`).classList.remove('hidden');
            });
        });

        // Avatar upload preview and auto-submit
        document.getElementById('avatar-upload').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('avatar-preview').src = e.target.result;
                    // Auto-submit profile picture update when file is selected
                    document.getElementById('profile-pic-form').submit();
                }
                reader.readAsDataURL(file);
            }
        });
        
        // Profile update validation
        function validateProfileUpdate() {
            const newPassword = document.getElementById('new-password').value;
            const confirmPassword = document.getElementById('confirm-password').value;
            
            if (newPassword !== '' && newPassword !== confirmPassword) {
                alert('New password and confirm password do not match');
                return false;
            }
            
            const username = document.getElementById('username-input').value.trim();
            if (username.length < 3) {
                alert('Username must be at least 3 characters long');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html> 