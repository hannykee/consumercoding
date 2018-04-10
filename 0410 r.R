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

#0410

job_both <- welfare %>% 
  filter(!is.na(code_job)) %>%
  group_by(job,gender) %>%
  summarise(n=n())
job_both

install.packages("reshape")
library(reshape)

###Cast가 훨씬 보기 편하다
피봇테이블
cast(data=job_both,job~gender,sum)
#                   행   열   빈도


class(welfare$religion)
table(welfare$religion)

welfare$religion <- ifelse(welfare$religion==1,"yes","no")
table(welfare$religion) #알파벳 순서로 정렬된다.

class(welfare$marriage)
table(welfare$marriage)
welfare$group_marriage<-ifelse(welfare$marriage== 1, "marriage", 
                               ifelse(welfare$marriage== 3, "divorce", NA))
table(welfare$group_marriage)
table(is.na(welfare$group_marriage))

종교에 따른 이혼율 분석 welfare에서
NA 아닌 것 group_by 묶기 다수 가수
n=n() 해당하는 각각의 도수를 써서 요약해라
파생변수 만들기 sum 더해서 새 변수 만들기 n/전체그롭 *100 , round1은 소수점 첫째자리까지 올려라

religion_marriage<-welfare %>% filter(!is.na(group_marriage)) %>% 
  group_by(religion, group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group= sum(n)) %>% 
  mutate(pct=round(n/tot_group*100,1))
religion_marriage


#summarise n= 두개를 더한 값만 더해줘야함(group_by religion을 기준*(맨 뒤에 부분이 기준으로 두개의 행이 더해져서 토탈 값이 정해짐)으로 더해진다.)

divorce <- religion_marriage %>%
  filter(group_marriage=="divorce") %>%
  select(religion,pct)
#divorce인 행렬만 뽑아서 종교가 있고 없고를 선택해서 볼 수 있음
divorce 


#연령대별 이혼율 분석
ageg_marriage<-welfare %>% filter(!is.na(group_marriage)) %>% 
  group_by(ageg, group_marriage) %>% 
  summarise(n=n()) %>% mutate(tot_group=sum(n)) %>% 
  mutate(pct=round(n/tot_group*100,1))
ageg_marriage

ageg_divorce<-ageg_marriage%>% filter(group_marriage== "divorce") %>% select(ageg, pct)
ageg_divorce

ggplot(data=ageg_divorce, aes(x=ageg, y=pct)) +geom_col() 

#col()은 한번 정제된 데이터!! bar는 정제안된

ageg_religion_marriage<-welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(ageg, religion, group_marriage) %>% 
  summarise(n=n()) %>% mutate(tot_group=sum(n)) %>% 
  mutate(pct=round(n/tot_group*100,1))
#맨 뒤에 그룹by로 토탈값이 정해짐
ageg_religion_marriage

#이혼율만 비교
divorce_rate<-ageg_religion_marriage%>% 
  filter(group_marriage== "divorce") %>% 
  select(ageg, religion, pct)
divorce_rate

ggplot(data=divorce_rate, aes(x=ageg,y=pct,fill=religion)) + 
  geom_col()

##############매우 중요!           코드북 반영하기#########
#지역별 연령대 비율
class(welfare$code_region)
table(welfare$code_region)
#spss는 숫자값만 아니까 
#변수에 대한 이름을 정해준다.
list_region<-data.frame(code_region=c(1:7), 
                        region=c("서울","수도권","경남","경북","충남","충북/강원","전라/제주"))

#####코드북에도 변수 지정을 해줬기 때문에 left_join을 할 때, 코드북에 대응시킬 수 있음 (*즉, 양쪽 파일에 동일한 이름이 존재해야 한다.)
welfare <-left_join(welfare, list_region, id="code_region")
region_ageg<-welfare %>% group_by(region, ageg) %>% summarise(n=n()) %>% mutate(tot_group= sum(n)) %>% mutate(pct=round(n/tot_group*100,2))
head(region_ageg)


ggplot(data=region_ageg, aes(x=region, y=pct, fill=ageg))+geom_col()+coord_flip()

#sorting하기 연령층별로 
list_order_old<-region_ageg%>% filter(ageg== "old") %>% arrange(pct)
list_order_old

list_order_middle<-region_ageg%>% filter(ageg== "middle") %>% arrange(pct)
list_order_middle
                        
                        
list_order_old<-region_ageg%>% filter(ageg== "old") %>% arrange(pct)
list_order_old

list_order_middle<-region_ageg%>% filter(ageg== "middle") %>% arrange(pct)
list_order_middle


#지금까지 궁금한 부분을 요약분석,정리까지
타겟을 정해서 하는 것은 하기 어려움
이 다음 군집분석부터 진짜 시작