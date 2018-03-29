#0329 r
iris

#sqldf�� ������ ������ ���¸� �ٷ� �� �ִ�.
install.packages("sqldf")
library(sqldf)

str(iris)

sqldf('select * from iris')
sqldf('select* from iris limit 5')

sqldf('select* from iris where species = "setosa"')
sqldf('select "Petal.Length" from iris where Species="setosa"')

sqldf('select sum("Petal.Length") from iris where species = "setosa"')
sqldf('select avg("Petal.Length") from iris where species = "setosa"')

install.packages("googleVis")
library(googleVis)

Fruits

<�������� ����>
sqldf('select* from Fruits order by Year')
<�������� ����>
  sqldf('select* from Fruits order by Year desc')

<�׷��Լ� ����ϱ�>
sqldf('select sum(Sales) from Fruits')
sqldf('select max(sales) from Fruits')
sqldf('select min(sales) from Fruits')
sqldf('select avg(sales) from Fruits')

sqldf('select Fruit, avg(Sales) from Fruits group by Fruit')
sqldf('select Fruit, sum(sales) from Fruits group by Fruit')

<��� �������� ��� ����ϱ�- ū �������� ���� Ȯ���� ��n>
sqldf('select count(*) from Fruits') #�������� �� �� ��

<sub Query   where �ڿ� select��� ���� �� �ϳ� �� ��  <,>,in>
#������ 89�� �Ǹ� �����͸� �����ϰ� �� ������� ū �Ǹ� ����� ���� ������ ����

sqldf("select * from Fruits where Expenses='78'")
sqldf("select * from Fruits where Sales > (select sales from Fruits where Expenses=78)")
                                            #��� ä�� �� �� ����
                                        #�� Sales���� ���ϹǷ� select�� sales�� ����


sqldf('select Sales from Fruits where sales > 95')  #���⿡ *�� select �ص� �Ʒ� ���ɾ�� ������ ���
sqldf('select * from Fruits where Sales in (select Sales from Fruits where sales>95)')
                                      #in �� �ڿ� subset(����)�� �ִ�.  �ǸŰ� 95���� ū ���� �����ϰ� �� sales�� ����


var1=c('��','��','��')
var1= as.data.frame(var1)
sqldf('select * from var1')


ca=c('��','��','��','��','��','��','��')
lv = c(3,7,11,31,49,78,43)
id = c(3233,3789,4939,2665,4555,7888,9999)
data = data.frame(CA=ca,LV=lv,ID=id)
data


var1�� ������ �� �� �߿��� id����
(��,��,��)
sqldf('select ID from data where CA in (select * from var1)')


-----------------������� filter���

������ �����ϱ�  (c�Ĺ����ض�(���,�ָ�), �����ġ)

#������ ���+ �߰��� ��� �Ĺ���
# sqldf(c('insert into   �����ϰ��� �ϴ� ������ select ))


Time=c(1,2,3,4,5,7)
demand=c(8.3,10.3,19.0,16.0,15.6,19.8)
BOD=data.frame(Time=Time,demand=demand)


New = BOD[1,]
New

BOD1 = BOD[2:3, ]
BOD1

#rbind
sqldf(c('insert into New select * from BOD1','select * from New'))


Fruits

sqldf(c('update Fruits set Profit=80 where Fruit="Apples" and year=2008', 'select * from Fruits'))
#set �������Ѷ� update 80���� �ٲ� ���� �ٽ� ����


sqldf(c('delete from Fruits where Fruit= "Apples" and year=2008','select * from Fruits'))





###########ggplot2 ���� �׷��� �Z��

install.packages("ggplot2")
library(ggplot2)

1�ܰ�: ��漳��(��)
2�ܰ�: �׷��� �߰�(��,��,����)
3�ܰ�; ���� �߰� (�����,��,ǥ��)

##   data= x= y= ��������
1.ggplot(data= ������ �̸�)
2.aes(x=x��,y=y��)
3.geoms(geometric object)�� �߰� ��/��/���� (*������ ��밡��)
4.���μ���: ����� �� +�����ڸ� ����Ͽ� xlim(����۰�,�ึ������,ylim(,), labs�� �����߰�)

mpg


<������ - ������ ������>
#r �⺻��Ű�� : plot(mpg$displ,mpg$hwy)
#               qplot(mpg$displ,mpg$hwy)
#�������� �׷��� �÷԰� �ٸ� �׷��� ������ ������ �� �ִ�. 
  
car_plot<- ggplot(mpg, aes(x=displ,y=hwy)) + geom_point()

<�÷� ���>
ggplot(mpg,aes(x=displ,y=hwy,col=class))+geom_point()
ggplot(mpg, aes(displ, hwy)) + geom_point(colour= "blue")


<Ŭ���� ���� ��Ȯ�ϰ� �����ϱ�>
##facet�� ���� ���տ� ���ؼ� ���׷����� �����Ͽ� �׷��ش�.
ggplot(mpg,aes(displ,hwy))+geom_point()+facet_wrap(~class)

<�߼��� - �����Լ� ȸ�ͽ� ã��>
ggplot(mpg,aes(displ,hwy)) + geom_point() + geom_smooth()

<�߼���-lm���� �������� �߰��ϱ�>
ggplot(mpg,aes(displ,hwy)) + geom_point() + geom_smooth(method="lm")



<�ڽ��÷�- ����Factor(������)������ >  #�л굵 ������ Ȯ�� ����
#ggplot(mpg,aes(drv,hwy)) + geom_point()
ggplot(mpg,aes(drv,hwy)) + geom_boxplot()

ggplot(mpg,aes(hwy)) + geom_histogram()
              #x�ุ �������ָ� ��(count)�� �ڵ����� y������ �ش�ȴ�.