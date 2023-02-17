/* view 사용하기 */
use bookstore;

create or replace view v_weekly(w, mn, mx)
as select yearweek(orderdate) as w,
		  min(salesprice) as mn,
          max(salesprice) as mx
   from orders
   group by 1;
   
select * from v_weekly;

/* 통계 함수 */
-- 연도별 주문량, 주문 합계, 평균, 최대, 최소값을 출력하기

select day(orderdate) as 일,
	   count(orderid) as 주문량,
       sum(salesprice) as 총매출,
       round(avg(salesprice), 0) as 평균매출,
       min(salesprice) as 최소,
       max(salesprice) as 최대,
       round(variance(salesprice),0) as 분산,
       round(std(salesprice), 0) as 표준편차
from orders
group by 1;

-- 분위수 만들기 : 인덱스 자르기를 이용하여

select min(salesprice) as mn,
substring_index(substring_index(
	   group_concat(salesprice order by salesprice separator ','), ',', 0.25 * count(*) + 1), ',', -1)
					as q25,
substring_index(substring_index(
	   group_concat(salesprice order by salesprice separator ','), ',', 0.5 * count(*) + 1), ',', -1)
					as q50,
substring_index(substring_index(
	   group_concat(salesprice order by salesprice separator ','), ',', 0.75 * count(*) + 1), ',', -1)
					as q75,              
max(salesprice) as mx
from orders;                  
                    
-- 순위

select b.bookname,
	   rank() over (order by o.salesprice) as ranking
from book b, orders o
where b.bookid = o.bookid
group by b.bookid, o.salesprice;

select b.bookname,
	   dense_rank() over (order by o.salesprice) as ranking
from book b, orders o
where b.bookid = o.bookid
group by b.bookid, o.salesprice;

select b.bookname, 
	   o.custid,
       row_number() over (partition by o.custid order by o.salesprice) as ranking
from book b, orders o
where b.bookid = o.bookid
group by b.bookid, o.custid, o.salesprice; 

select b.bookname,
	   o.custid,
       row_number() over (partition by o.custid order by o.salesprice) as ranking
from book b, orders o
where b.bookid = o.bookid
group by o.custid, b.bookname, o.salesprice;

select substring(c.address, 1, 12) as 지역,
	   b.bookname,
       count(*) as 수량
from customer c, book b, orders o
where o.bookid = b.bookid and c.custid = o.custid
group by c.username,c.address, b.bookname
order by c.username asc, b.bookname desc;       

select substring(c.address, 1, 12) as 지역,
	   b.bookname,
       count(*) as 수량
from customer c, book b, orders o
where o.bookid = b.bookid and c.custid = o.custid
group by c.username,c.address, b.bookname with rollup
order by c.username asc, b.bookname desc;    

select substring(c.address, 1, 12) as 지역,
	   b.bookname,
       count(*) as 수량
from customer c, book b, orders o
where o.bookid = b.bookid and c.custid = o.custid
group by c.username,c.address, b.bookname with rollup
having c.address is not null and b.bookname is not null
order by c.username asc, b.bookname desc;    


/* sakila db */
use sakila;

select * from actor;

select * from film;

select * from staff;

select * from customer;

select * from inventory;

select * from rental;

select * from film_actor;

select  f.title,
		count(r.customer_id) as 대여횟수
from film f, customer c, rental r, inventory i
where f.film_id = i.film_id and i.inventory_id = r.inventory_id and c.customer_id = r.customer_id
group by f.title;

select concat(a.first_name,' ', a.last_name) as 배우,
	   rank() over (order by count(fa.film_id) desc) as 순위,
	   count(fa.film_id) as 출연작
from actor a, film_actor fa
where a.actor_id = fa.actor_id
group by a.first_name, a.last_name
limit 10 ;


/* 서울 따릉이 데이터 */
use seoul_data;

select * from bicycle_202012;

select * from bicycle_202101;

select 대여소명, 
		count(대여소명) as 대여건수
from bicycle_202012
group by 대여소명
order by 2 desc
limit 10;

select hour(반납일시) as 반납시간대,
	   count(대여소명) as 반납건수
from bicycle_202101
group by 1
order by 2 desc
limit 3;