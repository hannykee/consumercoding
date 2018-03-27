#0327 r

#SQL ���������� (field�� ���� ������-������������(��/����/������))
#DB ���� �� ����ȭ�� ���Ǿ� #Structured Query Language ����ȭ�� ���� ���)
#SELECT ���� FROM ������ WHERE ����


#������ ���� ��� DDL
CREATE ����
DROP ��������
ALTER ���� ����

#������ ���� ��� DML
INSERT �൥����/���̺� ������ ����
UPDATE ��������
DELETE ���̺� Ư�� �� ����

#������ ���� ��� DCL
COMMIT Ʈ������ ����
ROLLBACK Ʈ�������� ���


install.packages("sqldf")
library(sqldf)



warpbreaks

alr = head(warpbreaks)
alr

<limit> ��������� �����!
als = sqldf('select* from warpbreaks limit 6')
## �ȿ� ��������ǥ�� ���� ū ����ǥ�� ������.

identical(alr,als)  
#�� ���� ������ ��������

<������,������ like>
a2s <- sqldf("select* from warpbreaks where tension like 'L'")
a2s

<���� ���� �� in () ���>
a3s <- sqldf("select* from warpbreaks where tension in ('M','H')")
a3s

<������������ ��� , between>
a4s <- sqldf("select* from warpbreaks where breaks between 20 and 30")

<���� = ��ȣ�� ���>
a5s <- sqldf("select* from warpbreaks where wool = 'A'")
a5s

<rbind ��ġ��>
a6s <- sqldf("select* from warpbreaks where wool = 'B'")
a7s <- rbind(a5s,a6s)
a7s


<union ������ ��ġ��>
a7r <- sqldf("select* from a5s union all select * from a6s")
### union all
a7r

identical(a7s,a7r)

<order by- ������, �⺻������>
<�������� ����-filter,arrange�� ����  #���������� desc���ڸ� �����ϸ� default��>
a8s = sqldf("select* from warpbreaks where tension = 'L' order by breaks desc")
a8s

<������ ������ ���� Ȯ���ϱ�>
sqldf('select distinct wool from a8s')

<������������ limit�ֱ�>
a10s <- sqldf("select* from warpbreaks order by breaks desc limit 10")
a10s
<������������ limit�ֱ�>
a11s <- sqldf("select* from warpbreaks order by breaks limit 10")
a11s

<�ټǿ� ���� breaks�� ��� ���ϱ�>
a8s <- sqldf('select tension, avg(breaks) from warpbreaks group by tension')
a8s

<������ ���� �����ϱ�>
Gavg <- sqldf("select tension, avg(breaks) as avg_v from warpbreaks group by tension")
Gavg


<from ���� �����Ͱ� ������ ������ �� �ִ�. r�� $�������� .������ ���� ���ȴ�.)>
a12s <- sqldf("select warpbreaks.breaks,warpbreaks.wool,warpbreaks.tension from warpbreaks,Gavg
               where warpbreaks.tension=Gavg.tension and warpbreaks.breaks >avg_v")
a12s



setwd("c://data")
ucb= read.csv("ucb.csv")
ucb

<select �� �Լ� ����ϱ�>

sqldf("select sum(Freq) from ucb where Admit='Admitted'")

sqldf("select sum(Freq) from ucb where Admit='Rejected'")
<�̸� �ٸ���, Where �������� ��� ���ǹ��� �� �� �ִ�.>
sqldf("select sum(freq) as total_dudes from ucb where Admit = 'Admitted' AND Gender='Male'")

sqldf("select sum(Freq) as total_ladies from ucb where Admit = 'Rejected' AND Gender='Female'")

<Group by-�׷����� ��� ��� ���� !!! ���� �̸� �ٲٱ�>
sqldf("select Dept, avg(Freq) as average_admitted from ucb where Admit='Admitted' group by Dept")


<�������� Like = >
<�� �ڷ� %�� ����ϸ� �𸣴� �κ� ��ŵ>

sqldf("select * from ucb where Gender Like 'Fe%'")
sqldf("select * from ucb where Gender Like '%male%'")  #male,female�� ���� ���� �ȴ�.

<_ �� �ϳ��� �� ��>
sqldf("select * from ucb where Gender Like '_ale'")

#Sub-query ���
<��ø��>
  
sqldf("select Dept from ucb where Freq=(select max(Freq) from ucb where Admit = 'Admitted')")
#where �󵵰� ���� ���� select Dept������ ã�ƶ�.

sqldf("select Dept from ucb where Freq=(select max(Freq) from ucb where Gender='Female')")

<���� �߽���, ������>
majors <- read.csv("majors.csv")

<inner join- ���ʿ� ��� �ִ� �����͸� ����>
<�� �� �����ϴ� �����͸� ������---- innerjoin on >
sqldf("select* from ucb inner join majors on ucb.Dept = majors.Dept")

<���� ����>
sqldf("select* from ucb left join majors on ucb.Dept=majors.Dept")

#####Right join �� full outer join �� ���� �������� ����