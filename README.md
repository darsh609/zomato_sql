# zomato_sql
# Zomato SQL Data Analysis Project

## Overview
This project analyzes customer behavior, purchasing patterns, and loyalty program effectiveness for a food delivery service similar to Zomato. The analysis uses SQL queries to extract valuable business insights from customer transaction data.

## Database Schema

The database consists of four tables:

### 1. `users`
Stores basic user information:
- `userid`: Unique identifier for each user
- `signup_date`: Date when the user registered

### 2. `goldusers_signup`
Tracks users who joined the premium loyalty program:
- `userid`: User identifier 
- `gold_signup_date`: Date when the user enrolled in the gold membership program

### 3. `sales`
Records all transactions:
- `userid`: User who made the purchase
- `created_date`: Date of the transaction
- `product_id`: Identifier of the purchased product

### 4. `product`
Contains product information:
- `product_id`: Unique identifier for each product
- `product_name`: Name of the product (p1, p2, p3)
- `price`: Cost of the product in rupees

## Analysis Highlights

The project includes several analytical queries that provide business insights:

1. **Total Customer Spending**
   - Calculates the total amount spent by each customer

2. **Customer Visit Frequency**
   - Counts the number of unique days each customer visited the platform

3. **First Product Purchase Analysis**
   - Identifies the first product purchased by each customer

4. **Most Popular Product**
   - Determines the most frequently purchased item and its purchase count by user

5. **Customer-specific Popular Items**
   - Identifies the most popular product for each individual customer

6. **Gold Membership Analysis**
   - Examines purchase behavior immediately after customers join the gold program
   - Analyzes purchase behavior just before customers join the gold program

7. **Pre-membership Purchase Analysis**
   - Calculates total orders and spending before customers became gold members

8. **Loyalty Points System Analysis**
   - Implements a complex points system where different products earn points at different rates
   - Calculates total points earned by each customer
   - Identifies which product generated the most points overall

9. **First-year Gold Membership Benefits**
   - Analyzes points earned during the first year of gold membership
   - Compares earnings between specific users (1 and 3)

10. **Transaction Ranking**
    - Ranks all customer transactions chronologically
    - Special ranking for gold member transactions with non-gold transactions marked as "na"

## Usage

1. Execute the setup queries to create and populate the database tables
2. Run the analytical queries individually to generate specific insights
3. Modify the queries as needed for custom analyses

## Key Insights Available

- Customer spending patterns
- Product popularity and preferences
- Impact of the gold membership program
- Effectiveness of the loyalty points system
- Customer engagement metrics

## Technical Notes

- The project uses common SQL features including:
  - JOIN operations (INNER JOIN, LEFT JOIN)
  - Window functions (RANK, PARTITION BY)
  - Aggregate functions (SUM, COUNT)
  - CASE statements for conditional logic
  - Subqueries and nested queries
  - Date operations

## Extensions and Future Work

Potential enhancements for this analysis could include:
- Customer segmentation analysis
- Cohort analysis based on signup date
- Product recommendation algorithms
- Churn prediction
- Seasonal trend analysis
- A/B testing for promotional strategies