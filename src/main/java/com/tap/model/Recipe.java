package com.tap.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Recipe implements Serializable {
	private static final long serialVersionUID = 2L;

	private int recipeId;
	private String title;
	private String description;
	private String ingredients;
	private String cuisine;
	private String category;
	private int userId;
	private String imageUrl;
	private float avgRating;
	private Timestamp createdAt;

	// Constructors
	public Recipe() {
	}

	public Recipe(int recipeId, String title, String description, String ingredients, String cuisine, String category,
			int userId, String imageUrl, float avgRating, Timestamp createdAt) {
		this.recipeId = recipeId;
		this.title = title;
		this.description = description;
		this.ingredients = ingredients;
		this.cuisine = cuisine;
		this.category = category;
		this.userId = userId;
		this.imageUrl = imageUrl;
		this.avgRating = avgRating;
		this.createdAt = createdAt;
	}

	// Getters and Setters
	public int getRecipeId() {
		return recipeId;
	}

	public void setRecipeId(int recipeId) {
		this.recipeId = recipeId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getIngredients() {
		return ingredients;
	}

	public void setIngredients(String ingredients) {
		this.ingredients = ingredients;
	}

	public String getCuisine() {
		return cuisine;
	}

	public void setCuisine(String cuisine) {
		this.cuisine = cuisine;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public float getAvgRating() {
		return avgRating;
	}

	public void setAvgRating(float avgRating) {
		this.avgRating = avgRating;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	// toString() for debugging
	@Override
	public String toString() {
		return "Recipe{" + "recipeId=" + recipeId + ", title='" + title + '\'' + ", category='" + category + '\''
				+ ", cuisine='" + cuisine + '\'' + ", avgRating=" + avgRating + ", userId=" + userId + '}';
	}
}
