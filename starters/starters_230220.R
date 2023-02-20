# ====== Working Directory ======

setwd('C:/code')# setting working directory
getwd() # Checking working directory

# ====== Data Type =======

## 벡터
balance = c(1787,4789,1350,1476,4189,3935)

## 리스트

balance = c(1787,4789,1350,'없음', 4189, '없음')

## 데이터 프레임임
rent <- cbind.data.frame(
  age = c(30, 33, 35, 30, 68, 33),
  job = c('무직', '서비스', '관리직', '관리직', '은퇴', '관리직'),
  marital = c('결혼','결혼','미혼', '결혼','사별', '결혼'),
  balance = c(1787,4789,1350,1476,4189,3935),
  campaign = c('휴대폰', '휴대폰', '휴대폰', 'Unknown', '유선전화', '휴대폰'),
  y = c(F, F, F, F, T, T)
)
print(rent)

## 배열
array_1 = array(data = rent)
print(array_1)

## 행렬
matrix_1 = matrix(data = runif(10), nrow = 2, ncol = 5)
print(matrix_1)

# ======== 자료형 =========
class(1.5) # 실수형
class(1L) # 정수형
class(1+5i) # 복소수형

class(TRUE) # 논리형
class(FALSE) # 논리형
class(T) # TRUE
class(F) # FALSE

sum(c(T,F)) # 1 + 0 = 1

0/0 # 구할 수 없는 수 : NaN
 
class(NaN) # numeric

class(NA) # logical

class(NULL) # null

## 변수 명명 규칙

ab.1 = 0 # 특수문자 2번째 이상의 글자에는 가능
ab1. = 0
)ab = 1 # 앞에 프로그래밍 시 쓰는 특수문자는 사용 불가
0ab = 9 # 앞에 숫자오면 안됨
1ab = 0 

## ====== <- 와 = 의 차이 ======
mean(x<-c(1,2,3))
print(x) # 전역 변수

mean(x=c(4,5,6))
print(x)  # 지역 변수