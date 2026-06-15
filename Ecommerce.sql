CREATE TABLE Customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50) NOT NULL,
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(50)
);

CREATE TABLE Products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,         -- Kept original typo from metadata
    product_description_lenght INT,  -- Kept original typo from metadata
    product_photos_qty INT,
    product_weight_g DECIMAL(10, 2),
    product_length_cm DECIMAL(10, 2),
    product_height_cm DECIMAL(10, 2),
    product_width_cm DECIMAL(10, 2)
);

CREATE TABLE Orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

SELECT
    c.customer_unique_id,
    c.customer_state,
    c.customer_city,

    o.order_id,
    o.order_purchase_timestamp,
    o.order_status,

    oi.product_id,
    oi.price,
    oi.freight_value,

    p.product_category_name

FROM orders o

JOIN Customers c
ON o.customer_id = c.customer_id

JOIN Order_Items oi
ON o.order_id = oi.order_id

JOIN Products p
ON oi.product_id = p.product_id;


-- How much money did the company generate?
SELECT 
	SUM(price) + SUM(freight_value) AS total_revenue 
FROM Order_Items;

-- How many orders were placed?
SELECT
	COUNT(*) AS total_orders
FROM Orders;

-- How many unique customers bought from us?
SELECT
	COUNT(DISTINCT customer_unique_id) AS total_customers
FROM Customers;

-- How much does an average order contribute?
SELECT 
	((SUM(price) + SUM(freight_value))/COUNT(DISTINCT order_id)) AS AOV
FROM Order_Items;

-- How valuable is each customer?
SELECT 
	(SUM(Oi.price) + SUM(Oi.freight_value))/COUNT(DISTINCT C.customer_unique_id ) AS revenue_per_customer 
FROM Order_Items AS Oi
INNER JOIN Orders AS O ON
Oi.order_id = O.order_id
INNER JOIN Customers C ON
O.customer_id = C.customer_id;

-- Trend Analysis

-- Is revenue growing over time? (monthly)

SELECT
	EXTRACT (YEAR FROM O.order_purchase_timestamp) AS years,
	EXTRACT (MONTH FROM O.order_purchase_timestamp) AS months,
	ROUND(SUM(Oi.price) + SUM(Oi.freight_value),2) AS monthly_revenue
FROM Orders O
INNER JOIN Order_Items Oi
ON O.order_id = Oi.order_id
GROUP BY years,months
ORDER BY years,months;

-- Is demand increasing over time? (monthly)

SELECT
	EXTRACT (YEAR FROM order_purchase_timestamp) AS years,
	EXTRACT (MONTH FROM order_purchase_timestamp) AS months,
	COUNT(DISTINCT order_id) AS total_orders
FROM Orders
GROUP BY years,months
ORDER BY years,months;

-- Are we acquiring more customers? (monthly)
SELECT
	EXTRACT (YEAR FROM O.order_purchase_timestamp) AS years,
	EXTRACT (MONTH FROM O.order_purchase_timestamp) AS months,
	COUNT(DISTINCT C.customer_unique_id ) AS customers 
FROM Orders O JOIN 
Customers C ON 
O.customer_id = C.customer_id
GROUP BY years,months
ORDER BY years,months;
	

-- Comparative Analysis

-- Which states contribute the most revenue? 

SELECT
	C.customer_state ,
	ROUND(SUM(Oi.price) + SUM(Oi.freight_value),2) AS revenue
FROM Customers C 
JOIN Orders O ON
C.customer_id = O.customer_id
JOIN Order_Items Oi ON
O.order_id = Oi.order_id
GROUP BY C.customer_state
ORDER BY revenue DESC
LIMIT 10;

-- Where do our customers come from?

SELECT
	customer_state,
	COUNT(DISTINCT customer_unique_id) AS total_count
FROM Customers
GROUP BY customer_state
ORDER BY total_count DESC 
LIMIT 10;

-- Which states generate demand?

SELECT
	C.customer_state,
	COUNT(DISTINCT O.order_id) AS total_orders
