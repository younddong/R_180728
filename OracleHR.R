
# file 마다 library load.
#####################################################
## 문제 1 rJava, DBI, RJDBC, dplyr
## 패키지를 호출하시오
#######################################################
library(rJava)
library(DBI)
library(RJDBC)
library(XML)
library(memoise)
library(KoNLP)
library(wordcloud)
library(dplyr)
library(ggplot2)
library(ggmap)
library(rvest)
library(RColorBrewer)
library(data.table)
library(reshape)


#######################################################
## 문제 2 오라클과 Project 를 연결하시오
#######################################################

## jdbc 드라이버 로딩 
## 1차 java - oracle 연결 
drv <- JDBC(
  driverClass = "oracle.jdbc.driver.OracleDriver",
  classPath = "C:\\oraclexe\\app\\oracle\\product\\11.2.0\\server\\jdbc\\lib\\ojdbc6.jar"
)

## 2차 oracle - R 연결 
conn <- dbConnect(drv,
                  "jdbc:oracle:thin:@localhost:1521:xe",
                  "hr",
                  "hr")
dbGetQuery(conn, "SELECT * FROM TABS")




#######################################################
## 문제 3 오라클의 테이블을 조회하시오
####################################################### 
tab <- dbGetQuery(conn, "SELECT * FROM TAB")
tname <- tab$TNAME
tname




#######################################################
## 문제 4 오라클의 각 테이블을 데이터프레임으로 전환하시오
## 데이터프레임의 이름은 다음과 같이 하시오.
## COUNTRIES -> cnt
## DEPARTMENTS -> dep
## EMPLOYEES -> emp
## EMP_DETAILS_VIEW -> empd
## JOBS -> job
## JOB_HISTORY -> jobh
## LOCATIONS -> loc
## REGIONS -> reg
#######################################################
cnt <- data.frame(dbGetQuery(conn, "select * from COUNTRIES"))
View(cnt)

dep <- data.frame(dbGetQuery(conn, "select * from DEPARTMENTS"))
View(dep)

emp <- data.frame(dbGetQuery(conn, "select * from EMPLOYEES"))
View(emp)

empd <- data.frame(dbGetQuery(conn, "select * from EMP_DETAILS_VIEW"))
View(empd)

job <- data.frame(dbGetQuery(conn, "select * from JOBS"))
View(job)

jobh <- data.frame(dbGetQuery(conn, "select * from JOB_HISTORY"))
View(jobh)

loc <- data.frame(dbGetQuery(conn, "select * from LOCATIONS"))
View(loc)

reg <- data.frame(dbGetQuery(conn, "select * from REGIONS"))
View(reg)


emp %>%
  select(everything())

# 
# EMPLOYEE_ID
# FIRST_NAME
# LAST_NAME
# EMAIL
# PHONE_NUMBER
# HIRE_DATE
# JOB_ID
# SALARY
# COMMISSION_PCT
# MANAGER_ID
# DEPARTMENT_ID
#




#######################################################
## 문제 5 cnt 의 컬럼명을 한글로 전환하시오
## 국가아이디 = COUNTRY_ID
## 국가명 = COUNTRY_NAME
## 지역아이디 = REGION_ID
#######################################################

cnt <- cnt %>% 
        dplyr::rename(국가아이디 = COUNTRY_ID,
                      국가명 = COUNTRY_NAME,
                      지역아이디 = REGION_ID)

View(cnt)


#######################################################
## 문제 6 dep 의 컬럼명을 한글로 전환하시오
## 부서아이디 = DEPARTMENT_ID
## 부서명 = DEPARTMENT_NAME
## 매니저아이디 = MANAGER_ID
## 위치아이디 = LOCATION_ID
#######################################################

dep <- dep %>%
        dplyr::rename(부서아이디 = DEPARTMENT_ID,
                      부서명 = DEPARTMENT_NAME,
                      매니저아이디 = MANAGER_ID,
                      위치아이디 = LOCATION_ID)

View(dep)




