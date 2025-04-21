package com.tap.dao;

import com.tap.model.User;
import java.util.List;

public interface UserDAO {
    // Create a new user
    boolean addUser(User user);

    // Retrieve a user by ID
    User getUserById(int userId);

    // Retrieve a user by email
    User getUserByEmail(String email);

    // Retrieve all users (for admin purposes)
    List<User> getAllUsers();

    // Update user details
    boolean updateUser(User user);

    // Delete a user by ID
    boolean deleteUser(int userId);

    // Authenticate user (returns User if valid, else null)
    User authenticateUser(String email, String password);
}
