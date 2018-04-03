#0403
������ ������ �м��� ���� + ���� ������
#Ÿ�� ����                   #�丣�ҳ� ���㼭��(��Ʋ�ݰ���)

(��ǥ ���� Ư���� �˾Ƴ���)
���� ���� ��� -> ����ϵ���(�����м�->Ư��->Ÿ�ٰ��������)

�λ� �Ķ���̽� ȣ�� (����Ͻ� ����)

������ ������Ʈ=> �ұݱ� (��������)


library(ggplot2)

#������׷� : x�� ������ �󵵷� y��
ggplot(mpg,aes(hwy,fill=drv))+geom_histogram()

#���������� ���� ����, �ķ������� ���� ����

#BAR Chart
geom_bar ������ ���(x�ุ ����) 
#������׷��� �����ϳ� ���м� ����
geom_col �����͸� ����� �� ���� ���� ���

ggplot(mpg,aes(hwy)) +geom_bar()
ggplot(mpg,aes(manufacturer))+geom_bar()

#�׷��� ���� ȸ�� !!!-> x�� qustnrk rlf Eo
ggplot(mpg,aes(manufacturer))+geom_bar()+coord_flip()


library(dplyr)
df_mpg<- mpg%>% 
  group_by(drv)%>% 
  summarise(mean_hwy=mean(hwy))

ggplot(df_mpg,aes(x=drv,y=mean_hwy)) + geom_col()

#ũ�� �� ����
ggplot(df_mpg,aes(x=reorder(drv,mean_hwy),y=mean_hwy))+geom_col()
##############���� ��� ����!! -mean_hwy����������


#������ĺ� ���ӵ����� ������ ǥ�������� bar chart �����
sd_mpg <- mpg %>%
  group_by(drv)%>%
  summarise(std_hwy=sd(hwy))

ggplot(sd_mpg, aes(x=drv,y=std_hwy))+geom_col()


#���α׷��� => �߼�, �ð� (��ȭ�� ����)
economics

ggplot(economics,aes(x=date,y=pce))+geom_line()
ggplot(economics,aes(x=date,y=unemploy))+geom_line()


#��� ����� Ȱ���� ���� �׷�����#
ggplot(economics, aes(x=date))+
  geom_line(aes(y=psavert,col="psavert"))+
  geom_line(aes(y=uempmed,col="uempmed")) +
  ylab("rate") #y���� �̸��� ���� �������ش�.
#y���� �ټ��� �Է���. + a ����

#������ ���̱� 
ggplot(economics, aes(x=date,y=pce)) +
  geom_line() +
labs(title="PCE bydate",
     caption="Source:economics", 
     x="date",
     y="personal consumption expenditures")

#�׷��� ���� ����

class(mpg$class)
table(mpg$class) #�� Ŭ���� �� ����
gd <- mpg %>%
  group_by(class) %>%
  summarise(hp=mean(hwy))
ggplot(data=gd, aes(x=class,y=hp))+geom_col()

ggplot(data=mpg,aes(x=class,y=hwy))+geom_point()

#�ڵ��� ������ ���� ���ӵ��� ���� �������� ��� ���ӵ��� ���� ���� �׸���
ggplot(data=mpg,aes(x=class,y=hwy))+geom_point()+
  geom_col(data=gd,aes(x=class,y=hp),alpha=0.5)
  #��� �����̹Ƿ� �� �׷����� col(���׷����Լ�) �ȿ� �־ �׷��� �� �ִ�. 
  #alpha���� ���� ���� (���� ���� ����)
#���⿡�� �簢 �ڽ��� ��� (���� �ڷ� ������ ǥ��)


#�� ������ ������ �˰� ���� ��
ggplot(data=mpg,aes(x=class,y=hwy))+
  geom_point(col="red")+
  geom_col(data=gd,aes(x=class,y=hp),alpha=0.5)+
  geom_text(aes(x=class,y=hwy,label=manufacturer))

install.packages("readxl")
install.packages("foreign")
library(foreign)

setwd("c://data")
welfare <- read.spss("Koweps_hpc10_2015_beta2.sav", to.data.frame=T) #���� �����͸� �����ϵ��� T
str(welfare)

