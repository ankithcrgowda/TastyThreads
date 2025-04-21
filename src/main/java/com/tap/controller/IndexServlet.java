package com.tap.controller;

import com.tap.dao.RecipeDAO;
import com.tap.daoimpl.RecipeDAOImpl;
import com.tap.model.Recipe;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/index")
public class IndexServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RecipeDAO recipeDAO;

    public IndexServlet() {
        super();
        recipeDAO = new RecipeDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get featured recipes (top rated or most recent)
            List<Recipe> recipes = recipeDAO.getFeaturedRecipes(10); // Get top 10 recipes
            
            // Convert Recipe objects to Map objects for JSP
            List<Map<String, Object>> recipeList = new ArrayList<>();
            
            if (recipes != null) {
                for (Recipe recipe : recipes) {
                    Map<String, Object> recipeMap = new HashMap<>();
                    recipeMap.put("recipeId", recipe.getRecipeId());
                    recipeMap.put("title", recipe.getTitle());
                    recipeMap.put("description", recipe.getDescription());
                    recipeMap.put("ingredients", recipe.getIngredients());
                    recipeMap.put("cuisine", recipe.getCuisine());
                    recipeMap.put("category", recipe.getCategory());
                    recipeMap.put("userId", recipe.getUserId());
                    recipeMap.put("imageUrl", recipe.getImageUrl());
                    recipeMap.put("avgRating", recipe.getAvgRating());
                    recipeMap.put("createdAt", recipe.getCreatedAt());
                    
                    recipeList.add(recipeMap);
                }
            }
            
            // Set the recipes attribute to be used in the JSP
            request.setAttribute("recipeList", recipeList);
            
            // Forward to index page
            request.getRequestDispatcher("index.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Continue without recipes if there's an error
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
