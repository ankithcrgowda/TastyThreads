package com.tap.controller;

import com.tap.dao.UserDAO;
import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;
import com.tap.util.PasswordUtil;
import com.tap.util.CSRFTokenUtil;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public LoginServlet() {
        super();
        userDAO = new UserDAOImpl();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form inputs
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Authenticate user using userDAO
            User user = userDAO.authenticateUser(email, password);

            if (user != null) {
                // Create session and store user info
                HttpSession session = request.getSession(true);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                session.setAttribute("profilePic", user.getProfilePic());
                
                // Generate and store CSRF token
                String csrfToken = CSRFTokenUtil.generateToken();
                session.setAttribute("csrfToken", csrfToken);

                // Redirect based on role
                if ("admin".equals(user.getRole())) {
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    response.sendRedirect("index");
                }
            } else {
                response.sendRedirect("login.jsp?message=Invalid email or password.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?message=Login error: " + e.getMessage());
        }
    }
}