#######################################################
## 문제 7 emp 의 컬럼명을 한글로 전환하시오.
## 그리고 First Name 과 Last Name 을
## 붙여서 이름 으로 된 컬럼을 추가하시오
## 단, 이름 간격은 띄울것. ex) James Dean
## 직원아이디 = EMPLOYEE_ID
## 이메일 = EMAIL
## 전화번호 = PHONE_NUMBER
## 채용일 = HIRE_DATE
## 업무아이디 = JOB_ID
## 연봉 = SALARY
## 커미션비율 = COMMISSION_PCT
## 매니저아이디 = MANAGER_ID
## 부서아이디 = DEPARTMENT_ID
#######################################################

emp <- emp %>% 
        dplyr::rename(직원아이디 = EMPLOYEE_ID,
                      이메일 = EMAIL,
                      전화번호 = PHONE_NUMBER,
                      채용일 = HIRE_DATE,
                      업무아이디 = JOB_ID,
                      연봉 = SALARY,
                      커미션비율 = COMMISSION_PCT,
                      매니저아이디 = MANAGER_ID,
                      부서아이디 = DEPARTMENT_ID)

emp <- emp %>%
        dplyr::mutate(이름 = paste(FIRST_NAME, ' ', LAST_NAME)) # 띄어쓰기 안해도 된듸야


View(emp)

#######################################################
## 문제 8  emp 의 First Name 과 Last Name 컬럼 두개를
## 삭제하시오.
#######################################################

head(emp)
emp 
empp <- emp %>% 
        dplyr::select(직원아이디, 
                      이름, 
                      이메일, 
                      전화번호, 
                      채용일, 
                      업무아이디, 
                      연봉, 
                      커미션비율, 
                      월급, 
                      매니저아이디, 
                      부서아이디)

View(empp)


if(is.data.frame(emp)) {
  emp <- subset(emp, select = -c(FIRST_NAME, LAST_NAME))
}

View(emp)


#######################################################
## 문제 9
## 매달 지급하는 월급여(연봉 / 12)를 보여주는
## 월급 이라는 컬럼을
## 추가시키시오.(0단위 절삭)
#######################################################

emp <- emp %>%
  dplyr::mutate(월급 = 연봉 %/% 12)

View(emp)




#######################################################
## 문제 10 job 의 컬럼명을 한글로 전환하시오
## 업무아이디 = JOB_ID
## 업무명 = JOB_TITLE
## 최소연봉 = MIN_SALARY
## 최대연봉 = MAX_SALARY
#######################################################

job <- job %>% 
        dplyr::rename(업무아이디 = JOB_ID,
                      업무명 = JOB_TITLE,
                      최소연봉 = MIN_SALARY,
                      최대연봉 = MAX_SALARY)

View(job)




#######################################################
## 문제 11 jobh 의 컬럼명을 한글로 전환하시오
## 직원아이디 = EMPLOYEE_ID
## 업무시작일 = START_DATE
## 업무종료일 = END_DATE
## 업무아이디 = JOB_ID
## 부서아이디 = DEPARTMENT_ID
#######################################################

jobh <- jobh %>% 
          dplyr::rename(직원아이디 = EMPLOYEE_ID,
                        업무시작일 = START_DATE,
                        업무종료일 = END_DATE,
                        업무아이디 = JOB_ID,
                        부서아이디 = DEPARTMENT_ID)

View(jobh)

#######################################################
## 문제 12 loc 의 컬럼명을 한글로 전환하시오
# 위치아이디 = LOCATION_ID
# 거리주소 = STREET_ADDRESS
# 우편번호 = POSTAL_CODE
# 도시 = CITY
# 주 = STATE_PROVINCE
# 국가아이디 = COUNTRY_ID
#######################################################

loc <- loc %>% 
        dplyr::rename(위치아이디 = LOCATION_ID,
                      거리주소 = STREET_ADDRESS,
                      우편번호 = POSTAL_CODE,
                      도시 = CITY,
                      주 = STATE_PROVINCE,
                      국가아이디 = COUNTRY_ID)

View(loc)



