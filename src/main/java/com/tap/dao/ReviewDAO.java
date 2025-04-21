package com.tap.dao;

import com.tap.model.Review;
import java.util.List;

public interface ReviewDAO {
    boolean addReview(Review review);
    List<Review> getReviewsByRecipeId(int recipeId);
    float calculateAverageRating(int recipeId);
}
