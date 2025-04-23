DROP TABLE IF EXISTS goldusers_signup;
CREATE TABLE goldusers_signup(userid INTEGER, gold_signup_date DATE);

INSERT INTO goldusers_signup(userid, gold_signup_date) 
VALUES (1, '2017-09-22'),
       (3, '2017-04-21');

DROP TABLE IF EXISTS users;
CREATE TABLE users(userid INTEGER, signup_date DATE);

INSERT INTO users(userid, signup_date) 
VALUES (1, '2014-09-02'),
       (2, '2015-01-15'),
       (3, '2014-04-11');

DROP TABLE IF EXISTS sales;
CREATE TABLE sales(userid INTEGER, created_date DATE, product_id INTEGER);

INSERT INTO sales(userid, created_date, product_id) 
VALUES (1, '2017-04-19', 2),
       (3, '2019-12-18', 1),
       (2, '2020-07-20', 3),
       (1, '2019-10-23', 2),
       (1, '2018-03-19', 3),
       (3, '2016-12-20', 2),
       (1, '2016-11-09', 1),
       (1, '2016-05-20', 3),
       (2, '2017-09-24', 1),
       (1, '2017-03-11', 2),
       (1, '2016-03-11', 1),
       (3, '2016-11-10', 1),
       (3, '2017-12-07', 2),
       (3, '2016-12-15', 2),
       (2, '2017-11-08', 2),
       (2, '2018-09-10', 3);

DROP TABLE IF EXISTS product;
CREATE TABLE product(product_id INTEGER, product_name TEXT, price INTEGER);

INSERT INTO product(product_id, product_name, price) 
VALUES (1, 'p1', 980),
       (2, 'p2', 870),
       (3, 'p3', 330);

-- Select queries to display the data
SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM goldusers_signup;
SELECT * FROM users;

-- what is the total amount each customer spent on zomato
select a.userid,sum(b.price)
from sales a inner join
product b on a.product_id=b.product_id  
group by a.userid

-- How many days has each customer visited zomato
select userid,count(distinct created_date) distinct_days from sales group by userid

-- what was the first product purchased by each customer
select * from(
select * ,rank() over(partition by userid order by created_date) rnk from sales) a
where rnk=1;

-- WHAT IS THE MOST PUCHASED ITEM ON THE MENU AND HOW MANY TIMES IT WAS PURCHASED
select userid,count(userid) num from sales where product_id=(
select product_id from sales group by product_id order by count(product_id) desc limit 1) group by userid order by  num desc 


-- WHICH ITEM WAS THE MOST OPULAR FOR EACH CUSTOMER
select * from
(select * ,rank() over(partition by userid order by cnt 
desc) rnk from
(select userid,product_id,count(product_id) cnt from sales
group by userid,product_id) as b) as c
where rnk=1

-- which item was first purchased by customer after they became a member
select * from
(select * ,rank() over (partition by userid order by created_date)
rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date
from sales a join goldusers_signup b
on a.userid = b.userid and created_date >= gold_signup_date) c)
b
where rnk=1



-- which item was purchased before gold member
select * from
(select * ,rank() over (partition by userid order by created_date desc)
rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date
from sales a join goldusers_signup b
on a.userid = b.userid and created_date <= gold_signup_date) c)
b
where rnk=1
 
 
 
 -- what is the total order and amount spent for each member before 
 -- they became a member
 select userid,count(created_date) order_purchased,sum(price) total_amt_spent from
 (select c.*,d.price from
 (select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a
 inner join goldusers_signup b on a.userid=b.userid and created_date<=gold_signup_date) 
 c inner join product d on c.product_id=d.product_id) e
 group by userid




 -- If buying each product generates points for eg 5rs=2 zomato point and each product has different purchasing points
-- for eg for p1 5rs=1 zomato point , for p2 10rs=5zomato point and p3 5rs=1 zomato point 2rs=1zomato point

-- calculate points collected by each customer and for which product most points have been given till now.

select userid, sum(total_points)*2.5 total_money_earned from 
(
    select e.*, amt/points total_points from 
    (
        select d.*, case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from 
        (
            select c.userid, c.product_id, sum(price) amt from 
            (
                select a.*, b.price from sales a 
                inner join product b on a.product_id=b.product_id
            ) c 
            group by userid, product_id
        ) d 
    ) e 
) f 
group by userid;




select * from
(SELECT *, RANK() OVER (ORDER BY total_money_earned DESC) rnk 
FROM (
    SELECT product_id, SUM(total_points) AS total_money_earned 
    FROM (
        SELECT e.*, amt / points AS total_points 
        FROM (
            SELECT d.*, 
                   CASE 
                       WHEN product_id = 1 THEN 5 
                       WHEN product_id = 2 THEN 2 
                       WHEN product_id = 3 THEN 5 
                       ELSE 0 
                   END AS points 
            FROM (
                SELECT c.userid, c.product_id, SUM(price) AS amt 
                FROM (
                    SELECT a.*, b.price 
                    FROM sales a 
                    INNER JOIN product b ON a.product_id = b.product_id
                ) c 
                GROUP BY userid, product_id
            ) d 
        ) e 
    ) f 
    GROUP BY product_id
) final)g where rnk=1;



-- In the first one year after a customer joins the gold program (including their join date),
-- irrespective of what the customer has purchased, they earn 5 zomato points for every 10 rs spent.
-- Who earned more: 1 or 3, and what was their points earnings in their first year?

-- 1 zp = 2 rs
-- 0.5 zp = 1 rs

SELECT c.*, d.price * 0.5 AS total_points_earned  
FROM (
    SELECT a.userid, a.created_date, a.product_id, b.gold_signup_date  
    FROM sales a  
    INNER JOIN goldusers_signup b  
        ON a.userid = b.userid  
       AND a.created_date >= b.gold_signup_date  
       AND a.created_date <= DATE_ADD(b.gold_signup_date, INTERVAL 1 YEAR)
) AS c  
INNER JOIN product d  
    ON c.product_id = d.product_id;

-- rank all the transaction of the customer
select * , rank() over(partition by userid order by created_date) rnk from sales

-- rank all the transactions for each member whenever they are a zomato gold member for every 
-- non gold member for every non gold member transaction mark as na 

SELECT e.*,  
       CASE WHEN rnk = 0 THEN 'na' ELSE rnk END AS rnkk  
FROM (
    SELECT c.*,  
           CAST(
               CASE  
                   WHEN gold_signup_date IS NULL THEN 0  
                   ELSE RANK() OVER (PARTITION BY userid ORDER BY created_date DESC)  
               END AS CHAR(5)  -- or use VARCHAR(10) if needed
           ) AS rnk  
    FROM (
        SELECT a.userid, a.created_date, a.product_id, b.gold_signup_date  
        FROM sales a  
        LEFT JOIN goldusers_signup b  
            ON a.userid = b.userid  
           AND a.created_date > b.gold_signup_date
    ) c
) e;


