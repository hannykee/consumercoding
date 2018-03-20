#0320 r

#������ �Һ��� �м�(������/������)

#�Ļ����� �����
library(ggplot2)
head(mpg)
summary(mpg)
str(mpg)

#mpg�� ���տ��� �Ļ����� �����
mpg$total = (mpg$cty +mpg$hwy)/2
#attach(mpg) �� ���ݺ��� mpg�� ��� �ٿ����ƶ�. -> mpg$ǥ�ø� �� �ʿ� ����.
attach(mpg)
total2 = cty + hwy
detach(mpg)

summary(mpg$total)
mean(mpg$total)
hist(mpg$total)

#���ǹ����� �Ļ����� �����
#ifelse�� ifelse(����, ������ ���, ������ ���� ���� ���)

mpg$test = ifelse(mpg$total >= 20, "pass", "fail")
head(mpg)

#ifelse ��ø��

mpg$grade = ifelse(mpg$total >=30, "A",
                   ifelse(mpg$total>=25,"B",
                          ifelse(mpg$total >=20,"C","D")))
head(mpg)
table(mpg$grade)


#������ ������ ���� ���
#dplyr ��Ű��(a Grammear of Data Manipulation)

install.packages("dplyr")
library(dplyr)

#������ ������ Ȥ�� �Ʒ� �������� ����Ѵ�.
data %>% �Լ�(���ǹ�)
�Լ�(data,���ǹ�)  


#�� ����
filter()

#��(����)����
select()

#����
arrange()

#���� �߰�
mutate()

#���ġ ���� 
summarise()

#���ܺ��� ������
group_by()

#������ ��ġ��(��)
left_join()

#������ ��ġ��(��)
bind_rows()


#������
mpg %>% filter(manufacturer == "audi")  #�����ص� ������ ������ ���·� �����Ѵ�.
mpg %>% filter(manufacturer!= "audi")
mpg %>% filter(manufacturer=="audi"& cty >=20)
mpg %>% filter(cty>25 | hwy > 30) #���� ���� �͸� ����

#������ ������ ������ �����
audi = mpg %>% filter(manufacturer =="audi")
chevrolet = mpg %>% filter(manufacturer == "chevrolet")
mean(audi$cty)
mean(chevrolet$hwy)




#������   --> ������ ���� �߿� ���ϴ� ������ ������ ��
mpg %>% select(class)
mpg %>% select(manufacturer, model, cty, hwy, class)
mpg %>% select(-model)
mpg %>% select(-model, -trans)

#�ʿ��� ������ �����ϱ�! filter�� select �����ϱ�
mpg %>% filter(manufacturer == "audi") %>% select(cty)


#������ �����͸� Ȱ���� �߰��м��ϱ�
suv = mpg %>% filter(class=="suv") %>% select(cty)
compact = mpg %>% filter(class=="compact")%>% select(cty)
mean(suv$cty)
mean(compact$cty)

#������� �����ϱ�
mpg %>% arrange(cty)
mpg %>% arrange(desc(cty))


#�� ���� ���ÿ� ������� �����ϱ�
mpg %>% arrange(cty,hwy)


mpg %>% filter(manufacturer == "audi") %>% arrange(desc(hwy))


#�Ļ����� �߰��ϱ� -- *���� ������ �Ѳ����� �߰��� �� �ִ�.
mpg %>% mutate( ave = (cty+hwy)/2)
mpg %>% mutate(ave=(cty+hwy)/2) %>% arrange(ave) #ave ������ �������� ����

#�Ļ��������� ���ǹ�, ���� ��� ���� �����ϴ�
mpg %>% mutate(test1 = ifelse(cty >=20, "pass","fail"))


#���ܺ��� ����ϱ� (�ſ� �߿�)**
mpg %>% group_by(manufacturer)%>% summarise(mean_cty=mean(cty))
#������ ���� �׷��� ������, ���� �׷캰�� mean_cty�� ���� ���� ������ �̸��̰� ���ο� ������ �߰��ȴ�.

mpg %>% group_by(manufacturer)%>% summarise(mean_cty=mean(cty)) %>% arrange(mean_cty)

#���� ����� : Ŭ���� ���� ��� �������� �� üũ(���� ���� ����) n= n()####################
#########�߿�


mpg %>% group_by(class) %>% summarize(mean_cty=mean(cty),mean_hwy=mean(hwy),n=n())
# �̸� ������ �����ϸ� ��� ��� ���� �տ� �����̸� = 

mpg %>% group_by(class) %>% summarize(mean_cty=mean(cty),mean_hwy=mean(hwy),n=n()) %>% arrange(mean_cty,mean_hwy)


#���ܺ��� ����ϱ�
#���ܺ��� 2�ܰ� ������ �����ϱ� ���ؼ��� group_by()�� ���� ������ �����ϸ� �ȴ�.
mpg%>% group_by(manufacturer,model) %>% summarise(mean_cty=mean(cty))
  #�α�������� ���� ����/ ���� ���ÿ� �� ��



mpg %>% 
  group_by(manufacturer)%>%
  filter(class=="suv")%>%
  mutate(ave = (cty+hwy)/2)%>%
  summarise(mean_ave = mean(ave))%>%
  arrange(desc(mean_ave))

#����) �� ������ ������ ��տ����� ������������ ����




#���η� ��ġ��
left_join() #���� ����(���� �κп� �� ����-������ �������� ������ ���� ���� �����)
right_join() #������ ����(���� �κп� �� ����-�������� �������� ���� ���� ���� �����)
inner_join() #�ΰ� �� �־�߸� (���� ��� �����ϴ� ��쿡�� ��������: ������)
full_join() #������ �������� ���ʸ� �����ص� ��������.


test1<- data.frame(id  = c(1,2,3,4,5),midterm = c(60,80,70,90,85))
test2<- data.frame(id = c(2,3,4,5,6), final = c(70,83,65,95,80))
total <- left_join(test1,test2, by="id")
total