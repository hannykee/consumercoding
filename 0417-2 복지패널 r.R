#0417 r 한국복지패널
install.packages("foreign")
library(foreign)
welfare <- read.spss("Koweps_hpc10_2015_beta2.sav", to.data.frame=T)
str(welfare)

#1> 내가 분석할 속성 뽑기 -> 자산

#2> 정제 (999999로 오류 입력값 지워주기)
max(welfare$h1010_aq1)
welfare$h1010_aq1 <-ifelse(welfare$h1010_aq1 == 9999999, 0,welfare$h1010_aq1)
welfare$h1010_aq3 <-ifelse(welfare$h1010_aq3 == 9999999, 0,welfare$h1010_aq3)
welfare$h1010_aq5 <-ifelse(welfare$h1010_aq5 == 9999999, 0,welfare$h1010_aq5)
welfare$h1010_aq6 <-ifelse(welfare$h1010_aq6 == 9999999, 0,welfare$h1010_aq6)

#3> 10개의 변수만 추출하여 새로운 데이터를 생성하기
library(dplyr)
mywelfare <- welfare%>%
  select(h1010_aq1,h1010_aq2,h1010_aq3,h1010_aq4,h1010_aq5,h1010_aq6,h1010_aq7,h1010_aq8,h1010_aq9,h1010_aq10)
mywelfare

#동일한 방법 mywelfare <- welfare[,c("나열","나열")]

#4> 군집분석 수행
set.seed(1234)
wel_kmeans=kmeans(mywelfare,3)
wel_kmeans

#5> 해석
군집1: 대부분의 자산이 적은 그룹
군집2: 토지의 자산 규모가 큰 그룹
군집3: 주택과 건물 자산 규모가 크며 대부분의 자산이 가장 많은 그룹
(프로젝트에서 군집을 하나 선택해서 서비스 모델 제공)

#6> 클러스터변수 생성
welfare$cluster = wel_kmeans$cluster
welfare

#7> 본격적인 인구통계학 변수 따른 분석
#welfare 라는 변수에 넣은 이유(mywelfare는 군집을 분류하기 위한 속성만 뺀 것이니까) 실제 분석에 활용하기 위함(인구통계학적 자료)
write.csv(welfare,"newexample1.csv")

mywelfare <- read.csv("newexample1.csv")
#관심변수의 rename 
mywelfare<-rename(mywelfare, code_region=h10_reg7, gender=h10_g3, birth=h10_g4, 
                  marriage=h10_g10, religion=h10_g11, code_job=h10_eco9, income=p1002_8aq1)
#cluster 3만 추출(자산이 많은 군집을 타겟으로) -> rename한 열 추출(인구통계학적변수)
mydata= mywelfare%>% filter(cluster==3) %>%
  select(code_region,gender, birth,marriage,religion,code_job,income)
head(mydata)

#코드잡 leftjoin
library(readxl)
list_job<-read_excel("Koweps_Codebook.xlsx",col_names=T, sheet=2) 
mydata<-left_join(mydata, list_job, id="code_job")

#결측치 제거(축소)
mydata= mydata %>% filter(!is.na(code_job) & !is.na(income))

#빈도수 확인 (구체적인 타겟 정할 때)
table(mydata$code_region) #빈도(인원)가 많은 그룹이 서비스 파급력 큼
table(mydata$gender) #남성
table(mydata$marriage) #배우자가 있는


mydata$agegroup = (2018-mydata$birth+1) %/% 10 * 10
table(mydata$agegroup) #40대 고객

#최종 타겟: 서울수도권 배우자가 있는 40대 남성 고객
#추출하기
target = mydata %>%
  filter((code_region==1)&(gender==1)&(marriage==1)&(agegroup==40))
target
