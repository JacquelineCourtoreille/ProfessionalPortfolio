# Meal Suggester Web App

A full-stack meal suggestion and filtering application built using C#, Blazor, MudBlazor, and LINQPad-based SQL queries. The project demonstrates database design, normalization principles (1NF–3NF), and relational data modelling using a structured ERD.

---

## Project Overview

The Meal Suggester Web App helps users discover meals based on cuisine, ingredients, and dietary preferences. It includes both passive discovery (“Inspire Me”) and active filtering (“Find a Meal”) functionality.

The project was designed as a portfolio piece to demonstrate:
- Database design and normalization
- Entity-relationship modelling
- CRUD operations
- UI filtering logic
- Clean separation of data and presentation layers

---

## Tech Stack

- C#
- Blazor
- MudBlazor
- SQL Server
- LINQPad (for query testing)
- Entity Framework Core (planned/reverse engineered)

---

## Features

### Home Page
- Simple landing page
- Navigation to main features

### Inspire Me
- Displays 3–7 random meals
- Grouped or mixed by cuisine
- Shuffle functionality
- No filters (passive discovery)

### Find a Meal
- Filter meals by:
  - Cuisine
  - Ingredients
  - Dietary tags
- Search + selectable filter buttons
- Displays results as meal cards
- Clear filters + empty state handling

### Admin Functionality
- Create and edit meals
- Assign:
  - Cuisine
  - Ingredients
  - Dietary tags
  - Meal types
- Supports many-to-many relationships

---

## Database Design

The database was designed using normalization principles up to 3NF.

### Entities
- Meal
- Ingredient
- Cuisine
- DietaryTag
- WeeklyPlan
- MealType

### Join Tables (Many-to-Many Relationships)
- MealIngredients
- MealDietaryTag
- MealTypeAssignment

---

## Normalization Summary

### 1NF – Atomic Data
- Eliminated repeating groups
- Ensured single-value columns

### 2NF – Dependency Breakdown
- Separated core entities (Meals, Ingredients, Cuisine, etc.)
- Introduced foreign keys
- Began isolating relationships

### 3NF – Relationship Cleanup
- Removed remaining redundancy
- Introduced join tables for many-to-many relationships
- Finalized relational structure

---

## Entity Relationship Diagram (ERD)

The ERD displays the final normalized database structure and relationships between entities.

Please see the ERD pdf file, jpg file, or documentation file to view ERD.

---

## Purpose of Project

This project was built to strengthen understanding of:
- relational database design
- normalization theory
- full-stack application structure
- real-world data filtering systems

It serves as a portfolio project for software development roles/applications