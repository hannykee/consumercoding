#0405 r
install.packages("readxl")
install.packages("foreign")
library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

setwd("c://data")
welfare <- read.spss("Koweps_hpc10_2015_beta2.sav", to.data.frame=T) #실제 데이터만 설정하도록 T
str(welfare)

#데이터 이름 바꾸기 rename 함수는 앞이 바꿀 이름 = 뒤가 원래 이름
welfare <-rename(welfare, code_region=h10_reg7, gender=h10_g3, birth=h10_g4, marriage=h10_g10, religion=h10_g11,code_job=h10_eco9, income=p1002_8aq1)

#1단계 : 변수 검토 및 전처리
#2단계; 변수간 관계 분석


#변수 검토 및 전처리 단계
class(welfare$gender)
table(welfare$gender)#빈도는 남녀 명목
welfare$gender <- ifelse(welfare$gender==9,NA,welfare$gender) #무응답은9
                          #x이면, 이걸로바꾸고, 아니면이걸로한다.
table(is.na(welfare$gender))

welfare$gender <- ifelse(welfare$gender==1,"male","female")
table(welfare$gender)

getwd()

qplot(welfare$gender)


class(welfare$income)
summary(welfare$income) #실제 수이므로 기술통계 요약

qplot(welfare$income)
qplot(welfare$income) + xlim(0,1000) #계급 구간이 앞보다 줄어들었다.

summary(welfare$income)
welfare$income <- ifelse(welfare$income==0|welfare$income==9999,NA,welfare$income)
table(is.na(welfare$income)) #TRUE가 결측치

gender_income <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(gender)%>%
  summarise(mean_income=mean(income))
gender_income


ggplot(data=gender_income, aes(x=gender,y=mean_income))+geom_col()
#bar는 원재료를 히스토그램으로 보여줌, col은 ...? 뭐였지 변수를 설정??




#나이와 월급의 관계
class(welfare$birth)
summary(welfare$birth) # 가장 물어보기 좋은 사람이 생년월일(나이는 다 다름)
table(is.na(welfare$birth))




#주의할 점: 생년월일을 따라 올해 나이로 변환해주어야한다.
welfare$age <- 2018-welfare$birth + 1
summary(welfare$age)
qplot(welfare$age)

age_income <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(age) %>%
  summarise(mean_income=mean(income))
head(age_income)

#라인그래프로 그려보면
ggplot(data=age_income,aes(x=age,y=mean_income)) + geom_line()

welfare$agegroup= welfare$age %/%10 * 10  #나눈 몫만 반환 * 10 연령대
table(welfare$agegroup)

age_income <- welfare %>% filter(!is.na(income)) %>%
  group_by(agegroup) %>% summarise(mean_income=mean(income))

age_income
ggplot(data=age_income, aes(x=agegroup,y=mean_income)) + geom_col()

#나이대 초,중,노년
welfare <- welfare %>% mutate(ageg=ifelse(age<30,"young",
                                          ifelse(age<=59,"middle","old")))
#빈도계산
table(welfare$ageg)

#평균 구하기
ageg_income <- welfare %>% filter(!is.na(income)) %>%
  group_by(ageg) %>% summarise(mean_income=mean(income))
ageg_income

ggplot(data=age_income,aes(x=ageg,y=mean_income)) + geom_col()#기본은 알파벳순서정렬

#초,중,노년 순서로 구분 discrete limit를 이거 순서로 컴바인해라

ggplot(data=age_income,aes(x=ageg,y=mean_income)) + geom_col() +
  scale_x_discrete(limits=c("young","middle","old"))

#두개의 변수로 하나 그래프 그리기
gender_income<-welfare %>% filter(!is.na(income)) %>% 
  group_by(agegroup, gender) %>% summarise(mean_income= mean(income))
gender_income

fill 성별로 칠해라, agegroup별로

ggplot(data=gender_income, aes(x=agegroup,y=mean_income,fill=gender))+geom_col()

gender_income <- welfare %>% filter(!is.na(income)) %>%
  group_by(age,gender)%>%
  summarise(mean_income = mean(income)) 
gender_income

ggplot(data=gender_income,aes(x=age,y=mean_income,col=gender)) +
  geom_line(aes(group=gender))


#직업별 월급차이 =-> 코드북 매핑하기
class(welfare$code_job)
table(welfare$code_job)

list_job <- read_excel("Koweps_Codebook.xlsx",col_names=T,sheet=2)
list_job


#job변수를 welfare 데이터 프레임에 결합 (left_join: 공통으로 들어있는 변수 기준 합치기)_
#큰파일을 left join 함
welfare <- left_join(welfare,list_job,id="code_job")

welfare %>% filter(!is.na(code_job)) %>%
  select(code_job,job) %>%
  head(10)

job_income <- welfare %>% filter(!is.na(job) & !is.na(income)) %>%
  group_by(job) %>%
  summarise(mean_income=mean(income))
head(job_income)

top10 <-job_income%>% arrange(desc(mean_income)) %>% head(10)
top10

ggplot(data=top10, aes(x=reorder(job,mean_income),y=mean_income))+
  geom_col()+coord_flip()

bottom10 <-job_income%>% arrange(mean_income) %>% head(10)

ggplot(data=bottom10, aes(x=reorder(job,-mean_income),y=mean_income))+
  geom_col()+coord_flip()
