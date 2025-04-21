package com.tap.controller;

import com.tap.dao.UserDAO;
import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/user-test")
public class UserTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public UserTestServlet() {
        super();
        userDAO = new UserDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<h2>User DAO Test</h2>");
        
        // Test: Add a new user
        User newUser = new User(0, "testuser", "testuser@example.com", "password123", "user", null);
        boolean userAdded = userDAO.addUser(newUser);
        out.println("<p>New User Added: " + userAdded + "</p>");

        // Test: Retrieve user by email
        User retrievedUser = userDAO.getUserByEmail("testuser@example.com");
        if (retrievedUser != null) {
            out.println("<p>Retrieved User: " + retrievedUser.getUsername() + ", Email: " + retrievedUser.getEmail() + "</p>");
        } else {
            out.println("<p>User not found.</p>");
        }

        // Test: Retrieve all users
        List<User> users = userDAO.getAllUsers();
        out.println("<h3>All Users:</h3>");
        for (User user : users) {
            out.println("<p>" + user.toString() + "</p>");
        }

        // Test: Update user
        if (retrievedUser != null) {
            retrievedUser.setUsername("updateduser");
            boolean userUpdated = userDAO.updateUser(retrievedUser);
            out.println("<p>User Updated: " + userUpdated + "</p>");
        }

        // Test: Delete user
        if (retrievedUser != null) {
            boolean userDeleted = userDAO.deleteUser(retrievedUser.getUserId());
            out.println("<p>User Deleted: " + userDeleted + "</p>");
        }
    }
}
