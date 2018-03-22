#0320 r

#고객과 소비자 분석(정성적/정량적)

#파생변수 만들기
library(ggplot2)
head(mpg)
summary(mpg)
str(mpg)

#mpg의 통합연비 파생변수 만들기
mpg$total = (mpg$cty +mpg$hwy)/2
#attach(mpg) 는 지금부터 mpg를 계속 붙여놓아라. -> mpg$표시를 할 필요 없음.
attach(mpg)
total2 = cty + hwy
detach(mpg)

summary(mpg$total)
mean(mpg$total)
hist(mpg$total)

#조건문으로 파생변수 만들기
#ifelse문 ifelse(조건, 조건일 경우, 조건이 맞지 않을 경우)

mpg$test = ifelse(mpg$total >= 20, "pass", "fail")
head(mpg)

#ifelse 중첩문

mpg$grade = ifelse(mpg$total >=30, "A",
                   ifelse(mpg$total>=25,"B",
                          ifelse(mpg$total >=20,"C","D")))
head(mpg)
table(mpg$grade)


#데이터 가공에 많이 사용
#dplyr 패키지(a Grammear of Data Manipulation)

install.packages("dplyr")
library(dplyr)

#파이프 연산자 혹은 아래 문법으로 사용한다.
data %>% 함수(조건문)
함수(data,조건문)  


#행 추출
filter()

#열(변수)추출
select()

#정렬
arrange()

#변수 추가
mutate()

#통계치 산출 
summarise()

#집단별로 나누기
group_by()

#데이터 합치기(열)
left_join()

#데이터 합치기(행)
bind_rows()


#행추출
mpg %>% filter(manufacturer == "audi")  #추출해도 데이터 프레임 형태로 존재한다.
mpg %>% filter(manufacturer!= "audi")
mpg %>% filter(manufacturer=="audi"& cty >=20)
mpg %>% filter(cty>25 | hwy > 30) #연비가 좋은 것만 추출

#추출한 행으로 데이터 만들기
audi = mpg %>% filter(manufacturer =="audi")
chevrolet = mpg %>% filter(manufacturer == "chevrolet")
mean(audi$cty)
mean(chevrolet$hwy)




#열추출   --> 수많은 변수 중에 원하는 변수만 추출할 때
mpg %>% select(class)
mpg %>% select(manufacturer, model, cty, hwy, class)
mpg %>% select(-model)
mpg %>% select(-model, -trans)

#필요한 변수만 추출하기! filter와 select 조합하기
mpg %>% filter(manufacturer == "audi") %>% select(cty)


#추출한 데이터를 활용해 추가분석하기
suv = mpg %>% filter(class=="suv") %>% select(cty)
compact = mpg %>% filter(class=="compact")%>% select(cty)
mean(suv$cty)
mean(compact$cty)

#순서대로 정렬하기
mpg %>% arrange(cty)
mpg %>% arrange(desc(cty))


#두 개를 동시에 순서대로 정렬하기
mpg %>% arrange(cty,hwy)


mpg %>% filter(manufacturer == "audi") %>% arrange(desc(hwy))


#파생변수 추가하기 -- *여러 데이터 한꺼번에 추가할 수 있다.
mpg %>% mutate( ave = (cty+hwy)/2)
mpg %>% mutate(ave=(cty+hwy)/2) %>% arrange(ave) #ave 변수를 오름차순 정렬

#파생변수에서 조건문, 수식 모두 결합 가능하다
mpg %>% mutate(test1 = ifelse(cty >=20, "pass","fail"))


#집단별로 요약하기 (매우 중요)**
mpg %>% group_by(manufacturer)%>% summarise(mean_cty=mean(cty))
#제조사 별로 그룹을 나눠라, 나눈 그룹별로 mean_cty는 내가 지금 정의한 이름이고 새로운 변수로 추가된다.

mpg %>% group_by(manufacturer)%>% summarise(mean_cty=mean(cty)) %>% arrange(mean_cty)

#도수 만들기 : 클래스 별로 몇개가 나오는지 빈도 체크(행의 개수 세기) n= n()####################
#########중요


mpg %>% group_by(class) %>% summarize(mean_cty=mean(cty),mean_hwy=mean(hwy),n=n())
# 이를 변수로 저장하면 계속 사용 가능 앞에 변수이름 = 

mpg %>% group_by(class) %>% summarize(mean_cty=mean(cty),mean_hwy=mean(hwy),n=n()) %>% arrange(mean_cty,mean_hwy)


#집단별로 요약하기
#집단별로 2단계 집단을 구분하기 위해서는 group_by()에 여러 변수를 지정하면 된다.
mpg%>% group_by(manufacturer,model) %>% summarise(mean_cty=mean(cty))
  #인구통계학적 변수 성별/ 연령 동시에 볼 떄



mpg %>% 
  group_by(manufacturer)%>%
  filter(class=="suv")%>%
  mutate(ave = (cty+hwy)/2)%>%
  summarise(mean_ave = mean(ave))%>%
  arrange(desc(mean_ave))

#예시) 각 지역의 남자의 평균연령을 내림차순으로 정리




#가로로 합치기
left_join() #왼쪽 기준(없는 부분에 빈 공간-왼쪽이 기준으로 오른쪽 없는 것이 사라짐)
right_join() #오른쪽 기준(없는 부분에 빈 공간-오른쪽이 기준으로 왼쪽 없는 것이 사라짐)
inner_join() #두개 다 있어야만 (양쪽 모두 존재하는 경우에만 합쳐진다: 교집합)
full_join() #합집합 개념으로 한쪽만 존재해도 합쳐진다.


test1<- data.frame(id  = c(1,2,3,4,5),midterm = c(60,80,70,90,85))
test2<- data.frame(id = c(2,3,4,5,6), final = c(70,83,65,95,80))
total <- left_join(test1,test2, by="id")
total


install.packages(dplyr)
library(dplyr)
test1 <- data.frame(id=c(1,2,3,4,5), midterm=c(60,80,70,90,85))
test2 <- data.frame(id=c(2,3,4,5,6),final=c(70,83,65,95,80))
total <- left_join(test1,test2,by="id")
total

total <- right_join(test1,test2,by="id")
total

total <- inner_join(test1,test2,by="id")
total

total <-full_join(test1,test2,by="id")
total


#세로로 데이터 합치기 - 변수 명이 동일해야 함 (rename(바꿀이름=원래이름))
group_a <- data.frame(id=c(1,2,3,4,5), test=c(60,80,70,90,85))
group_b <- data.frame(id=c(6,7,8,9,10),test=c(70,83,65,95,80))

group_all <- bind_rows(group_a, group_b)
group_all


group_a <- data.frame(id=c(1,2,3,4,5), test=c(60,80,70,90,85))
group_b <- data.frame(id=c(6,7,8,9,10),temp=c(70,83,65,95,80))

group_all <- bind_rows(group_a, group_b)
group_all

group_b = rename(group_b,test=temp)#바꿀이름=원래이름
group_all <- bind_rows(group_a,group_b)
group_all




#정량데이터 => 정성적인 서비스디자인(프로토타입 구상까지)
#미디어 사용행태 조사 패널데이터

특정 주제에서 No라고 답한 계층(Filter)을 공략한다.=> Yes로 대답하도록
설문지
#결측치제거 na.rm=TRUE
