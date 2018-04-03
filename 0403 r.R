#0403
정량적 데이터 분석을 통한 + 서비스 디자인
#타겟 설정                   #페르소나 맞춤서비스(바틀넷개선)

(목표 고객 특성을 알아내기)
서비스 안한 대상 -> 사용하도록(군집분석->특성->타겟고객만들기)

부산 파라다이스 호텔 (비즈니스 차원)

염리동 프로젝트=> 소금길 (공공서비스)


library(ggplot2)

#히스토그램 : x축 넣으면 빈도로 y축
ggplot(mpg,aes(hwy,fill=drv))+geom_histogram()

#전륜구동이 연비 높고, 후륜구동이 연비 낮음

#BAR Chart
geom_bar 원재료로 사용(x축만 지정) 
#히스토그램과 유사하나 구분선 존재
geom_col 데이터를 요약한 후 값이 따라서 사용

ggplot(mpg,aes(hwy)) +geom_bar()
ggplot(mpg,aes(manufacturer))+geom_bar()

#그래프 직각 회전 !!!-> x축 qustnrk rlf Eo
ggplot(mpg,aes(manufacturer))+geom_bar()+coord_flip()


library(dplyr)
df_mpg<- mpg%>% 
  group_by(drv)%>% 
  summarise(mean_hwy=mean(hwy))

ggplot(df_mpg,aes(x=drv,y=mean_hwy)) + geom_col()

#크기 순 정렬
ggplot(df_mpg,aes(x=reorder(drv,mean_hwy),y=mean_hwy))+geom_col()
##############정렬 방식 주의!! -mean_hwy내림차순은


#구동방식별 고속도로의 연비의 표준편차로 bar chart 만들기
sd_mpg <- mpg %>%
  group_by(drv)%>%
  summarise(std_hwy=sd(hwy))

ggplot(sd_mpg, aes(x=drv,y=std_hwy))+geom_col()


#라인그래프 => 추세, 시간 (변화상 관측)
economics

ggplot(economics,aes(x=date,y=pce))+geom_line()
ggplot(economics,aes(x=date,y=unemploy))+geom_line()


#모듈 기능을 활용한 라인 그래프비교#
ggplot(economics, aes(x=date))+
  geom_line(aes(y=psavert,col="psavert"))+
  geom_line(aes(y=uempmed,col="uempmed")) +
  ylab("rate") #y축의 이름을 따로 설정해준다.
#y축을 다수로 입력함. + a 가능

#축제목 붙이기 
ggplot(economics, aes(x=date,y=pce)) +
  geom_line() +
labs(title="PCE bydate",
     caption="Source:economics", 
     x="date",
     y="personal consumption expenditures")

#그래프 자율 조작

class(mpg$class)
table(mpg$class) #각 클래스 별 도수
gd <- mpg %>%
  group_by(class) %>%
  summarise(hp=mean(hwy))
ggplot(data=gd, aes(x=class,y=hp))+geom_col()

ggplot(data=mpg,aes(x=class,y=hwy))+geom_point()

#자동차 종류에 따른 고속도로 연비 산점도와 평균 고속도로 연비 결합 그리기
ggplot(data=mpg,aes(x=class,y=hwy))+geom_point()+
  geom_col(data=gd,aes(x=class,y=hp),alpha=0.5)
  #모듈 형태이므로 새 그래프를 col(요약그래프함수) 안에 넣어서 그려줄 수 있다. 
  #alpha값은 음영 조절 (낮을 수록 연한)
#여기에서 사각 박스는 평균 (요약된 자료 복합적 표현)


#각 점들의 정보를 알고 싶을 때
ggplot(data=mpg,aes(x=class,y=hwy))+
  geom_point(col="red")+
  geom_col(data=gd,aes(x=class,y=hp),alpha=0.5)+
  geom_text(aes(x=class,y=hwy,label=manufacturer))

install.packages("readxl")
install.packages("foreign")
library(foreign)

setwd("c://data")
welfare <- read.spss("Koweps_hpc10_2015_beta2.sav", to.data.frame=T) #실제 데이터만 설정하도록 T
str(welfare)


