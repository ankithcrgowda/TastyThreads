package com.tap.controller;

import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.dao.RecipeDAO;
import com.tap.daoimpl.RecipeDAOImpl;
import com.tap.model.Recipe;
import com.tap.util.CSRFTokenUtil;

@WebServlet("/add-recipe")
public class AddRecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RecipeDAO recipeDAO;

    public AddRecipeServlet() {
        super();
        recipeDAO = new RecipeDAOImpl();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Validate user session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?message=Please login to add a recipe.");
            return;
        }

        // Validate CSRF token
        String sessionToken = (String) session.getAttribute("csrfToken");
        String requestToken = request.getParameter("csrfToken");
        
        if (!CSRFTokenUtil.validateToken(sessionToken, requestToken)) {
            response.sendRedirect("add-recipe.jsp?message=Invalid request. Please try again.");
            return;
        }

        try {
            // Get form data
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String ingredients = request.getParameter("ingredients");
            String cuisine = request.getParameter("cuisine");
            String category = request.getParameter("category");
            String imageUrl = request.getParameter("imageUrl");

            // Validate required fields
            if (title == null || title.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                ingredients == null || ingredients.trim().isEmpty() ||
                cuisine == null || cuisine.trim().isEmpty() ||
                category == null || category.trim().isEmpty()) {
                
                response.sendRedirect("add-recipe.jsp?message=All required fields must be filled out.");
                return;
            }

            // Get the logged-in user's ID
            int userId = (int) session.getAttribute("userId");

            // Create recipe object
            Recipe recipe = new Recipe(0, title, description, ingredients, cuisine, category, userId, imageUrl, 0.0f, 
                           new Timestamp(System.currentTimeMillis()));

            // Insert recipe into the database
            boolean isAdded = recipeDAO.addRecipe(recipe);

            if (isAdded) {
                response.sendRedirect("view-my-recipes.jsp?message=Recipe added successfully!");
            } else {
                response.sendRedirect("add-recipe.jsp?message=Error adding recipe. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add-recipe.jsp?message=Error: " + e.getMessage());
        }
    }
}
