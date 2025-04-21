package com.tap.controller;

import com.tap.dao.RecipeDAO;
import com.tap.dao.ReviewDAO;
import com.tap.daoimpl.RecipeDAOImpl;
import com.tap.daoimpl.ReviewDAOImpl;
import com.tap.model.Recipe;
import com.tap.model.Review;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/view-recipe")
public class ViewRecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RecipeDAO recipeDAO;
    private ReviewDAO reviewDAO;

    public ViewRecipeServlet() {
        super();
        recipeDAO = new RecipeDAOImpl();
        reviewDAO = new ReviewDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int recipeId = Integer.parseInt(request.getParameter("recipeId"));

        // Fetch recipe details
        Recipe recipe = recipeDAO.getRecipeById(recipeId);
        if (recipe == null) {
            response.sendRedirect("index.jsp?message=Recipe not found");
            return;
        }

        // Fetch reviews for this recipe
        List<Review> reviews = reviewDAO.getReviewsByRecipeId(recipeId);

        // Set attributes for JSP
        request.setAttribute("recipe", recipe);
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("view-recipe.jsp").forward(request, response);
    }
}
