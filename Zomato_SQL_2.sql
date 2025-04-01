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
 




 


