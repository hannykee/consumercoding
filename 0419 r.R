#0419 r
http://www.minsshop.com/product/detail.html?product_no=12324&cate_no=11&display_group=1
http://shehj.com/product/detail.html?product_no=48090&cate_no=1&display_group=3
http://www.minsshop.com/product/detail.html?product_no=12293&cate_no=11&display_group=1

#�ǻ�������� ����
���ſ� ������ �����͵��� �м��Ͽ�
�̵� ���̿� �����ϴ� ����(���ֺ� Ư��)��
�Ӽ��� �������� ��Ÿ���� �з�����

����: �з�/����
������=�з�����(classification Tree)
������=ȸ�ͳ���(Regression Tree)

Tree���� (���=(�Ѷ󸶵�/�θ𸶵�/�ڽĸ���/������), ����, ����)
#�� ������ ��� ��� ġ������,
������ ������ ���� �������� �������θ� �����Ƿ��� ����Ѵ�.
#������ Terminal node�� �� = �и��� �κ����� ����


�ǻ�������� ����
1) �̻��� ��ǥ����(��������,��Ʈ��������)
-
-
-
2)(�л��߽�)
-
  
#��� ����ȸ���� ��, �������� ���� ������谡 �����Ѵ�. 
  �̷� ������ ����м� ���ؼ�, �̸� ����������ϴµ�
�ǻ���������� �׷� �ʿ䰡 ����.


<���� Ǯ���>
setwd("c://data")
getwd()

install.packages("party")
library(party)

df= read.csv("owner.csv")
party=ctree(ownership~., data=df)
#.(��纯��)�� ownership�� ������ ��� ������ ���������� �����ϰڴ�.
#+ �� ���� ������ ��� ����� ownership~ income+Lot size
plot(party)
#�ǻ���� ������ ownership�� ������ �ִ� ������ income�ۿ� ����. 
������ 75 �����̸� non�����ְ� ����,
�̻��̸�, �����ְ� ����
#lotsize�� ������� ������.


#Ȯ���� ǥ�����ֱ�
plot(party,type="simple")
  # ù���� Ȯ���� non, owner (���ĺ���ǥ��)

#��� �� ���� ����
print(party)


#���ߵ� ���� �̿��� ����� ������ ���̰� ������ Ȯ���غ��� �Ѵ�.
testpred <- predict(�ǻ�������, newdata=�������̸�)
table(�������, �������)
#weights=��(����)

testpred <- predict(party,newdata=df)
table(testpred,df$ownership) #�� �� ��(�� ��� , ���� ���)
#non�� non���� ������ �� : ���� ����,
non�� own���� �ؼ��ϸ� �߸���, �ݴ뵵 �߸���
own�� own���� �����ϸ� �ߵ� ����

�ǻ���������� ����� ������ ��Ÿ����
���� ���� ���� ��Ÿ����.

#���ο� �����ڰ� ������ ��, �ǻ���������� �м��� ���� ��� �ʿ� ������ �з������� �����ϴ�.
=> ������ �ִ� ���������� �ɷ�����, � �������� �з��Ǵ������� ����(����ȸ�ʹ� �ȳ���)



�������� ���� ���� ���
train(�Ʒÿ�)���� ���� �����ͱ�Ģ�� ����, test(�����)�� �����ϰڴٴ� ����
(*�����Ϳ����� ��ü�� ������ ���� �� �ǹ� ���� �� ����) ==> ����/���� �� ó�� ���ο� �����Ͱ� ������ �� �ǹ����� ������ (�������ǰ�)


str(readingSkills) #r ���� �Լ� ����Ƽ�� ����Ŀ

install.packages("caret") #�Ʒÿ�� ����븸 ������ ��Ű��
library(caret)
set.seed(1234)
df=readingSkills

intrain <- createDataPartition(y=df$nativeSpeaker,p=0.7,list=F) #p=0.7�� 7:3���� ������� ��
#����Ʈ ������ �ƴϴ�.   #�ε��� ��������!!!!!!!!!!!!!!
intrain
 #200�� 0.7 140�� ����
train <- df[intrain,] # intrain�� �Ʒÿ� �����Ϳ� �ֱ�
train

test <- df[-intrain,]   #-ǥ�ô� intrain�� �ƴ� �� �׽�Ʈ �����Ϳ� �ֱ�
test



###��Ű�� �ν����� �� �ȵ� ���(�ܺ� ����� ��Ű�� ������ġ)
install.packages("���ϴ� ��Ű�� �̸�", repos=c("http://rstudio.org/_packages","http://cran.rstudio.com"))

partymod <- ctree(nativeSpeaker~., data=train)
plot(partymod)
plot(partymod,type="simple")

testpred <- predict(partymod, newdata=test)
table(testpred,test$nativeSpeaker) #��Ȯ�� Ȯ��

YES/NO �̻�������
����
---------------------------------------------
<����������> ����

str(airquality)


set.seed(1234)
df=airquality
intrain <- createDataPartition(y=df$Temp, p =0.7, list=F)#���Ӻ��� y=temp
train <- df[intrain,]
test <- df[-intrain,] #�࿡ �ش��ϴ� ���� �� �ְ�, ���� ��� �ش��ϹǷ� ��ǥ ����

partymod <- ctree(Temp~Ozone+Solar.R+Wind, data=train)
plot(partymod)

<�ڽ��÷����� �巯��>
������ �����̹Ƿ� median���� ���� ���� ���� �µ��� ���� �׷��� ����//

  �߰��� �����ִ�. ������ ���� �� temp�� ��� �������� ������ �� �ִ�. 

testpred <- predict(partymod, newdata=test)
table(testpred,test$Temp)
