#0405 r
install.packages("readxl")
install.packages("foreign")
library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

setwd("c://data")
welfare <- read.spss("Koweps_hpc10_2015_beta2.sav", to.data.frame=T) #���� �����͸� �����ϵ��� T
str(welfare)

#������ �̸� �ٲٱ� rename �Լ��� ���� �ٲ� �̸� = �ڰ� ���� �̸�
welfare <-rename(welfare, code_region=h10_reg7, gender=h10_g3, birth=h10_g4, marriage=h10_g10, religion=h10_g11,code_job=h10_eco9, income=p1002_8aq1)

#1�ܰ� : ���� ���� �� ��ó��
#2�ܰ�; ������ ���� �м�


#���� ���� �� ��ó�� �ܰ�
class(welfare$gender)
table(welfare$gender)#�󵵴� ���� ����
welfare$gender <- ifelse(welfare$gender==9,NA,welfare$gender) #��������9
                          #x�̸�, �̰ɷιٲٰ�, �ƴϸ��̰ɷ��Ѵ�.
table(is.na(welfare$gender))

welfare$gender <- ifelse(welfare$gender==1,"male","female")
table(welfare$gender)

getwd()

qplot(welfare$gender)


class(welfare$income)
summary(welfare$income) #���� ���̹Ƿ� ������ ���

qplot(welfare$income)
qplot(welfare$income) + xlim(0,1000) #��� ������ �պ��� �پ�����.

summary(welfare$income)
welfare$income <- ifelse(welfare$income==0|welfare$income==9999,NA,welfare$income)
table(is.na(welfare$income)) #TRUE�� ����ġ

gender_income <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(gender)%>%
  summarise(mean_income=mean(income))
gender_income


ggplot(data=gender_income, aes(x=gender,y=mean_income))+geom_col()
#bar�� ����Ḧ ������׷����� ������, col�� ...? ������ ������ ����??




#���̿� ������ ����
class(welfare$birth)
summary(welfare$birth) # ���� ����� ���� ����� �������(���̴� �� �ٸ�)
table(is.na(welfare$birth))




#������ ��: ��������� ���� ���� ���̷� ��ȯ���־���Ѵ�.
welfare$age <- 2018-welfare$birth + 1
summary(welfare$age)
qplot(welfare$age)

age_income <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(age) %>%
  summarise(mean_income=mean(income))
head(age_income)

#���α׷����� �׷�����
ggplot(data=age_income,aes(x=age,y=mean_income)) + geom_line()

welfare$agegroup= welfare$age %/%10 * 10  #���� �� ��ȯ * 10 ���ɴ�
table(welfare$agegroup)

age_income <- welfare %>% filter(!is.na(income)) %>%
  group_by(agegroup) %>% summarise(mean_income=mean(income))

age_income
ggplot(data=age_income, aes(x=agegroup,y=mean_income)) + geom_col()

#���̴� ��,��,���
welfare <- welfare %>% mutate(ageg=ifelse(age<30,"young",
                                          ifelse(age<=59,"middle","old")))
#�󵵰��
table(welfare$ageg)

#��� ���ϱ�
ageg_income <- welfare %>% filter(!is.na(income)) %>%
  group_by(ageg) %>% summarise(mean_income=mean(income))
ageg_income

ggplot(data=age_income,aes(x=ageg,y=mean_income)) + geom_col()#�⺻�� ���ĺ���������

#��,��,��� ������ ���� discrete limit�� �̰� ������ �Ĺ����ض�

ggplot(data=age_income,aes(x=ageg,y=mean_income)) + geom_col() +
  scale_x_discrete(limits=c("young","middle","old"))

#�ΰ��� ������ �ϳ� �׷��� �׸���
gender_income<-welfare %>% filter(!is.na(income)) %>% 
  group_by(agegroup, gender) %>% summarise(mean_income= mean(income))
gender_income

fill ������ ĥ�ض�, agegroup����

ggplot(data=gender_income, aes(x=agegroup,y=mean_income,fill=gender))+geom_col()

gender_income <- welfare %>% filter(!is.na(income)) %>%
  group_by(age,gender)%>%
  summarise(mean_income = mean(income)) 
gender_income

ggplot(data=gender_income,aes(x=age,y=mean_income,col=gender)) +
  geom_line(aes(group=gender))


#������ �������� =-> �ڵ�� �����ϱ�
class(welfare$code_job)
table(welfare$code_job)

list_job <- read_excel("Koweps_Codebook.xlsx",col_names=T,sheet=2)
list_job


#job������ welfare ������ �����ӿ� ���� (left_join: �������� ����ִ� ���� ���� ��ġ��)_
#ū������ left join ��
welfare <- left_join(welfare,list_job,id="code_job")

welfare %>% filter(!is.na(code_job)) %>%
  select(code_job,job) %>%
  head(10)

job_income <- welfare %>% filter(!is.na(job) & !is.na(income)) %>%
  group_by(job) %>%
  summarise(mean_income=mean(income))
head(job_income)

top10 <-job_income%>% arrange(desc(mean_income)) %>% head(10)
top10

ggplot(data=top10, aes(x=reorder(job,mean_income),y=mean_income))+
  geom_col()+coord_flip()

bottom10 <-job_income%>% arrange(mean_income) %>% head(10)

ggplot(data=bottom10, aes(x=reorder(job,-mean_income),y=mean_income))+
  geom_col()+coord_flip()