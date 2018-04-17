install.packages("readxl")
install.packages("foreign")
library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

setwd("c://data")
setwd("c:/data")
fact_data=read.csv("clust_data.csv",header=T)
#���ϴ� �Ӽ��� ��󳻱�(filter)
fact_data
#����ǥ��ȭ
scale(�������̸�)
#�Ÿ����-�Ÿ� ��� �����
dis_data=dist(fact_data,method="euclidean")
#������ ��� �� ��� ����
hc_sl=hclust(dis_data,method="single")
hc_co=hclust(dis_data,method="complete")
hc_av=hclust(dis_data,method="average")
hc_wd=hclust(dis_data,method="ward.D")
#���� Ȯ���ϱ� 
par(mfrow=c(2,2))  #�׷����� 4�� �׸� ���̴� ���� �̸� �Ҵ�
plot(hc_sl,hang=-1)   #����α׷� �׷��ִ� �Լ� hang�� 
rect.hclust(hc_sl,k=3,border="red")
������ �м��� k�� 3���� ����(*��������)���� ������ ������ �׸�� ������. ( ���� �������ֱ�)

plot(hc_av,hang=-1)
plot(hc_co,hang=-1)
rect.hclust(hc_co,k=3,border="red")

rect.hclust(hc_av,k=3,border="red")

plot(hc_wd,hang=-1)
rect.hclust(hc_wd,k=3,border="red")
#�͵��� ������ ������ �����̱� ������ ���� ���� Ŭ�����Ͱ� ����

)()

<����������>)
#���� �м��� �� ������ ���� �м��� �ƴϴ�. 

#���� ���� �������ѳ��� ����( ���� �м��� ������ ����. ) = kmeans�� ������ ����
set.seed(1234)
#�����м� �ǽ�, k�� ������
nc_kmeans=kmeans(fact_data,3)
nc_kmeans
#����ؼ�

��]Ŭ�����Ͱ� ��� �������� 3���� 6�� 7�� 7��

��]���� �����߽ɰ�==> �� �׷��� Ư�� �ľ� ******�ſ� �߿�
1Ŭ������ (������ �����ϰ� ��� ũ��. => ���ݿ� ���� �ΰ����� ���� ���� �������� �߿��ϰ� �����ϴ� �׷�-��ǰ�� �Ӽ� �߽�)
2Ŭ������ (���簡 ��Į�θ��� ���� ����, ��.�����ؼ�.û����.�����Ⱑ �߿��� �׷�- ����� ��ü�� ��ġ�� ���� ��)
3Ŭ������ (������ ���� �߿��� �׷�)

��] n�� Ŭ������ �Ҽ� ����
clustering vector 20���� � Ŭ�����Ϳ� �ҼӵǾ� �ִ��� �˷���

�� �ڴ� �ؼ��� �ʿ䰡 ����
(������ ���)
(availabe components ���� Ȯ���Ҽ��� �ִ� �� ����)
nc_kmeans$size #(�� Ŭ������ �� ������Ʈ ��)
nc_kmeans$iter #(�ݺ� ) �� �� ���� ���ŵǾ���.


#####################Ŭ�����ͷ� ���� �߰������  => �α�������� ���� Ȯ���ϱ�
fact_data$cluster=nc_kmeans$cluster 
#�̸� �����ͷ� ������ֱ�
write.csv(fact_data,"newcluster.csv")

#--------------------------------------------------------------------------------------------------------------
#------------------0417----------------------------------------------------------------------------------------
install.packages("cluster")
library(cluster)
clusplot(fact_data, nc_kmeans$cluster, color=TRUE, shade=TRUE, labels=2,lines=0)  #labels 2�� ������ �ΰ� �� ���ְڴ�.
#7�Ӽ��� 2�������� ǥ���� ���̹Ƿ�, ��� ���������� Ȯ�� ����!
11���� ��𿡵� �� �� �ִ�.


#outlier�� ���� ������ <  K-MEDIAN  > ���
install.packages("Gmedian")
library(Gmedian)

set.seed(1234)
nc_kmedian=kGmedian(fact_data,3)
nc_kmedian
#Ŭ������ �Ҽ� 1. ���� �߽�, 2.���� Ư�� �߽�, 3. �ǰ��߽� �׷�
#�߽ɰ�(�߽ɰ� ���� ��ü �� �Ÿ��� ������)
#���� Ŭ������ �� ��ü����

#�ð�ȭ
clusplot(fact_data,nc_kmedian$cluster,color=TRUE, shade=TRUE, labels=2, lines=0)