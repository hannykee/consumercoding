#0419 r
http://www.minsshop.com/product/detail.html?product_no=12324&cate_no=11&display_group=1
http://shehj.com/product/detail.html?product_no=48090&cate_no=1&display_group=3
http://www.minsshop.com/product/detail.html?product_no=12293&cate_no=11&display_group=1

#의사결정나무 개요
과거에 수집된 데이터들을 분석하여
이들 사이에 존재하는 패턴(범주별 특성)을
속성의 조합으로 나타내는 분류모형

목적: 분류/예측
범주형=분류나무(classification Tree)
연속형=회귀나무(Regression Tree)

Tree구조 (노드=(뿌라마디/부모마디/자식마디/끝마디), 가지, 깊이)
#맨 마지막 노드 결론 치우쳐짐,
각각의 마지막 노드는 동질적인 집단으로만 구성되려고 노력한다.
#끝마디 Terminal node의 수 = 분리된 부분집합 개수


의사결정나무 원리
1) 이산형 목표변수(지니지수,엔트로피지수)
-
-
-
2)(분산중심)
-
  
#통계 다중회귀할 때, 독립변수 간에 상관관계가 존재한다. 
  이런 문제를 상관분석 통해서, 미리 제거해줘야하는데
의사결정나무는 그럴 필요가 없다.


<예제 풀어보기>
setwd("c://data")
getwd()

install.packages("party")
library(party)

df= read.csv("owner.csv")
party=ctree(ownership~., data=df)
#.(모든변수)은 ownership을 제외한 모든 변수를 독립변수로 생각하겠다.
#+ 로 각각 변수를 모두 골라줌 ownership~ income+Lot size
plot(party)
#의사결정 나무가 ownership에 영향을 주는 변수가 income밖에 없다. 
수입이 75 이하이면 non소유주가 많음,
이상이면, 소유주가 많음
#lotsize는 영향력이 없었음.


#확률로 표시해주기
plot(party,type="simple")
  # 첫번쨰 확률은 non, owner (알파벳순표기)

#결과 한 눈에 보기
print(party)


#개발된 모델을 이용한 결과가 실제와 차이가 나는지 확인해봐야 한다.
testpred <- predict(의사결정결과, newdata=데이터이름)
table(예측결과, 실제결과)
#weights=빈도(개수)

testpred <- predict(party,newdata=df)
table(testpred,df$ownership) #두 개 비교(모델 결과 , 실제 결과)
#non을 non으로 예측한 것 : 좋은 예측,
non을 own으로 해석하면 잘못됨, 반대도 잘못됨
own을 own으로 예측하면 잘된 예측

의사결정나무는 결과가 행으로 나타나고
실제 값은 열로 나타난다.

#새로운 가입자가 들어왔을 때, 의사결정나무의 분석에 따라서 어느 쪽에 속할지 분류예측이 가능하다.
=> 영향을 주는 독립변수를 걸러내고, 어떤 조건으로 분류되는지까지 나옴(다중회귀는 안나옴)



데이터의 수가 많을 경우
train(훈련용)에서 나온 데이터규칙을 만들어서, test(시험용)에 적용하겠다는 취지
(*빅데이터에서는 전체를 돌리는 것이 더 의미 있을 수 있음) ==> 올해/내년 비교 처럼 새로운 데이터가 들어왔을 때 의미있지 않을까 (교수님의견)


str(readingSkills) #r 내장 함수 네이티브 스피커

install.packages("caret") #훈련용과 시험용만 나누는 패키지
library(caret)
set.seed(1234)
df=readingSkills

intrain <- createDataPartition(y=df$nativeSpeaker,p=0.7,list=F) #p=0.7은 7:3으로 나누라는 뜻
#리스트 형식이 아니다.   #인덱스 뽑혀나옴!!!!!!!!!!!!!!
intrain
 #200의 0.7 140개 나옴
train <- df[intrain,] # intrain은 훈련용 데이터에 넣기
train

test <- df[-intrain,]   #-표시는 intrain이 아닌 것 테스트 데이터에 넣기
test



###패키지 인스톨이 잘 안될 경우(외부 저장소 패키지 수동설치)
install.packages("원하는 패키지 이름", repos=c("http://rstudio.org/_packages","http://cran.rstudio.com"))

partymod <- ctree(nativeSpeaker~., data=train)
plot(partymod)
plot(partymod,type="simple")

testpred <- predict(partymod, newdata=test)
table(testpred,test$nativeSpeaker) #정확성 확인

YES/NO 이산형변수
이제
---------------------------------------------
<연속형변수> 숫자

str(airquality)


set.seed(1234)
df=airquality
intrain <- createDataPartition(y=df$Temp, p =0.7, list=F)#종속변수 y=temp
train <- df[intrain,]
test <- df[-intrain,] #행에 해당하는 것을 꼭 넣고, 열은 모두 해당하므로 쉼표 주의

partymod <- ctree(Temp~Ozone+Solar.R+Wind, data=train)
plot(partymod)

<박스플롯으로 드러남>
연속형 변수이므로 median으로 구분 가능 가장 온도가 낮은 그룹의 범위//

  중간에 속해있다. 오존이 얼마일 때 temp가 어느 정도일지 예측할 수 있다. 

testpred <- predict(partymod, newdata=test)
table(testpred,test$Temp)