FROM Customers C JOIN 
Orders O ON C.customer_id = O.customer_id
GROUP BY customer_state
ORDER BY total_orders DESC
LIMIT 10;

-- Which product categories contribute the most money?

SELECT
	P.product_category_name,
	ROUND(SUM(Oi.price)+SUM(Oi.freight_value),2) AS revenue
FROM Order_Items Oi 
JOIN
Products P
ON Oi.product_id = P.product_id 
GROUP BY P.product_category_name
ORDER BY revenue DESC;

-- Which categories generate the highest demand? 

SELECT
	P.product_category_name,
	COUNT(DISTINCT Oi.order_id) AS total_orders
FROM Order_Items Oi 
JOIN
Products P
ON Oi.product_id = P.product_id 
GROUP BY P.product_category_name
ORDER BY total_orders DESC;

-- Which categories attract the most unique customers?

SELECT
	P.product_category_name,
	COUNT(DISTINCT C.customer_unique_id) AS total_customer
FROM Order_Items Oi 
JOIN
Products P
ON Oi.product_id = P.product_id 
JOIN
Orders O ON
Oi.order_id = O.order_id
JOIN
Customers C
ON O.customer_id = C.customer_id
GROUP BY P.product_category_name
ORDER BY total_customer DESC;

-- How much revenue does each order generate in a category?

SELECT
    p.product_category_name,

    ROUND(
        SUM(oi.price + oi.freight_value),2
    ) AS revenue,

    COUNT(DISTINCT o.order_id) AS orders,

    COUNT(DISTINCT c.customer_unique_id) AS customers,

    ROUND(
        SUM(oi.price + oi.freight_value)
        /
        COUNT(DISTINCT o.order_id),
        2
    ) AS revenue_per_order,

    ROUND(
        SUM(oi.price + oi.freight_value)
        /
        COUNT(DISTINCT c.customer_unique_id),
        2
    ) AS revenue_per_customer

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

JOIN order_items oi
ON o.order_id = oi.order_id

JOIN products p
ON oi.product_id = p.product_id

GROUP BY p.product_category_name

ORDER BY revenue DESC
LIMIT 10;

-- Revenue by Category

SELECT
	P.product_category_name,
	SUM(Oi.price)+SUM(Oi.freight_value) AS revenue
FROM Products P 
JOIN Order_Items AS Oi 
ON P.product_id = Oi.product_id
GROUP BY P.product_category_name
ORDER BY revenue DESC;

-- Over all comparasion 
WITH category_revenue AS
(
SELECT
    p.product_category_name,
    SUM(oi.price + oi.freight_value) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
),
category_contribution AS
(
SELECT
    product_category_name,
    revenue,
    ROUND(
    revenue*100.0/
    SUM(revenue) OVER(),
    2
    ) AS contribution_pct

FROM category_revenue
)
SELECT
    product_category_name,
    ROUND(revenue,2) AS revenue,
    contribution_pct,
    ROUND(
    SUM(contribution_pct)
    OVER(
    ORDER BY revenue DESC
    ),
    2
    ) AS cumulative_pct
FROM category_contribution
ORDER BY revenue DESC 
LIMIT 10;

-- Segmentation Analysis 
SELECT
    c.customer_state,
    ROUND(
        SUM(oi.price + oi.freight_value),
        2
    ) AS revenue,
    COUNT(DISTINCT c.customer_unique_id) AS customers,
    ROUND(
        SUM(oi.price + oi.freight_value)
        /
        COUNT(DISTINCT c.customer_unique_id),
        2
    ) AS revenue_per_customer
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY revenue_per_customer DESC;


SELECT
    c.customer_state,

    ROUND(
        SUM(oi.price + oi.freight_value),
        2
    ) AS revenue,

    COUNT(DISTINCT o.order_id) AS orders,

    ROUND(
        SUM(oi.price + oi.freight_value)
        /
        COUNT(DISTINCT o.order_id),
        2
    ) AS revenue_per_order

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

