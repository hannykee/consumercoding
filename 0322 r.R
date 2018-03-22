데이터 정제

df <- data.frame(gender=c("M","F",NA,"M","F"), score=c(5,4,3,4,NA))
df

#결측치 찾고 제거하기
#결측치 확인하기

table(is.na(df))
is.na(df)

df_nomiss <- df %>% filter(!is.na(gender) & !is.na(score))
df_nomiss


#이상치 찾고 제거하기

outlier <- data.frame(gender=c(1,2,1,3,2,1), score=c(5,4,3,4,2,6))
outlier

table(outlier$gender)
table(outlier$score)

outlier$gender <- ifelse(outlier$gender==3,NA,outlier$gender)
outlier$score <- ifelse(outlier$score ==6,NA,outlier$score)
outlier

#찾았고 NA로 바꿔서 이러한 이상치들을 제거하기
outlier%>% filter(!is.na(gender) & !is.na(score))





#구글비즈
install.packages('googleVis')
library(googleVis)
Fruits


#주어진 함수대로 데이터 요약정리 하기 -> 피봇(pivot)테이블 만드는데 유용하다.
#aggregate(계산될 열 ~ 기준열, 데이터, 함수) 
#복수 조건은 +로 표시
aggregate(Sales~Fruit,Fruits,sum)
aggregate(Sales~Date,Fruits,sum)
aggregate(Sales~Fruit,Fruits,max)
aggregate(Sales~Fruit+Year,Fruits,max)



#생필품 가격 데이터 
setwd("C:/data")
req=read.csv("requisites.csv")
nrow(req)
summary(req)

aggregate(A_PRICE ~ M_TYPE_NAME + A_NAME,req,mean)






#reshape 패키지
install.packages("reshape")
library(reshape)
melt 분해 DB구조     
cast 데이터 재결합
  # melt의 output이 cast로 들어간다.





#데이터 가공에서 가장 많이 사용되는 것 dplyr패키지  reshape 패키지

airquality #내장데이터

apm=melt(airquality,id=c("Month","Day"),na.rm=T) #기준별로 다 부숴서 값을 쭉 나열
apm
a=cast(apm,Day ~ Month ~ variable)  #data, 행~ 열~ 해당하는값
a

b=cast(apm,Month ~ variable,mean) #데이터, 행~ 값, 평균값을 표시한!!!!!!!
b
#cast는 피봇테이블을 만드는 것이며, input으로는 melt의 output을 받는다.

#margin옵션으로 행과 열에 대한 소계를 산출하는 기능(ex.평균도 구해짐)
c= cast(apm,Month~variable,mean,margins=c("grand_row","grand_col"))
c

#range로 최대값,최소값 산출
d= cast(apm,Month~variable,range)
d

#두개의 행과 한개의 열 조합에 대한 피봇테이블
e= cast(apm,Month+Day~variable)
e
