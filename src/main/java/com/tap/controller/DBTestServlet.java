package com.tap.controller;


import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.tap.util.DBConnectionManager;


@WebServlet("/test-db")
public class DBTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try (Connection conn = DBConnectionManager.getConnection()) {
            if (conn != null) {
                out.println("<h2>Database Connection Successful!</h2>");
            } else {
                out.println("<h2>Database Connection Failed!</h2>");
            }
        } catch (SQLException e) {
            out.println("<h2>Database Connection Error: " + e.getMessage() + "</h2>");
            e.printStackTrace();
        }
    }
}
