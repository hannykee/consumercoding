#0315 ���� �ҷ�����

#���丮 ���� setworkingdirectory
setwd("c:/data") 


#txt�о�� ��
����= read.table("emp.txt",header=T)
df_txtemp=read.table("emp.txt",header=T)
class(df_txtemp)

#csv�о�� �� 
df_csvemp=read.csv("emp.csv",header=T)
#header ���� ���
df_csvemp1=read.csv("emp.csv") #ù���� header�� �ڵ��ν��ع����� ����

class(df_csvemp)

student0=read.table("emp.txt",header=TRUE)

#txt ������ �����ݷ�(;)���� ������ �� �ִ�. 
student2=read.table("emp1.txt",sep=";",header=TRUE)
#�����ݷ� �̿ܿ��� ������ �����ڸ� �� �� ����!
student3=read.table("emp2.txt",sep="",header=TRUE)
#space�������� ��� ������� �׳� ����ǥ�� ����.!(�߿�)


#���� �о����

#(����) install���� ����ǥ�ְ� library�� ���� ����ǥ ����.

install.packages("readxl")
library(readxl)
df_exam<- read_excel("excel_exam.xlsx")
df_exam2 <- read_excel("excel_exam.xlsx",sheet=2)




#=======================================
#������ ���� �����ϱ�

sink("output.txt") # output�� ���� ����
studentx=student3   #(�������)output�� ����ȴ�.
studentx
sink()   #������ �������ش�.
#=======================================
  
#������ �������� csv ���Ϸ� �����ϱ�

df_midterm <-
  data.frame(english=c(90,80,60,70),math=c(50,60,100,20),class=c(1,1,2,2))

write.csv(df_midterm,"midterm.csv")
          #������ ���, ���� �̸�


name <- c("A","B","C")
age <- c(21,20,31)
height <- c(163,155,180)

data <- data.frame(name,age,height)
data

data <- rbind(data, data.frame(name="D",age=45,height=177))
data

    
#�ϳ��� ��(����������������)�߰�
data <- rbind(data, data.frame(name="D"))
#���߰� (��������)
data <- cbind(data,weight=c(55,48,80,75))

#�Ļ����� �����
data$agegroup <- data$age%/%10 *10
                        #�� ���ϱ� *10 �� 10�� 20�� ���ɴ뺯��
data