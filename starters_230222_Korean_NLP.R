# ======== 텍스트 마이닝 ==========

library(KoNLP)
library(dplyr)
library(stringr)
library(tidyverse)
library(urltools)
library(httr)
library(rvest)
library(wordcloud)
library(RColorBrewer)

## 영화 평점 데이터

rat1 <- readLines('C:/code/data/ratings.txt', encoding = 'utf-8')

rat1 <- strsplit(rat1, split = '\t')

rat <- vector("character", length(rat1))

for(i in seq(1, length(rat1))){
  rat[i] <- rat1[i][[1]][2]
}

rm(rat1)

### 전처리

rat[44]

rat <- str_replace_all(rat, '[[:punct:]]', "") #44행 확인하면 ! 사라짐

rat[44]

rat[16]

rat <- str_replace_all(rat, '[%^]', "")

rat[16]

rat <- str_replace_all(rat, '[%^]{1}[ㄱ-ㅎ]{1}', "")

### 시각화

useNIADic()

rat <- rat[1:10000]

nouns <- extractNoun(rat) # 명사 추출

for(i in seq(1, length(nouns))){
  for(j in seq(1, length(nouns[[i]]))){
    nouns[[i]][j] <- str_replace_all(nouns[[i]][j], '[%^]','')
  }
}

head(nouns)

wordcount <- table(unlist(nouns))

wordcount <- as.data.frame(wordcount, stringsAsfactors = F)

head(wordcount)

wordcount <- rename(wordcount, word = Var1, freq = Freq)

wordcount$word <- as.character(wordcount$word)

wordcount <- filter(wordcount, nchar(word) > 2)

top_50 <- wordcount %>% arrange(desc(freq)) %>% head(50)

pal <- brewer.pal(15, 'Set3')

wordcloud(words = wordcount$word, #단어
          freq = round(sqrt(wordcount$freq)), #빈도 – sqrt 함수 사용하여 차이 줄임
          min.freq = 5, #최소 단어 빈도
          max.words = 200, #표현 단어 수
          random.order = F, #고빈도 단어 중앙 배치
          rot.per = .1, #회전 단어 비율
          scale = c(4, 0.5), #단어 크기 범위
          colors = pal) #색상 목록

## 국정원 트윗 데이터

twit <- read.csv('C:/code/data/NSC_1029-tweet_59383.csv', encoding = 'utf-8')

twit$내용 <- str_replace_all(twit$내용, '[[:punct:]]', " ") 

nouns <- extractNoun(unique(twit$내용)) # 명사 추출

wordcount <- table(unlist(nouns))

wordcount <- as.data.frame(wordcount, stringsAsfactors = F)

head(wordcount)

wordcount <- rename(wordcount, word = Var1, freq = Freq)

wordcount$word <- as.character(wordcount$word)

wordcount <- filter(wordcount, nchar(word) > 2)

top_50 <- wordcount %>% arrange(desc(freq)) %>% head(50)

pal <- brewer.pal(15, 'Set3')

wordcloud(words = wordcount$word, #단어
          freq = round(sqrt(wordcount$freq)), #빈도 – sqrt 함수 사용하여 차이 줄임
          min.freq = 5, #최소 단어 빈도
          max.words = 200, #표현 단어 수
          random.order = F, #고빈도 단어 중앙 배치
          rot.per = .1, #회전 단어 비율
          scale = c(4, 0.5), #단어 크기 범위
          colors = pal) #색상 목록

## 발라드 가사 데이터

clean <- function(ready, CSS) {
  result <- ready %>%
    html_node(css = CSS) %>%
    html_text() %>%
    str_replace_all(pattern = "[\t]|[\r]|[\n]", " ")
  return(result)
}

# https://www.melon.com/song/detail.htm?songId='숫자'
# 각 곡마다 id가 존재하기 때문에 id를 준비한다

id1 <- '31532643%2C31571110%2C31565593%2C31477685%2C31406357%2C31455159%2C31388145%2C30962526%2C31373277%2C31314144%2C31453551%2C31304766%2C31356458%2C31316695%2C31062863%2C31417922%2C30699142%2C31524320%2C31532642%2C31510409%2C31403156%2C30314784%2C31314142%2C30669593%2C31584299%2C31133898%2C30672529%2C31579864%2C31551385%2C31573334%2C30884950%2C30725482%2C31331745%2C31584295%2C30755375%2C31492322%2C31356451%2C31478848%2C31589633%2C30806536%2C31570737%2C31356799%2C30190630%2C30514366%2C31399731%2C30721801%2C31569905%2C31035061%2C30550603%2C30849733'
id2 <- '%2C31496140%2C31553909%2C9642570%2C31164090%2C8033528%2C31433959%2C31403263%2C30877002%2C30486509%2C31539246%2C31299371%2C30637776%2C4543502%2C31532644%2C30550388%2C30970444%2C31227367%2C30099927%2C31496488%2C8203900%2C31433089%2C30378164%2C31565592%2C30157753%2C30690674%2C30702937%2C315872%2C31539049%2C31594116%2C31541154%2C31554809%2C30011624%2C4369827%2C30276635%2C30536432%2C315876%2C30985406%2C31451245%2C31309947%2C31524346%2C30378157%2C31004503%2C30467550%2C9631530%2C31579835%2C31582380%2C31591124%2C31352818%2C31512458%2C31510177'
id  <- str_c(id1, id2)

# str_split() : pattern을 기준으로 분리 시켜주는 함수
# unique() : 중복된 값을 제거 시켜주는 함수
# unlist() : list 를 vector로 변환 시켜주는 함수

id <- id %>%
  str_split(pattern = '%2C') %>%
  unique() %>%
  unlist()

# num 벡터에 저장된 값을 for문을 통해서 sing이라는 데이터 프레임에 저장한다

ballad <- data.frame()

for(i in seq(1, length(id))) {
  res <- GET(url = 'https://www.melon.com/song/detail.htm',
             query = list(songId = id[i]))

  cat(i,'번째 현재 응답상태 코드는', status_code(res),'입니다\n')

  ready  <- res %>% read_html()

  title   <- clean(ready, 'div.song_name') %>% str_sub(3)
  artist <- clean(ready, 'div.artist')
  lyric  <- clean(ready, 'div.lyric')

  before <- data.frame(title, artist, lyric)
  ballad   <- rbind(ballad, before)
}

head(ballad)

write.csv(ballad, 'C:/code/data/ballad.csv', fileEncoding = 'utf-8')

nouns <- extractNoun(ballad$lyric)

n_list <- c()

for(i in seq(1, length(nouns))){
  n_list <- c(n_list, nouns[[i]])
}

wordcount <- table(n_list)

head(wordcount)

wordcount <- as.data.frame(wordcount, stringsAsfactors = F)

head(wordcount)

wordcount$n_list <- as.character(wordcount$n_list)

wordcount <- filter(wordcount, nchar(n_list) >= 2)

top_100 <- wordcount %>% arrange(desc(Freq)) %>% head(100)

pal <- brewer.pal(12, 'Paired')


wordcloud(words = wordcount$n_list, #단어
          freq = wordcount$Freq, #빈도 차이 줄임
          min.freq = 5, #최소 단어 빈도
          max.words = 200, #표현 단어 수
          random.order = F, #고빈도 단어 중앙 배치
          rot.per = .1, #회전 단어 비율
          scale = c(4, 0.5), #단어 크기 범위
          colors = pal) #색상 목록
