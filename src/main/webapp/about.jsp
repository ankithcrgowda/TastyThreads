<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - TastyThreads</title>
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
            <a href="index" class="logo"><img src="templates/images/Tasty Threads.png" alt="TastyThreads Logo"></a>
            <nav>
                <ul class="nav-links">
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="view-recipe.jsp">Recipes</a></li>
                    <li><a href="about.jsp" class="active">About Us</a></li>
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
        <section class="hero about-hero">
            <div class="container">
                <h1>About TastyThreads</h1>
                <p class="lead">Connecting Food Lovers Through Delicious Recipes</p>
            </div>
        </section>

        <section class="about-section">
            <div class="container">
                <div class="mission-container">
                    <h2><i class="fas fa-bullseye"></i> Our Mission</h2>
                    <p>At TastyThreads, we believe that cooking is more than just preparing meals - it's about creating memories, sharing traditions, and bringing people together. Our mission is to make cooking accessible, enjoyable, and inspiring for everyone, from beginners to seasoned chefs.</p>
                </div>

                <div class="values-container">
                    <h2><i class="fas fa-heart"></i> Our Values</h2>
                    <div class="values-grid">
                        <div class="value-card">
                            <i class="fas fa-users"></i>
                            <h3>Community</h3>
                            <p>Building a vibrant community of food enthusiasts who share, learn, and grow together.</p>
                        </div>
                        <div class="value-card">
                            <i class="fas fa-lightbulb"></i>
                            <h3>Innovation</h3>
                            <p>Continuously improving our platform to provide the best recipe sharing experience.</p>
                        </div>
                        <div class="value-card">
                            <i class="fas fa-star"></i>
                            <h3>Quality</h3>
                            <p>Ensuring high-quality, tested recipes that deliver great results every time.</p>
                        </div>
                        <div class="value-card">
                            <i class="fas fa-globe"></i>
                            <h3>Diversity</h3>
                            <p>Celebrating diverse culinary traditions and flavors from around the world.</p>
                        </div>
                    </div>
                </div>

                <div class="team-container">
                    <h2><i class="fas fa-people-group"></i> Our Team</h2>
                    <div class="team-grid">
                        <div class="team-card">
                            <img src="templates/images/dp.png" alt="Team Member">
                            <h3>John Doe</h3>
                            <p class="role">Founder & CEO</p>
                            <p class="bio">Passionate about bringing people together through food.</p>
                        </div>
                        <div class="team-card">
                            <img src="templates/images/dp.png" alt="Team Member">
                            <h3>Jane Smith</h3>
                            <p class="role">Head Chef</p>
                            <p class="bio">Professional chef with 15 years of culinary experience.</p>
                        </div>
                        <div class="team-card">
                            <img src="templates/images/dp.png" alt="Team Member">
                            <h3>Mike Johnson</h3>
                            <p class="role">Community Manager</p>
                            <p class="bio">Dedicated to building our amazing food community.</p>
                        </div>
                    </div>
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