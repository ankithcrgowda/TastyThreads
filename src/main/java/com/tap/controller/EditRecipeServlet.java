package com.tap.controller;

import com.tap.dao.RecipeDAO;
import com.tap.daoimpl.RecipeDAOImpl;
import com.tap.model.Recipe;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/edit-recipe")
public class EditRecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RecipeDAO recipeDAO;

    public EditRecipeServlet() {
        super();
        recipeDAO = new RecipeDAOImpl();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?message=Please login to edit recipes.");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int recipeId = Integer.parseInt(request.getParameter("recipeId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String ingredients = request.getParameter("ingredients");
        String cuisine = request.getParameter("cuisine");
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("imageUrl");

        Recipe existingRecipe = recipeDAO.getRecipeById(recipeId);

        if (existingRecipe == null || existingRecipe.getUserId() != userId) {
            response.sendRedirect("view-my-recipes.jsp?message=Unauthorized access.");
            return;
        }

        Recipe updatedRecipe = new Recipe(recipeId, title, description, ingredients, cuisine, category, userId, imageUrl, existingRecipe.getAvgRating(), existingRecipe.getCreatedAt());
        boolean isUpdated = recipeDAO.updateRecipe(updatedRecipe);

        if (isUpdated) {
            response.sendRedirect("view-my-recipes.jsp?message=Recipe updated successfully!");
        } else {
            response.sendRedirect("edit-recipe.jsp?recipeId=" + recipeId + "&message=Error updating recipe.");
        }
    }
}
