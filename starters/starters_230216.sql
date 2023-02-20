-- SQL 산술 연산자 : Python과 거의 동일
select 4 + 2  as plus;
select 4 - 2 as minus;
select 4 / 2 as division;
select 4 * 2 as multiple;
select 4 % 2 as 'mod';
select power(4,2) as 'power';

-- 비교 연산자 : true는 1, false는 0 return
select 4 = 2 as 'false'; 
select 4 < 2 as 'false';
select 4 >= 2 as 'true';
select 4 <> 2 as 'true';
select 4 != 2 as 'true';

-- 논리 연산자 : and / or / not
select (2 < 4) and (2 > 1) as 'true';
select (2 < 4) or (2 < 1) as 'true';
select not((2 < 4) and (2 < 1)) as 'true';

-- 문자열 다루기

-- -- 합치기
select concat('석지연', ' 010-4576-5351') as info;

use bookstore;
select group_concat(bookname)
from book;

-- -- 길이
select length('석지연') as 'byte';
select length('sarah') as 'byte';
select char_length('석지연') as 'len';

-- -- 공백 제거
select trim(' 안녕하세요 ') as 'both';
select ltrim(' 안녕하세요 ') as 'left';
select trim(leading ' ' from ' 안녕하세요 ') as 'left';
select rtrim(' 안녕하세요 ') as 'right';
select trim(trailing ' ' from ' 안녕하세요 ') as 'right';

-- -- 대소문자 변환함수
select upper('sarah') 'UPPER';
select lower('SARAH') 'lower';

-- -- 추출(슬라이싱)
select substr('석지연26세', 1, 3) as '이름';
select substring_index('석지연_26세', '_', 1) as '이름';
select substring_index('석지연_26세', '_', -1) as '나이';
select mid('석지연26세', 1, 3) as '이름';
select left('석지연26세', 3) as '이름';
select right('석지연26세', 3) as '나이';

-- 날짜 자료형 다루기

-- -- 일, 월, 연도 구하기
select day('2023-03-15');
select month('2023-03-15');
select year('2023-03-15');
select last_day('2023-03-15');

-- -- 현재 날짜, 시스템상 날짜 등 출력하기
select curdate() as 현재,
	   curtime() as 현재시간,
       now()	 as 지금,
       sysdate() as 시스템 ;
 
-- -- 날짜/시간 증감 함수
select '2023-03-15' as org,
	   date_add('2021-03-15', interval 999 day) as day1000,
       date_sub('2023-02-16', interval 703 day) as dday;
       
select now() as now,
	   addtime(now(), '0:30:0') as 'after0.5',
       subtime(now(), '0:30:0') as 'before0.5';
       
       
-- -- 날짜/시간의 차이, 몇 번째 월/요일/주인지

select datediff('2023-02-16', '2021-03-15') as dh,
	   timediff(now(), '2023-02-16 12:50:00') as lunch;
       
select curdate() as today,
	   dayofweek(curdate()) as 'dayofweek',
       monthname(curdate()) as 'month',
       dayofyear(curdate()) as 'dayofyear',
       time_to_sec('0:30') as seconds;
       
-- -- 기타
select makedate(2023, 315) as 'makedate',
	   maketime(7,30,39) as 'maketime',
       date_format('20210315', '%Y-%m-%d') as l;
       
-- 형변환 (unsigned : 부호 없는 실수, 절댓값)
select cast(123 as char) as 'tochar',
	   convert(123, char) as 'tochar';
       
/* <문자열 >>> 수치형>
	수치형 변수를 문자열 처리함수에 넣으면 수치형으로 암묵적 변환됨
    예외) 숫자로 문자열이 시작하는 경우 해당 숫자로 변환되어 수치 계산 가능
		 숫자로 시작하지 않는 경우는 0이 됨.*/
 
select 1 > '3mega' as 'false',
	   0 = 'mega3' as 'true',
       concat(3,'mega') as '3mega';
       
/* --------------------------서브 쿼리와 집계 함수--------------------------*/
use bookstore;
-- 집계함수 및 group by 예제
-- 총 결제금액 5만원 이상인 고객의 이름과 고객이 결제한 총 금액을 출력해라.
select c.custid as '고객ID',
	   c.username as 고객명,
	   sum(o.salesprice) as '총 결제금액'
from   customer c, orders o
where c.custid = o.custid
group by c.custid
having sum(o.salesprice) >= 50000 ;        

-- 고객이 주문한 도서의 총 판매액, 평균값, 최저가, 최고가를 구하시오.
select sum(salesprice) as '총 판매액',
	   round(avg(salesprice),0) as '평균가',
       min(salesprice) as '최저가',
       max(salesprice) as '최고가'
from orders;

-- 고객 이름, 주문한 도서, 도서의 판매가격을 출력하세요.
select c.username as 고객,
	   b.bookname as 제목,
       o.salesprice as 판매가
from   customer c, orders o, book b
where c.custid = o.custid and
	  b.bookid = o.bookid
order by c.custid asc, b.bookname asc;

--  책을 사지 않은 사람들과 함께 구입한 책, 고객, 가격을 출력하라.
select l.username, b.bookname, l.salesprice
from (select c.username, o.bookid, o.salesprice
from customer c left join orders o on c.custid = o.custid) l left join book b
	 on l.bookid = b.bookid
order by l.username, b.bookname, salesprice desc;