package com.tap.controller;

import java.io.IOException;
import com.tap.util.CSRFTokenUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // For direct access to logout URL, just invalidate the session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("login.jsp?message=Logged out successfully.");
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // For extra security, validate CSRF token
            String sessionToken = (String) session.getAttribute("csrfToken");
            String requestToken = request.getParameter("csrfToken");
            
            boolean validToken = sessionToken != null && requestToken != null && 
                                 CSRFTokenUtil.validateToken(sessionToken, requestToken);
            
            // Always invalidate session regardless of token validity
            session.invalidate();
            
            if (!validToken) {
                // Log potential CSRF attempt
                System.out.println("WARNING: Potential CSRF attempt in logout");
            }
        }
        
        response.sendRedirect("login.jsp?message=Logged out successfully.");
    }
}
