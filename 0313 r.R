#03-13 R 복습
as.factor() #요인형으로 변환.. 범주형데이터
gender=c("M","F","M","M","F")
gender

fgender = as.factor(gender)
fgender  #levels는 카테고리로 나뉜 것
plot(fgender)
str(fgender)

#데이터프레임 생성
no=c(1,2,3)
name=c("hong","lee","kim")
pay=c(150,250,300)

df_vemp=data.frame(NO=no,Name=name,Pay=pay)
df_vemp

Height = c(168,173,160,145,180)
Weight = c(80,65,92,53,76)
gender=c("M","F","F","M","M")

mydata=data.frame(height=Height, weight=Weight, gender=gender)
mydata

mydata[3,]
mydata[,3]
mydata$height


#파생변수 만들기
mydata$BMI = mydata$weight / (mydata$height/100)^2
mydata

summary(mydata)
plot(mydata)



#함수
sum(c(1:10))

seq(0,1,by=0.001) # 폭을 지정했다.
seq(0,1,length.out=100)   #알아서 랜덤으로 100개 설정

rep(c(1,2,3),times=2)
rep(c(1,2,3),each=2)


#데이터프레임
name <- c("철수","영희","길동")
age <- c(21,20,31)
gender <- factor(c("M","F","M"))
character <- data.frame(name,age,gender)

#조건 탐색(데이터 프레임에서)

character[character$gender == "F",] #gender인 녀석들의 행을 모두 가져와라 
character[character$age<30,]
character[character$age<30 & character$gender =="F",]
# & and | or(백스페이스 쉬프트)


#조건문2
x <- c(1,2,3)
x <- factor(x)

if(is.factor(x)){
  length(x)
} else {
  sum(x)
}
y <- c(1,2,3)
z <- c(0.4,0.7,0.9)

#if else가 두 단계인 조건문
if(is.factor(x)) {
  paste(x,"element")
} else if(is.numeric(x)){
  sum(x)
} else {
  length(x)
}



if(is.factor(y)) {
  paste(y,"element")
} else if(is.numeric(y)){
  sum(y)
} else {
  length(y)
}

if(is.factor(z)) {
  paste(z,"element")
} else if(is.numeric(z)){
  sum(z)
} else {
  length(z)
}

##paste문 =print문과 유사하다 


#반복문
i <- 20
repeat{
  if(i>25){
    break
  } else{
    print(i)
    i <- i+1
  }
}
#주의 결과로 25까지 찍힌다! 확인해봥


dan <- 2
i <- 2
while(i<10){
  times <- i * dan
  print(paste(dan,"x", i, " = ",times))
  i <- i+1
}
