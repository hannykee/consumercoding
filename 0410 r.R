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

#0410

job_both <- welfare %>% 
  filter(!is.na(code_job)) %>%
  group_by(job,gender) %>%
  summarise(n=n())
job_both

install.packages("reshape")
library(reshape)

###Cast�� �ξ� ���� ���ϴ�
�Ǻ����̺�
cast(data=job_both,job~gender,sum)
#                   ��   ��   ��


class(welfare$religion)
table(welfare$religion)

welfare$religion <- ifelse(welfare$religion==1,"yes","no")
table(welfare$religion) #���ĺ� ������ ���ĵȴ�.

class(welfare$marriage)
table(welfare$marriage)
welfare$group_marriage<-ifelse(welfare$marriage== 1, "marriage", 
                               ifelse(welfare$marriage== 3, "divorce", NA))
table(welfare$group_marriage)
table(is.na(welfare$group_marriage))

������ ���� ��ȥ�� �м� welfare����
NA �ƴ� �� group_by ���� �ټ� ����
n=n() �ش��ϴ� ������ ������ �Ἥ ����ض�
�Ļ����� ����� sum ���ؼ� �� ���� ����� n/��ü�׷� *100 , round1�� �Ҽ��� ù°�ڸ����� �÷���

religion_marriage<-welfare %>% filter(!is.na(group_marriage)) %>% 
  group_by(religion, group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group= sum(n)) %>% 
  mutate(pct=round(n/tot_group*100,1))
religion_marriage


#summarise n= �ΰ��� ���� ���� ���������(group_by religion�� ����*(�� �ڿ� �κ��� �������� �ΰ��� ���� �������� ��Ż ���� ������)���� ��������.)

divorce <- religion_marriage %>%
  filter(group_marriage=="divorce") %>%
  select(religion,pct)
#divorce�� ��ĸ� �̾Ƽ� ������ �ְ� ������ �����ؼ� �� �� ����
divorce 


#���ɴ뺰 ��ȥ�� �м�
ageg_marriage<-welfare %>% filter(!is.na(group_marriage)) %>% 
  group_by(ageg, group_marriage) %>% 
  summarise(n=n()) %>% mutate(tot_group=sum(n)) %>% 
  mutate(pct=round(n/tot_group*100,1))
ageg_marriage

ageg_divorce<-ageg_marriage%>% filter(group_marriage== "divorce") %>% select(ageg, pct)
ageg_divorce

ggplot(data=ageg_divorce, aes(x=ageg, y=pct)) +geom_col() 

#col()�� �ѹ� ������ ������!! bar�� �����ȵ�

ageg_religion_marriage<-welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(ageg, religion, group_marriage) %>% 
  summarise(n=n()) %>% mutate(tot_group=sum(n)) %>% 
  mutate(pct=round(n/tot_group*100,1))
#�� �ڿ� �׷�by�� ��Ż���� ������
ageg_religion_marriage

#��ȥ���� ��
divorce_rate<-ageg_religion_marriage%>% 
  filter(group_marriage== "divorce") %>% 
  select(ageg, religion, pct)
divorce_rate

ggplot(data=divorce_rate, aes(x=ageg,y=pct,fill=religion)) + 
  geom_col()

##############�ſ� �߿�!           �ڵ�� �ݿ��ϱ�#########
#������ ���ɴ� ����
class(welfare$code_region)
table(welfare$code_region)
#spss�� ���ڰ��� �ƴϱ� 
#������ ���� �̸��� �����ش�.
list_region<-data.frame(code_region=c(1:7), 
                        region=c("����","������","�泲","���","�泲","���/����","����/����"))

#####�ڵ�Ͽ��� ���� ������ ����� ������ left_join�� �� ��, �ڵ�Ͽ� ������ų �� ���� (*��, ���� ���Ͽ� ������ �̸��� �����ؾ� �Ѵ�.)
welfare <-left_join(welfare, list_region, id="code_region")
region_ageg<-welfare %>% group_by(region, ageg) %>% summarise(n=n()) %>% mutate(tot_group= sum(n)) %>% mutate(pct=round(n/tot_group*100,2))
head(region_ageg)


ggplot(data=region_ageg, aes(x=region, y=pct, fill=ageg))+geom_col()+coord_flip()

#sorting�ϱ� ���������� 
list_order_old<-region_ageg%>% filter(ageg== "old") %>% arrange(pct)
list_order_old

list_order_middle<-region_ageg%>% filter(ageg== "middle") %>% arrange(pct)
list_order_middle
                        
                        
list_order_old<-region_ageg%>% filter(ageg== "old") %>% arrange(pct)
list_order_old

list_order_middle<-region_ageg%>% filter(ageg== "middle") %>% arrange(pct)
list_order_middle


#���ݱ��� �ñ��� �κ��� ���м�,��������
Ÿ���� ���ؼ� �ϴ� ���� �ϱ� �����
�� ���� �����м����� ��¥ ����