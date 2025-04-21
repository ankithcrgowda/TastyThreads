package com.tap.controller;

import com.tap.dao.UserDAO;
import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;
import com.tap.util.PasswordUtil;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public UpdateProfileServlet() {
        super();
        userDAO = new UserDAOImpl();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?message=Please login to update your profile.");
            return;
        }

        // Get the current user ID from session
        int userId = (int) session.getAttribute("userId");
        
        // Get form data
        String username = request.getParameter("username");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        
        // Get current user from database
        User currentUser = userDAO.getUserById(userId);
        
        if (currentUser == null) {
            response.sendRedirect("profile.jsp?message=User not found. Please login again.");
            return;
        }
        
        // Verify current password
        String hashedCurrentPassword = PasswordUtil.hashPassword(currentPassword);
        if (!currentUser.getPassword().equals(hashedCurrentPassword)) {
            response.sendRedirect("profile.jsp?message=Current password is incorrect.");
            return;
        }
        
        // Update username
        currentUser.setUsername(username);
        
        // Update password if a new one was provided
        if (newPassword != null && !newPassword.isEmpty()) {
            String hashedNewPassword = PasswordUtil.hashPassword(newPassword);
            currentUser.setPassword(hashedNewPassword);
        }
        
        // Update user in database
        boolean isUpdated = userDAO.updateUser(currentUser);
        
        if (isUpdated) {
            // Update session with new username
            session.setAttribute("username", username);
            response.sendRedirect("profile.jsp?message=Profile updated successfully!");
        } else {
            response.sendRedirect("profile.jsp?message=Failed to update profile. Please try again.");
        }
    }
} 