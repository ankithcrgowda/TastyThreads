package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.RecipeDAO;
import com.tap.model.Recipe;
import com.tap.model.Review;
import com.tap.util.DBConnectionManager;

public class RecipeDAOImpl implements RecipeDAO {

    // Insert a new recipe into the database
    @Override
    public boolean addRecipe(Recipe recipe) {
        String sql = "INSERT INTO recipes (title, description, ingredients, cuisine, category, user_id, image_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, recipe.getTitle());
            stmt.setString(2, recipe.getDescription());
            stmt.setString(3, recipe.getIngredients());
            stmt.setString(4, recipe.getCuisine());
            stmt.setString(5, recipe.getCategory());
            stmt.setInt(6, recipe.getUserId());
            stmt.setString(7, recipe.getImageUrl());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Retrieve a recipe by ID
    @Override
    public Recipe getRecipeById(int recipeId) {
        String sql = "SELECT * FROM recipes WHERE recipe_id = ?";
        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, recipeId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractRecipeFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Retrieve all recipes
    @Override
    public List<Recipe> getAllRecipes() {
        List<Recipe> recipes = new ArrayList<>();
        String sql = "SELECT * FROM recipes ORDER BY created_at DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                recipes.add(extractRecipeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipes;
    }
    
    
    

    // Retrieve recipes by user ID
    @Override
    public List<Recipe> getRecipesByUserId(int userId) {
        List<Recipe> recipes = new ArrayList<>();
        String sql = "SELECT * FROM recipes WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                recipes.add(extractRecipeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipes;
    }

    // Update a recipe
    @Override
    public boolean updateRecipe(Recipe recipe) {
        String sql = "UPDATE recipes SET title = ?, description = ?, ingredients = ?, cuisine = ?, category = ?, image_url = ? WHERE recipe_id = ?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, recipe.getTitle());
            stmt.setString(2, recipe.getDescription());
            stmt.setString(3, recipe.getIngredients());
            stmt.setString(4, recipe.getCuisine());
            stmt.setString(5, recipe.getCategory());
            stmt.setString(6, recipe.getImageUrl());
            stmt.setInt(7, recipe.getRecipeId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete a recipe by ID
    @Override
    public boolean deleteRecipe(int recipeId) {
        String sql = "DELETE FROM recipes WHERE recipe_id = ?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, recipeId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Extract Recipe Object from ResultSet
    private Recipe extractRecipeFromResultSet(ResultSet rs) throws SQLException {
        float avgRating = 0;
        try {
            avgRating = rs.getFloat("avg_rating");
            if (rs.wasNull()) {
                avgRating = 0;
            }
        } catch (SQLException e) {
            // Column might not exist in some queries
            avgRating = 0;
        }
        
        return new Recipe(
                rs.getInt("recipe_id"),
                rs.getString("title"),
                rs.getString("description"),
                rs.getString("ingredients"),
                rs.getString("cuisine"),
                rs.getString("category"),
                rs.getInt("user_id"),
                rs.getString("image_url"),
                avgRating,
                rs.getTimestamp("created_at")
        );
    }
    
    
    
    
    @Override
    public List<Recipe> searchRecipes(String query, String cuisine, String category, float minRating) {
        List<Recipe> recipes = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM recipes WHERE 1=1");

        if (query != null && !query.isEmpty()) {
            sql.append(" AND (title LIKE ? OR ingredients LIKE ?)");
        }
        if (cuisine != null && !cuisine.isEmpty()) {
            sql.append(" AND cuisine = ?");
        }
        if (category != null && !category.isEmpty()) {
            sql.append(" AND category = ?");
        }
        if (minRating > 0) {
            sql.append(" AND avg_rating >= ?");
        }

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (query != null && !query.isEmpty()) {
                stmt.setString(paramIndex++, "%" + query + "%");
                stmt.setString(paramIndex++, "%" + query + "%");
            }
            if (cuisine != null && !cuisine.isEmpty()) {
                stmt.setString(paramIndex++, cuisine);
            }
            if (category != null && !category.isEmpty()) {
                stmt.setString(paramIndex++, category);
            }
            if (minRating > 0) {
                stmt.setFloat(paramIndex++, minRating);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                recipes.add(extractRecipeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipes;
    }
    
    
    @Override
    public List<Review> getReviewsByRecipeId(int recipeId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.username FROM reviews r JOIN users u ON r.user_id = u.user_id WHERE r.recipe_id = ? ORDER BY r.created_at DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, recipeId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getInt("review_id"));
                review.setRecipeId(rs.getInt("recipe_id"));
                review.setUserId(rs.getInt("user_id"));
//                review.setUsername(rs.getString("username"));  // Fetching username of reviewer
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    @Override
    public boolean addReview(Review review) {
        String sql = "INSERT INTO reviews (recipe_id, user_id, rating, comment, created_at) VALUES (?, ?, ?, ?, NOW())";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, review.getRecipeId());
            stmt.setInt(2, review.getUserId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public float calculateAverageRating(int recipeId) {
        String sql = "SELECT AVG(rating) AS avg_rating FROM reviews WHERE recipe_id = ?";
        float avgRating = 0;

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, recipeId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                avgRating = rs.getFloat("avg_rating");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return avgRating;
    }
    
    
    
    @Override
    public List<Recipe> getFeaturedRecipes(int limit) {
        List<Recipe> recipes = new ArrayList<>();
        String sql = "SELECT r.*, IFNULL((SELECT AVG(rating) FROM reviews WHERE recipe_id = r.recipe_id), 0) as avg_rating " +
                     "FROM recipes r ORDER BY avg_rating DESC, created_at DESC LIMIT ?";
        
        System.out.println("Executing query: " + sql + " with limit: " + limit);
        
        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            int count = 0;
            while (rs.next()) {
                Recipe recipe = extractRecipeFromResultSet(rs);
                recipes.add(recipe);
                count++;
                System.out.println("Added recipe: " + recipe.getTitle() + " (ID: " + recipe.getRecipeId() + ")");
            }
            System.out.println("Total recipes found: " + count);
            
            // If no recipes found, try getting any recipes without sorting
            if (recipes.isEmpty()) {
                System.out.println("No recipes found with original query, trying fallback query");
                return getAllRecipes();
            }
        } catch (SQLException e) {
            System.err.println("Error executing getFeaturedRecipes query: " + e.getMessage());
            e.printStackTrace();
        }
        return recipes;
    }
}
