package com.tap.controller;

import com.tap.dao.RecipeDAO;
import com.tap.daoimpl.RecipeDAOImpl;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/delete-recipe")
public class DeleteRecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RecipeDAO recipeDAO;

    public DeleteRecipeServlet() {
        super();
        recipeDAO = new RecipeDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?message=Please login to delete recipes.");
            return;
        }

        int recipeId = Integer.parseInt(request.getParameter("recipeId"));
        boolean isDeleted = recipeDAO.deleteRecipe(recipeId);

        response.sendRedirect("view-my-recipes.jsp?message=" + (isDeleted ? "Recipe deleted successfully!" : "Error deleting recipe."));
    }
}
