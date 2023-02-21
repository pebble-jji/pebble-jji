# ====== 연산자 및 산술함수 ======

## 산술 연산자

4 + 2 # 더하기 6
4 - 2 # 빼기 2
4 * 2 # 곱하기 8
4 / 2 # 나누기 2
4 ^ 2 # 2제곱 16
4 %% 2 # 나머지 0
4 %/% 2 # 몫 2

## 비교 연산자

4 > 2 # TRUE
4 >= 2 # TRUE
4 < 2 # FALSE
4 <= 2 # FALSE
4 == 2 # FALSE
4 != 2 # TRUE

## 논리 연산자

c(T,F) | c(F, T) # n번째 원소끼리 비교
c(T,F) & c(F, T) # n번째 원소끼리 비교 
c(T,F) || c(F, T) # 첫번째 값만 비교
c(T,F) && c(F, T) # 첫번째 값만 비교 

## 산술함수

a <- c(1,2,3,4,5)

max(a) # 최대
min(a) # 최소
sum(a) # 합
prod(a) # 전체 곱하기
factorial(a) # 팩토리얼값 반환
abs(a) # 절댓값
mean(a) # 평균
median(a) # 중위수
sd(a) # 표준편차
var(a) # 분산

# ====== 예제 ======
pln = cbind.data.frame(
  airline = c('아시아나항공', '에어부산', '에어프레미아', '에어서울', '제주항공', '진에어', '대한항공', '티웨이항공'),
  flight = c(1575, 481, 124, 354, 1197, 793, 1670, 859),
  passenger = c(249792, 90985, 29238, 71213, 203335, 133253, 250895, 146497),
  freight = c(3097.9, 516.7, 111.1, 273.1, 847.1, 763.2, 5406.1, 597.6)
)

## 운항/탑승객/화물 별 총 실적 구하기

sum(pln[,2]) # 총 편수
sum(pln[,3]) # 총 탑승객 수
sum(pln[,4]) # 총 톤 수

## 운항/탑승객/화물 별 평균 실적 구하기

mean(pln[,2]) # 평균 편수
mean(pln[,3]) # 평균 탑승객 수
mean(pln[,4]) # 평균 톤 수

## 평균 실적보다 높은 항공사 출력
pln[pln[, 2] > mean(pln[,2]),1]

# ===== 조건문 =====

a <- 1

if(a == 1){
  print(paste('a는 ', a, '입니다.'))
}

ifelse(a == T, print('TRUE'), print('FALSE'))

switch(b <- 'jy', 'jy' = 'hello', 'dh' = 'no!' )

a <- 1 : 10

## which는 인덱스 뽑아줌
a[which(a > 7)]


# ===== 반복문 ======
for(i in 1:10){
  print(rep('^', i))
}

i <- 1

while(i <= 10){
  print(rep('*',i))
  i = i + 1
}

# ====== 함수 ======

phi <- function(x){
    mul = 1
    for(i in x){
      mul = mul * i
    }
  return(mul)
}

phi(c(1,2,3,4))

# ===== 데이터 불러오기/내보내기 =====
## install.packages('csv')

library(csv)

df = read.csv('C:/code/data/titanic.csv', header = T)

pln = cbind.data.frame(
  airline = c('아시아나항공', '에어부산', '에어프레미아', '에어서울', '제주항공', '진에어', '대한항공', '티웨이항공'),
  flight = c(1575, 481, 124, 354, 1197, 793, 1670, 859),
  passenger = c(249792, 90985, 29238, 71213, 203335, 133253, 250895, 146497),
  freight = c(3097.9, 516.7, 111.1, 273.1, 847.1, 763.2, 5406.1, 597.6)
)

write.csv(pln,'C:/code/data/pln.csv')

df = read.csv('C:/code/data/pln.csv')
head(df)

# ===== 데이터 확인하기 =====

df <- read.csv('C:/code/data/covid19.csv', fileEncoding = 'euc-kr')

df[,1] = gsub('[.]', '-', df[,1])

df$접종일 <-  as.Date(df$접종일)

head(df)
plot(df[,1], df[,8], xlab = '일자', ylab = '접종률', col = 'blue', pch = 20, type = 'o', main = '접종률 추이', ylim = c(0,100))
par(new = T)
plot(df[,1], df[,5], xlab = '일자', ylab = '접종률', col = 'red', pch = 20, type = 'o', main = '접종률 추이', ylim = c(0,100))

# ====== dplyr ======
## install.packages('dplyr')

library(dplyr)

## 파이프 연산자 : A %>% B() -B 안에 A 넣겠다.

df = read.csv('C:/code/data/scores.csv')

select(df, kor, eng) # 특정 col 추출


filter(df, kor > 90) %>% select(name)


df[which(is.na(df$kor)), 2] = 0

df[which(is.na(df$eng)), 3] = 0

df[which(is.na(df$math)), 4] = 0

mutate(df, average = round((kor + eng + math)/3, 1))

# ====== 예제 ======
## install.packages('gapminder')

library(gapminder)
library(dplyr)


df = cbind.data.frame(
   country = pull(gapminder, country),
   continent = pull(gapminder, continent),
   year = pull(gapminder, year),
   lifeExp = pull(gapminder, lifeExp),
   pop = pull(gapminder, pop),
   gdpPercap = pull(gapminder, gdpPercap)
)

head(df)

# 대륙별 평균 GDP 구하기
cnt_df = df %>% group_by(continent) %>% summarise(avggdp = mean(gdpPercap))

cnt_df

# 아메리카 대륙 데이터 프레임 생성 및 길이 체크
amr = filter(df, continent == 'Americas')

dim(amr)[1]

# 인구가 3천만 이상인 아메리카의 나라들의 country별 행 개수

amr %>% filter(pop >= 30000000) %>% count(country, sort = T)

# Brazil, Mexico, US의 연도별 인구수 그래프에 나타내기

br = amr$country == 'Brazil'
mx = amr$country == 'Mexico'
us = amr$country == 'United States'


plot(amr[br,]$year, amr[br,]$pop, col = 'darkgreen', type = 'o', pch = 20, xlab = '연도', ylab = '인구', main = '연도별 인구',
     ylim = c(min(amr[br|mx|us,]$pop),max(amr[br|mx|us,]$pop)))
par(new = T)
plot(amr[mx,]$year, amr[mx,]$pop, col = 'darkred', type = 'o', pch = 20, xlab = '연도', ylab = '인구', main = '연도별 인구',
     ylim = c(min(amr[br|mx|us,]$pop),max(amr[br|mx|us,]$pop)))
par(new = T)
plot(amr[us,]$year, amr[us,]$pop, col = 'navy', type = 'o', pch = 20, xlab = '연도', ylab = '인구', main = '연도별 인구',
     ylim = c(min(amr[br|mx|us,]$pop),max(amr[br|mx|us,]$pop)))

legend('topleft',legend = c('Brazil', 'Mexico', 'United States'), cex = 0.5, fill = c('darkgreen', 'darkred','navy'))

