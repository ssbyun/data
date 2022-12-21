
rm(list=ls())
setwd("D:/RScript")


library(KoNLP)
library(wordcloud2)

text <-  readLines("./data/moon_r.txt", encoding="UTF-8")  # 문재인 대통령 연설문
# text <-  readLines('Yoon.txt', encoding="UTF-8") 
#text <-  readLines('Speech_Ban.txt', encoding="UTF-8")  # 반기문 유엔사무총장 수락연설, 한글이 잘 안 읽힐때 UTF-8

# noun <- extractNoun(text)
noun <- sapply(text, extractNoun, USE.NAMES=F) # 단어추출
noun

noun2 <- unlist(noun)       # 벡터형으로 만든다.
word <- table(noun2)   # 단어 출현 수 계산
word2 <- sort(word, decreasing=T)[1:50] # 단어 순서대로 50개만 정렬
word2 # 확인

word2 <- word2[-1] # 공백단어 제거

barplot(word2, las = 2, names.arg = names(word2),          # 단어 출현수 barplot   
        col ="lightblue", main ="Most frequent words",        
        ylab = "Word frequencies") 


wordcloud2(data=word2) # WordCloud

#==== 무의미/불필요 단어 제거후 Wordcloud 실행 =====#

noun2 <- noun2[nchar(noun2)>1] # 1글자짜리 삭제

#--- Confirm the word frequencies
count_noun2 <- table(noun2)
count_noun3 <- sort(count_noun2, decreasing=T)[1:30] # 단어 순서대로 30개만 정렬
barplot(count_noun3, las = 2, names.arg = names(count_noun3), # 그래프 출력    
        col ="lightblue", main ="Most frequent words", # 축, 제목 입력       
        ylab = "Word frequencies") # 축 입력

#--- 불필요 단어 삭제
noun2 <- gsub("국민","", noun2) # 국민 삭제
noun2 <- gsub("여러분","", noun2) # 여러분 삭제

word3 <- table(noun2) # 출현 단어 카운트
word3 <- sort(word3, decreasing=T)[1:50] # 단어 순서대로 50개만 정렬


wordcloud2(data=word3) # WordCloud


