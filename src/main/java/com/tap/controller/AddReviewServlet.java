package com.tap.controller;

import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.dao.ReviewDAO;
import com.tap.daoimpl.ReviewDAOImpl;
import com.tap.model.Review;

@WebServlet("/add-review")
public class AddReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReviewDAO reviewDAO;

    public AddReviewServlet() {
        super();
        reviewDAO = new ReviewDAOImpl();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?message=Please login to submit a review.");
            return;
        }

        try {
            int userId = (int) session.getAttribute("userId");
            int recipeId = Integer.parseInt(request.getParameter("recipeId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Validate rating
            if (rating < 1 || rating > 5) {
                response.sendRedirect("view-recipe.jsp?recipeId=" + recipeId + "&message=Rating must be between 1 and 5");
                return;
            }

            // Validate comment
            if (comment == null || comment.trim().isEmpty()) {
                response.sendRedirect("view-recipe.jsp?recipeId=" + recipeId + "&message=Comment cannot be empty");
                return;
            }

            Review review = new Review(0, recipeId, userId, rating, comment, new Timestamp(System.currentTimeMillis()));
            boolean success = reviewDAO.addReview(review);

            if (success) {
                response.sendRedirect("view-recipe.jsp?recipeId=" + recipeId + "&message=Review added successfully!");
            } else {
                response.sendRedirect("view-recipe.jsp?recipeId=" + recipeId + "&message=Failed to add review");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("view-recipe.jsp?recipeId=" + request.getParameter("recipeId") + "&message=Invalid input format");
        } catch (Exception e) {
            response.sendRedirect("view-recipe.jsp?recipeId=" + request.getParameter("recipeId") + "&message=An error occurred");
        }
    }
}
