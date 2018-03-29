#0329 r
iris

#sqldf는 데이터 프레임 형태만 다룰 수 있다.
install.packages("sqldf")
library(sqldf)

str(iris)

sqldf('select * from iris')
sqldf('select* from iris limit 5')

sqldf('select* from iris where species = "setosa"')
sqldf('select "Petal.Length" from iris where Species="setosa"')

sqldf('select sum("Petal.Length") from iris where species = "setosa"')
sqldf('select avg("Petal.Length") from iris where species = "setosa"')

install.packages("googleVis")
library(googleVis)

Fruits

<오름차순 정렬>
sqldf('select* from Fruits order by Year')
<내림차순 정렬>
  sqldf('select* from Fruits order by Year desc')

<그룹함수 사용하기>
sqldf('select sum(Sales) from Fruits')
sqldf('select max(sales) from Fruits')
sqldf('select min(sales) from Fruits')
sqldf('select avg(sales) from Fruits')

sqldf('select Fruit, avg(Sales) from Fruits group by Fruit')
sqldf('select Fruit, sum(sales) from Fruits group by Fruit')

<모든 데이터의 행수 출력하기- 큰 데이터의 길이 확인할 떄n>
sqldf('select count(*) from Fruits') #데이터의 행 수 출

<sub Query   where 뒤에 select라는 것이 또 하나 들어간 것  <,>,in>
#지출이 89인 판매 데이터를 추출하고 그 결과보다 큰 판매 결과를 갖는 데이터 추출

sqldf("select * from Fruits where Expenses='78'")
sqldf("select * from Fruits where Sales > (select sales from Fruits where Expenses=78)")
                                            #덩어리 채로 들어갈 수 있음
                                        #단 Sales끼리 비교하므로 select로 sales만 고름


sqldf('select Sales from Fruits where sales > 95')  #여기에 *만 select 해도 아래 명령어와 동일한 결과
sqldf('select * from Fruits where Sales in (select Sales from Fruits where sales>95)')
                                      #in 은 뒤에 subset(집합)이 있다.  판매가 95보다 큰 것을 선택하고 그 sales만 선택


var1=c('가','라','사')
var1= as.data.frame(var1)
sqldf('select * from var1')


ca=c('가','나','다','라','마','바','사')
lv = c(3,7,11,31,49,78,43)
id = c(3233,3789,4939,2665,4555,7888,9999)
data = data.frame(CA=ca,LV=lv,ID=id)
data


var1을 선택한 후 그 중에서 id선택
(가,라,사)
sqldf('select ID from data where CA in (select * from var1)')


-----------------여기까지 filter기능

데이터 변경하기  (c컴바인해라(얘랑,애를), 출력위치)

#원래의 기능+ 추가의 기능 컴바인
# sqldf(c('insert into   삽입하고자 하는 데이터 select ))


Time=c(1,2,3,4,5,7)
demand=c(8.3,10.3,19.0,16.0,15.6,19.8)
BOD=data.frame(Time=Time,demand=demand)


New = BOD[1,]
New

BOD1 = BOD[2:3, ]
BOD1

#rbind
sqldf(c('insert into New select * from BOD1','select * from New'))


Fruits

sqldf(c('update Fruits set Profit=80 where Fruit="Apples" and year=2008', 'select * from Fruits'))
#set 고정시켜라 update 80으로 바뀐 것을 다시 찍어라


sqldf(c('delete from Fruits where Fruit= "Apples" and year=2008','select * from Fruits'))





###########ggplot2 으로 그래프 긜기

install.packages("ggplot2")
library(ggplot2)

1단계: 배경설정(축)
2단계: 그래프 추가(점,선,막대)
3단계; 설정 추가 (축범위,색,표식)

##   data= x= y= 생략가능
1.ggplot(data= 데이터 이름)
2.aes(x=x축,y=y축)
3.geoms(geometric object)를 추가 점/선/막대 (*연산자 사용가능)
4.세부설정: 축범위 등 +연산자를 사용하여 xlim(축시작값,축마지막값,ylim(,), labs로 제목추가)

mpg


<산점도 - 숫자형 데이터>
#r 기본패키지 : plot(mpg$displ,mpg$hwy)
#               qplot(mpg$displ,mpg$hwy)
#차이점은 그래픽 플롯과 다른 그래프 유형을 결합할 수 있다. 
  
car_plot<- ggplot(mpg, aes(x=displ,y=hwy)) + geom_point()

<컬러 사용>
ggplot(mpg,aes(x=displ,y=hwy,col=class))+geom_point()
ggplot(mpg, aes(displ, hwy)) + geom_point(colour= "blue")


<클래스 별로 명확하게 구분하기>
##facet은 하위 집합에 대해서 ㄷ그래프를 분할하여 그려준다.
ggplot(mpg,aes(displ,hwy))+geom_point()+facet_wrap(~class)

<추세선 - 일차함수 회귀식 찾기>
ggplot(mpg,aes(displ,hwy)) + geom_point() + geom_smooth()

<추세식-lm으로 직선으로 추가하기>
ggplot(mpg,aes(displ,hwy)) + geom_point() + geom_smooth(method="lm")



<박스플롯- 요인Factor(명목형)데이터 >  #분산도 눈으로 확인 가능
#ggplot(mpg,aes(drv,hwy)) + geom_point()
ggplot(mpg,aes(drv,hwy)) + geom_boxplot()

ggplot(mpg,aes(hwy)) + geom_histogram()
              #x축만 설정해주면 빈도(count)는 자동으로 y축으로 해당된다.