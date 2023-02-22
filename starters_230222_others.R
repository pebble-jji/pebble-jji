# ============= ggplot2 =============

## ========== 설치 + 로드 ===========

### install.packages('ggplot2')

library(ggplot2)

## ========== 7 layers ===========

### 1. data : 데이터 프레임 정의
### 2. aesthetics : 사용할 컬럼
### 3. geometry : 시각화 요소 정의
### 4. facets : 서브플랏 화면 분할
### 5. statistics : 통계적 시각화
### 6. coordinate : x축, y축
### 7. theme : 디자인적 요소

## ========= scatter plot =========

dia <- diamonds

ggplot(data = dia, aes(x = carat, y = price, col = cut)) + 
  geom_point(shape = 10) # 산점도 : geom_point()

## =========== line plot ==========

ggplot(dia[1:100, ], aes(x = carat, y = price)) +
  geom_line(arrow = arrow(), col = 'darkblue') # arrow() 지정으로 끝 모양을 화살표로 바꿈

## ========== bar plot ============

ggplot(data = dia, aes(y = color, fill = cut)) +
  geom_bar()

## ========== box plot ============

ggplot(data = dia, aes(x= cut, y = carat, fill = cut)) + 
  geom_boxplot() 


## ========== histogram ===========

ggplot(data = dia, aes(x = carat, fill = clarity)) +
  geom_histogram(binwidth = 0.1) + 
  scale_x_continuous(breaks = seq(0, 3.5, 0.5))

# =========== graphic ============

## 데이터 불러오기

library(csv)
library(dplyr)
library(ggplot2)
library(stringi)

df = read.csv('C:/code/data/too_hot.xls', fileEncoding = 'cp949', sep = '\t')

head(df)

## 데이터 전처리

### 특수문자 제거

for(i in 1:12){colnames(df)[i] <- stri_replace_all_charclass(colnames(df)[i], '[.]', '')}

for(i in 1:12){colnames(df)[i] <- stri_replace_all_charclass(colnames(df)[i], '[OX]', '')}

for(i in 1:12){colnames(df)[i] <- stri_replace_all_charclass(colnames(df)[i], '[C]', '')}

colnames(df)

### 영향예보 컬럼 결측치 -> 보통으로 변경

df[which(df$폭염영향예보단계 == ' '), ]$폭염영향예보단계 <- '보통'

head(df$폭염영향예보단계)

### 결측치 존재 행 지우기

df <- na.omit(df)

df <- df[, -c(6,7,9,11)]

head(df)

df <- df[, 4:8]

head(df)

## 최고기온을 x축, 최고체감온도를 y축인 그래프
## 자외선 지수에 따라 색이 다른 산점도 그리기
## 신뢰구간 99%의 회귀선 포함하기
## y축 범위 20~33으로 수정하기

ggplot(data = df, aes(x = 최고기온, y = 최고체감온도, col = 자외선지수단계)) +
  geom_point(alpha = 0.5) + 
  stat_smooth(level = 0.99) +
  coord_cartesian(xlim = c(17,35), ylim = c(20,33)) + 
  ggtitle('2021-09 최고기온 대비 최고체감온도') + 
  theme_bw()


## 자외선 지수에 따라 facet 나누기

ggplot(data = df, aes(x = 최고기온, y = 최고체감온도, col = 자외선지수단계)) +
  geom_point(alpha = 0.5) + 
  facet_wrap( ~ 자외선지수단계) +
  stat_smooth(level = 0.99, col = 'darkgrey', alpha = 0.5) +
  coord_cartesian(xlim = c(17,35), ylim = c(20,33)) + 
  ggtitle('2021-09 최고기온 대비 최고체감온도') + 
  theme_bw()


## 폭염영향예보 및 자외선 지수 컬럼에 따라 facet 나누기

ggplot(data = df, aes(x = 최고기온, y = 최고체감온도, col = 자외선지수단계)) +
  geom_point(alpha = 0.5) + 
  facet_wrap( 폭염영향예보단계 ~ 자외선지수단계, labeller = 'label_both') +
  coord_cartesian(xlim = c(17,35), ylim = c(20,33)) + 
  ggtitle('2021-09 최고기온 대비 최고체감온도') + 
  theme_bw()

# ======= 지도 시각화 ========

# install.packages(c('ggiraphExtra', 'maps', 'gridExtra'))

library(ggiraphExtra)
library(tibble)
library(ggplot2)
library(gridExtra)

us <- USArrests

rownames(us) <- tolower(rownames(us))

us$state <- rownames(us)

rownames(us) <- seq(1, length(rownames(us)))

gl_map <- map_data('state')

ggChoropleth(data = us, aes(fill = Murder, map_id = state),
             map = gl_map, interactive = T)

ggChoropleth(data = us, aes(fill = Assault, map_id = state),
             map = gl_map, interactive = T)

ggChoropleth(data = us, aes(fill = Rape, map_id = state),
             map = gl_map, interactive = T)


p1 <- ggplot(us, aes(x = UrbanPop, y = Murder)) +
  geom_point() +
  stat_smooth(level = 0.95)

p2 <- ggplot(us, aes(x = UrbanPop, y = Assault)) +
  geom_point() +
  stat_smooth(level = 0.95)

p3 <- ggplot(us, aes(x = UrbanPop, y = Rape)) +
  geom_point() +
  stat_smooth(level = 0.95)

grid.arrange(p1, p2, p3)

# ====== 시계열 데이터 =======

# install.packages(c('forecast', 'quantmod'))

library(forecast)
library(quantmod)
library(stringr)

data_pred = getSymbols('005930.KS',
                       from = '2021-01-01', to = '2021-09-01',
                       auto.assign = FALSE)
data_real = getSymbols('005930.KS',
                       from = '2021-01-01', to = '2021-10-30',
                       auto.assign = FALSE)

colnames(data_pred) <- str_replace_all(colnames(data_pred), '005930.KS.', '')

colnames(data_pred) <- tolower(colnames(data_pred))

data_pred <- as.data.frame(data_pred)

data_pred$date <- rownames(data_pred)

rownames(data_pred) <- seq(1,length(rownames(data_pred)))

data_pred$date <- as.Date(data_pred$date)



colnames(data_real) <- str_replace_all(colnames(data_real), '005930.KS.', '')

colnames(data_real) <- tolower(colnames(data_real))

data_real <- as.data.frame(data_real)

data_real$date <- rownames(data_real)

rownames(data_real) <- seq(1,length(rownames(data_real)))

data_real$date <- as.Date(data_real$date)


## 예측

pred_len <- length(data_real$open) - length(data_pred$open)

test <- forecast(object = data_pred$close, h = pred_len)

test <- as.data.frame(test)

data_real[,'pred_close'] <- c(data_pred$close, test$`Point Forecast`)

datebreaks <- seq(as.Date('2021-01-01'), as.Date('2021-10-01'), by = '1 month')

ggplot(data=data_real, aes(x=date)) +
  geom_line(aes(y=pred_close, col='red')) + # 예측선 먼져 빨간색으로 그린다
  geom_line(aes(y=close)) +
  scale_x_date(breaks=datebreaks) + #Theme layer. x축을 date값으로 나타냄
  theme(axis.text.x = element_text(angle=30, hjust=1)) # x축 값 텍스트를 30도 회전


# ======= 통계 =======

library(datasets)

df <- airquality

cor.test(df$Temp, df$Ozone, method = 'spearm')

cor.test(df$Temp, df$Ozone, method = 'kendall')

lm.fit <- lm(data = df, formula = Ozone ~ Solar.R + Wind + Temp)

t.test(lm.fit$fitted.values)

