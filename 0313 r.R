#03-13 R ����
as.factor() #���������� ��ȯ.. ������������
gender=c("M","F","M","M","F")
gender

fgender = as.factor(gender)
fgender  #levels�� ī�װ����� ���� ��
plot(fgender)
str(fgender)

#������������ ����
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


#�Ļ����� �����
mydata$BMI = mydata$weight / (mydata$height/100)^2
mydata

summary(mydata)
plot(mydata)



#�Լ�
sum(c(1:10))

seq(0,1,by=0.001) # ���� �����ߴ�.
seq(0,1,length.out=100)   #�˾Ƽ� �������� 100�� ����

rep(c(1,2,3),times=2)
rep(c(1,2,3),each=2)


#������������
name <- c("ö��","����","�浿")
age <- c(21,20,31)
gender <- factor(c("M","F","M"))
character <- data.frame(name,age,gender)

#���� Ž��(������ �����ӿ���)

character[character$gender == "F",] #gender�� �༮���� ���� ��� �����Ͷ� 
character[character$age<30,]
character[character$age<30 & character$gender =="F",]
# & and | or(�齺���̽� ����Ʈ)


#���ǹ�2
x <- c(1,2,3)
x <- factor(x)

if(is.factor(x)){
  length(x)
} else {
  sum(x)
}
y <- c(1,2,3)
z <- c(0.4,0.7,0.9)

#if else�� �� �ܰ��� ���ǹ�
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

##paste�� =print���� �����ϴ� 


#�ݺ���
i <- 20
repeat{
  if(i>25){
    break
  } else{
    print(i)
    i <- i+1
  }
}
#���� ����� 25���� ������! Ȯ���ؔg


dan <- 2
i <- 2
while(i<10){
  times <- i * dan
  print(paste(dan,"x", i, " = ",times))
  i <- i+1
}