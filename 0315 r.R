#0315 파일 불러오기

#디렉토리 설정 setworkingdirectory
setwd("c:/data") 


#txt읽어올 때
변수= read.table("emp.txt",header=T)
df_txtemp=read.table("emp.txt",header=T)
class(df_txtemp)

#csv읽어올 때 
df_csvemp=read.csv("emp.csv",header=T)
#header 없는 경우
df_csvemp1=read.csv("emp.csv") #첫행을 header로 자동인식해버려서 주의

class(df_csvemp)

student0=read.table("emp.txt",header=TRUE)

#txt 파일을 세미콜론(;)으로 구분할 수 있다. 
student2=read.table("emp1.txt",sep=";",header=TRUE)
#세미콜론 이외에도 임의의 구분자를 줄 수 있음!
student3=read.table("emp2.txt",sep="",header=TRUE)
#space구분자의 경우 공백없이 그냥 따옴표만 넣자.!(중요)


#엑셀 읽어오기

#(주의) install에는 따옴표있고 library할 때는 따옴표 없다.

install.packages("readxl")
library(readxl)
df_exam<- read_excel("excel_exam.xlsx")
df_exam2 <- read_excel("excel_exam.xlsx",sheet=2)




#=======================================
#데이터 파일 저장하기

sink("output.txt") # output에 편집 시작
studentx=student3   #(편집모드)output에 저장된다.
studentx
sink()   #파일을 마감해준다.
#=======================================
  
#데이터 프레임을 csv 파일로 저장하기

df_midterm <-
  data.frame(english=c(90,80,60,70),math=c(50,60,100,20),class=c(1,1,2,2))

write.csv(df_midterm,"midterm.csv")
          #저장할 대상, 파일 이름


name <- c("A","B","C")
age <- c(21,20,31)
height <- c(163,155,180)

data <- data.frame(name,age,height)
data

data <- rbind(data, data.frame(name="D",age=45,height=177))
data

    
#하나의 행(데이터프레임형태)추가
data <- rbind(data, data.frame(name="D"))
#열추가 (벡터형태)
data <- cbind(data,weight=c(55,48,80,75))

#파생변수 만들기
data$agegroup <- data$age%/%10 *10
                        #몫 구하기 *10 은 10대 20대 연령대변수
data
