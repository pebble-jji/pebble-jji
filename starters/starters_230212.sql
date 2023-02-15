create database bookstore;

use bookstore;

create table book(
	bookid integer primary key,
    bookname varchar(40),
    publisher varchar(40),
    price integer
);

create table customer(
	custid integer primary key,
    username varchar(20),
    address varchar(50),
    phone varchar(20)
);

create table orders(
	orderid integer primary key,
    custid integer,
    bookid integer,
    salesprice integer,
    orderdate date,
    foreign key (custid) references customer(custid),
    foreign key (bookid) references book(bookid)
) ;


INSERT INTO Book VALUES(1, '철학의 역사', '정론사', 7500);
INSERT INTO Book VALUES(2, '3D 모델링 시작하기', '한비사', 15000);
INSERT INTO Book VALUES(3, 'SQL 이해', '새미디어', 22000);
INSERT INTO Book VALUES(4, '텐서플로우 시작', '새미디어', 35000);
INSERT INTO Book VALUES(5, '인공지능 개론', '정론사', 8000);
INSERT INTO Book VALUES(6, '파이썬 고급', '정론사', 8000);
INSERT INTO Book VALUES(7, '객체지향 Java', '튜링사', 20000);
INSERT INTO Book VALUES(8, 'C++ 중급', '튜링사', 18000);
INSERT INTO Book VALUES(9, 'Secure 코딩', '정보사', 7500);
INSERT INTO Book VALUES(10, 'Machine learning 이해', '새미디어', 32000);

INSERT INTO Customer VALUES (1, '박지성', '영국 맨체스타', '010-1234-1010');
INSERT INTO Customer VALUES (2, '김연아', '대한민국 서울', '010-1223-3456');  
INSERT INTO Customer VALUES (3, '장미란', '대한민국 강원도', '010-4878-1901');
INSERT INTO Customer VALUES (4, '추신수', '대한민국 부산', '010-8000-8765');
INSERT INTO Customer VALUES (5, '박세리', '대한민국 대전',  NULL);

INSERT INTO Orders VALUES (1, 1, 1, 7500, STR_TO_DATE('2021-02-01','%Y-%m-%d')); 
INSERT INTO Orders VALUES (2, 1, 3, 44000, STR_TO_DATE('2021-02-03','%Y-%m-%d'));
INSERT INTO Orders VALUES (3, 2, 5, 8000, STR_TO_DATE('2021-02-03','%Y-%m-%d')); 
INSERT INTO Orders VALUES (4, 3, 6, 8000, STR_TO_DATE('2021-02-04','%Y-%m-%d')); 
INSERT INTO Orders VALUES (5, 4, 7, 20000, STR_TO_DATE('2021-02-05','%Y-%m-%d'));
INSERT INTO Orders VALUES (6, 1, 2, 15000, STR_TO_DATE('2021-02-07','%Y-%m-%d'));
INSERT INTO Orders VALUES (7, 4, 8, 18000, STR_TO_DATE( '2021-02-07','%Y-%m-%d'));
INSERT INTO Orders VALUES (8, 3, 10, 32000, STR_TO_DATE('2021-02-08','%Y-%m-%d')); 
INSERT INTO Orders VALUES (9, 2, 10, 32000, STR_TO_DATE('2021-02-09','%Y-%m-%d')); 
INSERT INTO Orders VALUES (10, 3, 8, 18000, STR_TO_DATE('2021-02-10','%Y-%m-%d'));

select *
from book
where price < 20000;

select *
from book
where price >= 10000 and price < 20000;

select *
from book
where price between 10000 and 20000;
-- between 이상 이하

select *
from book
where bookid in (2,3,4,7);

select username from customer
where username like '_지%';

select *
from book
where bookname like '%선%' and  price >= 20000;

