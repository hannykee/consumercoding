install.packages("readxl")
install.packages("foreign")
library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

setwd("c://data")
setwd("c:/data")
fact_data=read.csv("clust_data.csv",header=T)
#원하는 속성만 골라내기(filter)
fact_data
#단위표준화
scale(데이터이름)
#거리계산-거리 행렬 만들기
dis_data=dist(fact_data,method="euclidean")
#계층적 방법 중 방식 선택
hc_sl=hclust(dis_data,method="single")
hc_co=hclust(dis_data,method="complete")
hc_av=hclust(dis_data,method="average")
hc_wd=hclust(dis_data,method="ward.D")
#군집 확인하기 
par(mfrow=c(2,2))  #그래프를 4개 그릴 것이다 공간 미리 할당
plot(hc_sl,hang=-1)   #덴드로그램 그려주는 함수 hang은 
rect.hclust(hc_sl,k=3,border="red")
계층적 분석을 k가 3개의 군집(*내가설정)으로 나오는 빨갛게 네모로 만들어라. ( 군집 구분해주기)

plot(hc_av,hang=-1)
plot(hc_co,hang=-1)
rect.hclust(hc_co,k=3,border="red")

rect.hclust(hc_av,k=3,border="red")

plot(hc_wd,hang=-1)
rect.hclust(hc_wd,k=3,border="red")
#와드의 장점은 편차의 제곱이기 때문에 균형 잡힌 클러스터가 나옴

)()

<비계층적방법>)
#군집 분석은 흠 잡을데 없는 분석은 아니다. 

#시작 값을 고정시켜놓고 시작( 군집 분석에 정답은 없다. ) = kmeans를 돌리기 전에
set.seed(1234)
#군집분석 실시, k값 정해줌
nc_kmeans=kmeans(fact_data,3)
nc_kmeans
#결과해석

가]클러스터가 몇개로 나뉘어짐 3개로 6개 7개 7개

나]최종 군집중심값==> 각 그룹의 특성 파악 ******매우 중요
1클러스터 (가격을 제외하고 모두 크다. => 가격에 대한 민감도가 거의 없고 나머지를 중요하게 생각하는 그룹-고품질 속설 중시)
2클러스터 (영양가 저칼로리에 관심 없고, 맛.갈증해소.청량감.분위기가 중요한 그룹- 음료수 자체의 가치를 높게 평가)
3클러스터 (가격이 제일 중요한 그룹)

다] n의 클러스터 소속 정보
clustering vector 20명이 어떤 클러스터에 소속되어 있는지 알려줌

그 뒤는 해석할 필요가 없음
(제곱합 계산)
(availabe components 내가 확인할수도 있는 값 설명)
nc_kmeans$size #(각 클러스터 별 컴포넌트 수)
nc_kmeans$iter #(반복 ) 두 번 만에 수렴되었다.


#####################클러스터로 변수 추가만들기  => 인구통계학적 변수 확인하기
fact_data$cluster=nc_kmeans$cluster 
#이를 데이터로 만들어주기
write.csv(fact_data,"newcluster.csv")

#--------------------------------------------------------------------------------------------------------------
#------------------0417----------------------------------------------------------------------------------------
install.packages("cluster")
library(cluster)
clusplot(fact_data, nc_kmeans$cluster, color=TRUE, shade=TRUE, labels=2,lines=0)  #labels 2개 데이터 두개 다 써주겠다.
#7속성을 2차원으로 표현한 것이므로, 어떻게 묶였는지만 확인 가능!
11번은 어디에도 들어갈 수 있다.


#outlier의 존재 때문에 <  K-MEDIAN  > 사용
install.packages("Gmedian")
library(Gmedian)

set.seed(1234)
nc_kmedian=kGmedian(fact_data,3)
nc_kmedian
#클러스터 소속 1. 가격 중시, 2.음료 특성 중시, 3. 건강중시 그룹
#중심값(중심과 속한 개체 간 거리의 제곱합)
#나뉜 클러스터 별 개체개수

#시각화
clusplot(fact_data,nc_kmedian$cluster,color=TRUE, shade=TRUE, labels=2, lines=0)
