
# require(devtools)

rm(list=ls())

# install.packages("devtools")  # github 와 연동
# library(devtools)
# devtools::install_github("lchiffon/wordcloud2") # 최신 버전을 github에서 다운

install.packages("wordcloud2") # 이렇게만 설치할 경우 letterCloud 등 기능 작동안됨.
# github.com/ssbyun/data/wordcloud2_to library.zip 다운로드 후 
# R library/wordcloud2 폴더에 덮어쓰기

library(wordcloud2)

# 1 : wordcloud from library
wordcloud2(data = demoFreq)

demoFreq
head(demoFreq)

# 2 : change background color 
wordcloud2(demoFreq, color = "random-light", backgroundColor = "gray")
wordcloud2(demoFreq, minRotation = -pi/6, maxRotation = -pi/6, minSize = 10,
           rotateRatio = 1)

# 2-1 : shape : star
wordcloud2(demoFreq, size=0.7, shape="star")  # shape star
wordcloud2(demoFreq, size=0.7, shape="triangle")  
wordcloud2(demoFreq, size=0.7, shape="circle")  

# 3: Use Text

letterCloud(demoFreq, "R")
letterCloud(demoFreq, "RBSS", wordSize = 1)


# From R Library
fig = system.file("examples/t.png", package = "wordcloud2")     # included in R ex.
wordcloud2(demoFreq, figPath = fig, color = "skyblue", backgroundColor = "white") # pink


# 4: D drive에 저장된 그림 이용 / 이미지 파일에 단어가 들어갈 곳이 진한 색으로 되어 있어야 한다

fig2="D:/RScript/Figure/t.png"
wordcloud2(demoFreq, figPath = fig2, color = "skyblue", backgroundColor = "white")