#######################################################
## 문제 13 reg 의 컬럼명을 한글로 전환하시오
## 지역아이디 = REGION_ID
## 지역명 = REGION_NAME
#######################################################

reg <- reg %>% 
        dplyr::rename(지역아이디 = REGION_ID,
                      지역명 = REGION_NAME)


View(reg)



#######################################################
## 문제 14. 연봉이 10000불 이상인
## 사원(emp)의 목록을 이름, 직원아이디, 연봉을
## 연봉 내림차순으로 보여주세요.
#######################################################


emp %>% 
  dplyr::filter(연봉 >= 10000) %>% 
  dplyr::select(이름, 직원아이디, 연봉) %>% 
  dplyr::arrange(desc(연봉))



#######################################################
## 문제 15. 연봉이 3000 미만인
## 사원에게 보너스로 급여의 1%를 지급하겠다고 합니다
## 대상자의 목록을 이름, 직원아이디, 연봉을 기재하고
## 아이디 오름차순으로 보여주시오. 단 보너스지급내역서
## 라는 이름의 데이터프레임으로 작성한 후 삭제하시오.
## 보너스에는 각 금액에 만원단위를 첨부합니다.
## 힌트: 보너스= sprintf("%0.0f 만원", 연봉*0.01) 사용
## 힌트: rm(보너스지급내역서) 하면 rm 하면 데이터프레임삭제됨
#######################################################

보너스지급내역서 <- data.frame(emp %>% 
                         dplyr::filter(연봉 < 3000) %>% 
                         dplyr::mutate(보너스 = sprintf("%0.0f 만원", 연봉*0.01)) %>% 
                         dplyr::select(이름, 직원아이디, 연봉, 보너스) %>% 
                         dplyr::arrange(직원아이디)
)

View(보너스지급내역서)



## 데이터프레임 CSV 저장
## row.names = TRUE 일 경우, rownum 저장, FALSE 일 경우 rownum 저장 안됨.
getwd()
setwd("C:/Users/Administrator/rlangweekend/Project180728")
write.csv(보너스지급내역서, "보너스지급내역서.csv", row.names=TRUE)
write.csv(보너스지급내역서, "보너스지급내역서11.csv", row.names=FALSE)


## 데이터프레임 삭제 
rm(보너스지급내역서)


#######################################################
## 문제 16. 직원중에서 급여가 가장 높은 사람이
## CEO 라고 합니다. 이름이 무엇입니까?

## 그룹 연산. --> 최대값 / 최소값 / 평균 등등
## 할 때 apply 로 기준을 잡는 것. --> 구조가 숫자로 되어 있어야함. vector와 matrix 에서 사용.

## apply(object, direction, function to apply)
## 적용방향 - 1:가로방향, 2: 세로방향

## sapply / lapply 
#######################################################

ceo_sal <- apply(emp %>%
                   select(연봉), 2, max)

emp %>%
  filter(연봉 == ceo_sal) %>%
  select(이름)



emp %>% 
  dplyr::filter(연봉 == apply(emp %>%
                                select(연봉), 2, max)) %>% 
  dplyr::select(이름)





#######################################################
## 문제 17. 연봉이 10000이 넘는 직원의 부서명, 이름,
## 연봉을 출력하시오.
#######################################################


emp %>% 
  dplyr::filter(연봉 > 10000) %>% 
  dplyr::select(이름, 연봉, 부서명 = dep %>% 
                                      dplyr::filter(dep$부서아이디 == emp$부서아이디) %>% 
                                      dplyr::select(dep$부서명))

# 
# 
# Inner Join :: emp_dep <- merge(x = emp, y = dep, by = '부서아이디')
# Outer Join :: emp_dep <- merge(x = emp, y = dep, by = '부서아이디', all = TRUE)
# Left Outer Join  :: emp_dep <- merge(x = emp, y = dep, by = '부서아이디', all.x = TRUE)
# Right Outer Join :: emp_dep <- merge(x = emp, y = dep, by = '부서아이디', all.y = TRUE)
# 
# 

View(emp_dep)

emp_dep 


