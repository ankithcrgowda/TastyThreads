package com.tap.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnectionManager {
    private static String url;
    private static String user;
    private static String password;
    private static String driver;

    static {
        try {
            System.out.println("Loading database configuration...");
            
            // Load database properties from file using ClassLoader
            Properties properties = new Properties();
            InputStream input = DBConnectionManager.class.getClassLoader().getResourceAsStream("db.properties");
            if (input == null) {
                throw new RuntimeException("Unable to find db.properties in classpath");
            }
            properties.load(input);
            
            // Get property values
            url = properties.getProperty("db.url");
            user = properties.getProperty("db.username");
            password = properties.getProperty("db.password");
            driver = properties.getProperty("db.driver");
            
            System.out.println("Database configuration loaded:");
            System.out.println("URL: " + url);
            System.out.println("Username: " + user);
            System.out.println("Driver: " + driver);

            // Register MySQL JDBC Driver
            try {
                Class.forName(driver);
                System.out.println("MySQL JDBC Driver registered successfully");
            } catch (ClassNotFoundException e) {
                System.err.println("Failed to load MySQL JDBC driver: " + e.getMessage());
                e.printStackTrace();
                throw new RuntimeException("Failed to load MySQL JDBC driver. Please ensure mysql-connector-j is in the classpath", e);
            }

        } catch (IOException e) {
            System.err.println("Failed to load database configuration: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to load database configuration", e);
        }
    }

    // Method to get database connection
    public static Connection getConnection() throws SQLException {
        try {
            System.out.println("Attempting to establish database connection...");
            System.out.println("Using URL: " + url);
            System.out.println("Using Username: " + user);
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("Database connection established successfully");
            
            // Test connection with simple query
            try (java.sql.Statement stmt = conn.createStatement()) {
                System.out.println("Testing connection with simple query...");
                ResultSet rs = stmt.executeQuery("SELECT 1");
                if (rs.next()) {
                    System.out.println("Connection test successful!");
                }
            } catch (Exception e) {
                System.err.println("Connection test failed: " + e.getMessage());
            }
            
            return conn;
        } catch (SQLException e) {
            System.err.println("Failed to establish database connection: " + e.getMessage());
            System.err.println("Connection URL: " + url);
            System.err.println("Connection Username: " + user);
            e.printStackTrace();
            throw e;
        }
    }
}
