package com.tap.controller;

import com.tap.dao.UserDAO;
import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;

import java.io.File;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/update-profile-pic")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 5 * 1024 * 1024,  // 5 MB
    maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class UpdateProfilePicServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private static final String UPLOAD_DIRECTORY = "uploads/profile";

    public UpdateProfilePicServlet() {
        super();
        userDAO = new UserDAOImpl();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?message=Please login to update your profile picture.");
            return;
        }

        // Get user ID from session
        int userId = (int) session.getAttribute("userId");
        
        // Create upload directory if it doesn't exist
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIRECTORY;
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        try {
            Part filePart = request.getPart("profilePic");
            if (filePart != null && filePart.getSize() > 0) {
                // Get file name
                String fileName = getSubmittedFileName(filePart);
                
                // Ensure the file is an image
                if (!isImageFile(fileName)) {
                    response.sendRedirect("profile.jsp?message=Only image files are allowed.");
                    return;
                }
                
                // Create unique file name to prevent overwriting
                String uniqueFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;
                String filePath = uploadPath + File.separator + uniqueFileName;
                
                // Save file to server
                filePart.write(filePath);
                
                // Update image URL in database
                String imageUrl = UPLOAD_DIRECTORY + "/" + uniqueFileName;
                User user = userDAO.getUserById(userId);
                user.setProfilePic(imageUrl);
                boolean isUpdated = userDAO.updateUser(user);
                
                if (isUpdated) {
                    // Update session with new profile pic
                    session.setAttribute("profilePic", imageUrl);
                    response.sendRedirect("profile.jsp?message=Profile picture updated successfully!");
                } else {
                    response.sendRedirect("profile.jsp?message=Failed to update profile picture in database.");
                }
            } else {
                response.sendRedirect("profile.jsp?message=No file was uploaded.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?message=Error uploading file: " + e.getMessage());
        }
    }
    
    // Helper method to extract filename from part
    private String getSubmittedFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
    
    // Helper method to check if file is an image
    private boolean isImageFile(String fileName) {
        if (fileName == null) {
            return false;
        }
        String lowerCaseFileName = fileName.toLowerCase();
        return lowerCaseFileName.endsWith(".jpg") || 
               lowerCaseFileName.endsWith(".jpeg") || 
               lowerCaseFileName.endsWith(".png") || 
               lowerCaseFileName.endsWith(".gif") || 
               lowerCaseFileName.endsWith(".bmp");
    }
} 