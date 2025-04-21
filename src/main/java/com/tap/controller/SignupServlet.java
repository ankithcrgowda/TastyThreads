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

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public SignupServlet() {
        super();
        userDAO = new UserDAOImpl();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get form data
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String profilePic = request.getParameter("profilePic");

        // Hash password before storing in DB
        String hashedPassword = PasswordUtil.hashPassword(password);

        // Create user object
        User newUser = new User(0, username, email, hashedPassword, "user", profilePic);

        // Insert user into DB
        boolean isRegistered = userDAO.addUser(newUser);

        if (isRegistered) {
            response.sendRedirect("login.jsp?message=Registration successful! Please login.");
        } else {
            response.sendRedirect("signup.jsp?message=Error: Email already exists.");
        }
    }
}