JOIN order_items oi
ON o.order_id = oi.order_id

GROUP BY c.customer_state

ORDER BY revenue_per_order DESC;

-- Correlation analysis 
--required tables 
CREATE TABLE Order_Payments (
    order_id VARCHAR(50),
    payment_sequential SMALLINT,       -- 2 bytes (sequential count of payments, e.g., 1, 2)
    payment_type VARCHAR(30),          -- e.g., 'credit_card', 'voucher'
    payment_installments SMALLINT,     -- 2 bytes (number of monthly installments)
    payment_value NUMERIC(10, 2),      -- ~5 bytes (exact decimal precision for money)
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Order_Reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score SMALLINT,             -- 2 bytes (scores are typically 1 to 5; SMALLINT saves space)
    review_comment_title VARCHAR(150), -- Variable length text for short titles
    review_comment_message TEXT,       -- TEXT type allows for long paragraphs without arbitrary limits
    review_creation_date TIMESTAMPTZ,  -- 8 bytes (proper date format)
    review_answer_timestamp TIMESTAMPTZ, -- 8 bytes (proper timestamp format)
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


-- Delivery Time vs Review Score
SELECT
	EXTRACT( DAY FROM O.order_delivered_customer_date-O.order_purchase_timestamp) AS duration_days,
	ROUND(AVG(R.review_score),2) AS avg_score
FROM
Orders O 
JOIN
Order_Reviews R
ON O.order_id = R.Order_id
WHERE O.order_delivered_customer_date IS NOT NULL
GROUP BY EXTRACT( DAY FROM O.order_delivered_customer_date-O.order_purchase_timestamp)
ORDER BY EXTRACT( DAY FROM O.order_delivered_customer_date-O.order_purchase_timestamp);
	
WITH delivery_data AS
(
SELECT
    o.order_id,
    EXTRACT(
        DAY FROM
        o.order_delivered_customer_date
        -
        o.order_purchase_timestamp
    ) AS delivery_days,
    r.review_score
FROM orders o
JOIN order_reviews r
ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
),bucketed_data AS
(
SELECT
    review_score,
    CASE
        WHEN delivery_days BETWEEN 1 AND 5
            THEN 'Fast'
        WHEN delivery_days BETWEEN 6 AND 10
            THEN 'Normal'
        WHEN delivery_days BETWEEN 11 AND 15
            THEN 'Slow'
        WHEN delivery_days BETWEEN 16 AND 20
            THEN 'Very Slow'
        ELSE 'Extremely Slow'
    END AS delivery_bucket
FROM delivery_data
)
SELECT
    delivery_bucket,
    COUNT(*) AS total_orders,
    ROUND(
        AVG(review_score),
        2
    ) AS avg_review_score
FROM bucketed_data
GROUP BY delivery_bucket;


WITH freight_data AS
(
SELECT
    oi.freight_value,
    r.review_score

FROM order_items oi

JOIN orders o
ON oi.order_id = o.order_id

JOIN order_reviews r
ON o.order_id = r.order_id
),
bucketed_data AS
(
SELECT
CASE
	WHEN freight_value BETWEEN 0 AND 10
	THEN 'Very Low'
	WHEN freight_value BETWEEN 11 AND 20
	THEN 'Low'	
	WHEN freight_value BETWEEN 21 AND 40
	THEN 'Medium'
	WHEN freight_value BETWEEN 41 AND 60
	THEN 'High'
	ELSE 'Very High'
END AS freight_bucket,
review_score
FROM freight_data
)
SELECT
freight_bucket,
COUNT(*) AS total_orders,
ROUND(
AVG(review_score),
2
) AS avg_review_score
FROM bucketed_data
GROUP BY freight_bucket;

SELECT
    p.product_category_name,

    COUNT(*) AS total_orders,

    ROUND(
        AVG(r.review_score),
        2
    ) AS avg_review_score
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
JOIN orders o
ON oi.order_id = o.order_id
JOIN order_reviews r
ON o.order_id = r.order_id
GROUP BY p.product_category_name
HAVING COUNT(*) > 100
ORDER BY avg_review_score DESC;

-- RFM Analysis

WITH reference_date AS (
SELECT 
	MAX(order_purchase_timestamp) AS max_date
FROM Orders
),
customer_rfm AS (
SELECT 
	C.customer_unique_id ,
	EXTRACT ( DAY FROM (SELECT max_date from reference_date) - MAX(O.order_purchase_timestamp)
) AS recency,

	COUNT(DISTINCT O.order_id) AS frequency ,
	ROUND(SUM(Oi.price)+SUM(Oi.freight_value),2) AS monetary 
FROM customers c

    JOIN orders o
    ON c.customer_id = o.customer_id

    JOIN order_items oi
    ON o.order_id = oi.order_id

    GROUP BY c.customer_unique_id
)
SELECT *
FROM customer_rfm
ORDER BY frequency DESC;

-- Frequency distribuation

WITH customer_rfm AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS frequency
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    frequency,
    COUNT(*) AS number_of_customers
FROM customer_rfm
GROUP BY frequency
ORDER BY frequency;

-- Customer Pareto Analysis
WITH customer_revenue AS (
SELECT
	C.customer_unique_id,
	SUM(Oi.price)+SUM(Oi.freight_value) AS revenue
FROM Customers C
JOIN 
Orders O 
ON C.customer_id = O.customer_id
JOIN 
Order_Items Oi
ON
O.order_id =Oi.order_id
GROUP BY C.customer_unique_id 
),
customer_contribution AS
(
SELECT
    customer_unique_id,
    revenue,

    revenue*100.0/
    SUM(revenue) OVER()
    AS contribution_pct

FROM customer_revenue
)
SELECT
	customer_unique_id,
	ROUND(revenue,2) AS revenue,
	ROUND(contribution_pct,4) AS contribution_pct,
	ROUND(
	SUM(contribution_pct)
		OVER(
		ORDER BY revenue DESC
		),2) AS cumulative_pct
FROM customer_contribution
ORDER BY revenue DESC;

-- Cohort analysis
WITH customer_cohort AS
(
SELECT
    c.customer_unique_id,
    DATE_TRUNC('month',MIN(o.order_purchase_timestamp))::DATE AS cohort_month

FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id

GROUP BY c.customer_unique_id
),

customer_orders AS
(
SELECT

    c.customer_unique_id,

    cc.cohort_month,

    DATE_TRUNC(
        'month',
        o.order_purchase_timestamp
    )::DATE AS purchase_month

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

JOIN customer_cohort cc
ON c.customer_unique_id=cc.customer_unique_id
)

SELECT

customer_unique_id,

cohort_month,

purchase_month,

(
    EXTRACT(YEAR FROM AGE(purchase_month,cohort_month))*12
    +
    EXTRACT(MONTH FROM AGE(purchase_month,cohort_month))
)::INT AS cohort_index

FROM customer_orders;



WITH customer_cohort AS
(
SELECT
    c.customer_unique_id,
    DATE_TRUNC(
        'month',
        MIN(o.order_purchase_timestamp)
    )::DATE AS cohort_month

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

GROUP BY c.customer_unique_id
),

customer_orders AS
(
SELECT

c.customer_unique_id,

cc.cohort_month,

DATE_TRUNC(
    'month',
    o.order_purchase_timestamp
)::DATE AS purchase_month

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

JOIN customer_cohort cc
ON c.customer_unique_id = cc.customer_unique_id
),

cohort_data AS
(
SELECT

customer_unique_id,

cohort_month,

(
EXTRACT(YEAR FROM AGE(purchase_month,cohort_month))*12
+
EXTRACT(MONTH FROM AGE(purchase_month,cohort_month))
)::INT AS cohort_index

FROM customer_orders
)

SELECT

cohort_month,

cohort_index,

COUNT(DISTINCT customer_unique_id)
AS active_customers

FROM cohort_data

GROUP BY
cohort_month,
cohort_index

ORDER BY
cohort_month,
cohort_index;