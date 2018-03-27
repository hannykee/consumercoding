#0327 r

#SQL 정형데이터 (field를 갖춘 데이터-데이터프레임(숫/논리/문자형))
#DB 구축 시 구조화된 질의어 #Structured Query Language 구조화된 질문 언어)
#SELECT 변수 FROM 데이터 WHERE 조건


#데이터 정의 언어 DDL
CREATE 정의
DROP 개제삭제
ALTER 정의 변경

#데이터 조작 언어 DML
INSERT 행데이터/테이블 데이터 삽입
UPDATE 업데이터
DELETE 테이블 특정 행 삭제

#데이터 제어 언어 DCL
COMMIT 트랜젝션 실행
ROLLBACK 트랜젝션의 취소


install.packages("sqldf")
library(sqldf)



warpbreaks

alr = head(warpbreaks)
alr

<limit> 여기까지만 끊어라!
als = sqldf('select* from warpbreaks limit 6')
## 안에 작은따옴표가 들어가면 큰 따옴표로 묶어줌.

identical(alr,als)  
#두 개의 변수가 동일한지

<문자형,숫자형 like>
a2s <- sqldf("select* from warpbreaks where tension like 'L'")
a2s

<복수 선택 시 in () 사용>
a3s <- sqldf("select* from warpbreaks where tension in ('M','H')")
a3s

<숫자형에서만 사용 , between>
a4s <- sqldf("select* from warpbreaks where breaks between 20 and 30")

<변수 = 등호로 사용>
a5s <- sqldf("select* from warpbreaks where wool = 'A'")
a5s

<rbind 합치기>
a6s <- sqldf("select* from warpbreaks where wool = 'B'")
a7s <- rbind(a5s,a6s)
a7s


<union 변수로 합치기>
a7r <- sqldf("select* from a5s union all select * from a6s")
### union all
a7r

identical(a7s,a7r)

<order by- 숫자형, 기본문자형>
<내림차순 정렬-filter,arrange와 결합  #오름차순은 desc인자만 생략하면 default값>
a8s = sqldf("select* from warpbreaks where tension = 'L' order by breaks desc")
a8s

<데이터 변수의 종류 확인하기>
sqldf('select distinct wool from a8s')

<내림차순에서 limit주기>
a10s <- sqldf("select* from warpbreaks order by breaks desc limit 10")
a10s
<오름차순에서 limit주기>
a11s <- sqldf("select* from warpbreaks order by breaks limit 10")
a11s

<텐션에 따라서 breaks의 평균 구하기>
a8s <- sqldf('select tension, avg(breaks) from warpbreaks group by tension')
a8s

<변수명 새로 설정하기>
Gavg <- sqldf("select tension, avg(breaks) as avg_v from warpbreaks group by tension")
Gavg


<from 다음 데이터가 여러개 존재할 수 있다. r의 $변수명이 .변수명 으로 사용된다.)>
a12s <- sqldf("select warpbreaks.breaks,warpbreaks.wool,warpbreaks.tension from warpbreaks,Gavg
               where warpbreaks.tension=Gavg.tension and warpbreaks.breaks >avg_v")
a12s



setwd("c://data")
ucb= read.csv("ucb.csv")
ucb

<select 로 함수 계산하기>

sqldf("select sum(Freq) from ucb where Admit='Admitted'")

sqldf("select sum(Freq) from ucb where Admit='Rejected'")
<이름 다르게, Where 다음에도 몇개의 조건문이 들어갈 수 있다.>
sqldf("select sum(freq) as total_dudes from ucb where Admit = 'Admitted' AND Gender='Male'")

sqldf("select sum(Freq) as total_ladies from ucb where Admit = 'Rejected' AND Gender='Female'")

<Group by-그룹으로 묶어서 결과 도출 !!! 변수 이름 바꾸기>
sqldf("select Dept, avg(Freq) as average_admitted from ucb where Admit='Admitted' group by Dept")


<문자형은 Like = >
<앞 뒤로 %를 사용하면 모르는 부분 스킵>

sqldf("select * from ucb where Gender Like 'Fe%'")
sqldf("select * from ucb where Gender Like '%male%'")  #male,female이 전부 들어가게 된다.

<_ 는 하나를 모를 때>
sqldf("select * from ucb where Gender Like '_ale'")

#Sub-query 사용
<중첩문>
  
sqldf("select Dept from ucb where Freq=(select max(Freq) from ucb where Admit = 'Admitted')")
#where 빈도가 제일 높은 select Dept변수를 찾아라.

sqldf("select Dept from ucb where Freq=(select max(Freq) from ucb where Gender='Female')")

<교수 중심의, 데이터>
majors <- read.csv("majors.csv")

<inner join- 양쪽에 모두 있는 데이터만 결합>
<둘 다 존재하는 데이터만 합쳐짐---- innerjoin on >
sqldf("select* from ucb inner join majors on ucb.Dept = majors.Dept")

<왼편 기준>
sqldf("select* from ucb left join majors on ucb.Dept=majors.Dept")

#####Right join 과 full outer join 은 현재 존재하지 않음