������ ����

df <- data.frame(gender=c("M","F",NA,"M","F"), score=c(5,4,3,4,NA))
df

#����ġ ã�� �����ϱ�
#����ġ Ȯ���ϱ�

table(is.na(df))
is.na(df)

df_nomiss <- df %>% filter(!is.na(gender) & !is.na(score))
df_nomiss


#�̻�ġ ã�� �����ϱ�

outlier <- data.frame(gender=c(1,2,1,3,2,1), score=c(5,4,3,4,2,6))
outlier

table(outlier$gender)
table(outlier$score)

outlier$gender <- ifelse(outlier$gender==3,NA,outlier$gender)
outlier$score <- ifelse(outlier$score ==6,NA,outlier$score)
outlier

#ã�Ұ� NA�� �ٲ㼭 �̷��� �̻�ġ���� �����ϱ�
outlier%>% filter(!is.na(gender) & !is.na(score))





#���ۺ���
install.packages('googleVis')
library(googleVis)
Fruits


#�־��� �Լ���� ������ ������� �ϱ� -> �Ǻ�(pivot)���̺� ����µ� �����ϴ�.
#aggregate(���� �� ~ ���ؿ�, ������, �Լ�) 
#���� ������ +�� ǥ��
aggregate(Sales~Fruit,Fruits,sum)
aggregate(Sales~Date,Fruits,sum)
aggregate(Sales~Fruit,Fruits,max)
aggregate(Sales~Fruit+Year,Fruits,max)



#����ǰ ���� ������ 
setwd("C:/data")
req=read.csv("requisites.csv")
nrow(req)
summary(req)

aggregate(A_PRICE ~ M_TYPE_NAME + A_NAME,req,mean)






#reshape ��Ű��
install.packages("reshape")
library(reshape)
melt ���� DB����     
cast ������ �����
  # melt�� output�� cast�� ����.





#������ �������� ���� ���� ���Ǵ� �� dplyr��Ű��  reshape ��Ű��

airquality #���嵥����

apm=melt(airquality,id=c("Month","Day"),na.rm=T) #���غ��� �� �ν��� ���� �� ����
apm
a=cast(apm,Day ~ Month ~ variable)  #data, ��~ ��~ �ش��ϴ°�
a

b=cast(apm,Month ~ variable,mean) #������, ��~ ��, ��հ��� ǥ����!!!!!!!
b
#cast�� �Ǻ����̺��� ����� ���̸�, input���δ� melt�� output�� �޴´�.

#margin�ɼ����� ��� ���� ���� �Ұ踦 �����ϴ� ���(ex.��յ� ������)
c= cast(apm,Month~variable,mean,margins=c("grand_row","grand_col"))
c

#range�� �ִ밪,�ּҰ� ����
d= cast(apm,Month~variable,range)
d

#�ΰ��� ��� �Ѱ��� �� ���տ� ���� �Ǻ����̺�
e= cast(apm,Month+Day~variable)
e