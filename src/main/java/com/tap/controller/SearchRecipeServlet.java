package com.tap.controller;

import com.tap.dao.RecipeDAO;
import com.tap.daoimpl.RecipeDAOImpl;
import com.tap.model.Recipe;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/search-recipes")
public class SearchRecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RecipeDAO recipeDAO;

    public SearchRecipeServlet() {
        super();
        recipeDAO = new RecipeDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("query");
        String cuisine = request.getParameter("cuisine");
        String category = request.getParameter("category");
        String ratingParam = request.getParameter("rating");

        float minRating = 0;
        if (ratingParam != null && !ratingParam.isEmpty()) {
            minRating = Float.parseFloat(ratingParam);
        }

        List<Recipe> recipes = recipeDAO.searchRecipes(query, cuisine, category, minRating);

        request.setAttribute("recipes", recipes);
        request.getRequestDispatcher("search-recipes.jsp").forward(request, response);
    }
}
