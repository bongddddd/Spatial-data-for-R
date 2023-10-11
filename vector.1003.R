# 10/3 
library(sf)
library(terra)
library(spData)
library(dplyr) # 대부분의 함수가 df를 반환
# 연산자 &, |, ! logical operators And, Or, Not / != Not equal to
#쿼리(Query)는 df나 데이터 집함으로부터 정보를 요청하거나 검색하기 위해사용하는 "요청" or "질문"


sma <- world[world$area_km2 < 10000, ]   # sma == sma2
sma2 <- subset(world, area_km2 < 10000)   # [], <라는 기본기능으로 subset함수의 기능 구현

sel <- select(world, pop, name_long)  # select로 원하는 열 선별, selcet(data, col, col,,,) 
sel2 <- world[,c("pop", "name_long")] #world$pop,world$name_long 대신 " "안에 col 넣어야 함 / sel == sel1

con_sel <- select(world, pop:name_long) # : 연산자로 1:10 열 가져오는데 처럼 사용
rev_sel <- select(world, -pop, -name_long) # -col로 필요없는열 제거
ren_sel <- select(world, name_long, population = pop) # pop열 이름 변경, new_name = old_name

names(sel)[names(sel) == "pop"] <- "population" # 17줄은 12줄 + 19줄과 같은 것을 만듬 > select의 효율성

pull(world, "pop") # == world$pop, == world[["pop]] / geom 없이 열 벡터 반환환
world[["pop"]] # []연산자는 df에서 하위 집합(== subset)을 선택하는데 사용됨

slice(world, 1:2) # 행의 select

### "pipe" operator (연결 연산자) |> or %>%

ch_world <- world %>%          # pipe를 이용한 연결결
  filter(continent == "Asia") %>%
  select( "name_long", "continent") %>%     # 위 > 아래/ 왼 > 오른쪽으로 전달
  slice(1:6)  # 범위 설정 안해주면 모든행 잘라 버리는 듯 / slice, select 동일일
ne_world <- slice(  
  select(                               # nest하게 작성, 복잡하고 알기 힘듬듬
    filter(world,continent == "Asia"),  # 걍 기본적인 함수처럼 쓰는듯
     name_long, continent),        # function(df, 조건) 이런 느낌낌
     1:6)   #  필터는 df,조건으로 선별된 df 를 selcet의 df위치에 반환 , select를 걸친 df는 slice의 df에 반환환
in_worldf <- filter(world, continent == "Asia")  # multiple self-contained lines
in_worlds <- select(in_worldf, name_long, continent)  # 여러가지 독립적인 줄로 나눔
in_worldsl <- slice(in_worlds, 1:6)  # 디버깅 편함, 대화형 데이터 분석은 힘듬(interactive data)
# ch_world == ne_world == in_worldsl
world_agg1 <- aggregate(pop ~ continent, FUN = sum,  data = world, na.rm = TRUE)  # aggregate(formula, data, FUN, ...) / class == df
# data에 df(데이터를 직접?)를 전달하면 df로 반환함
# pop ~ continent에서 ~는 뒤의 열(continent)에 따라 그룹화하고 앞의 열(pop)을 집계하라는 뜻
# FUN = 은 집계 방식 지정, 여기선 합계(sum), na.rm은 결측값(NA)제거(remove)
class(world_agg1)  # df임, aggregate는 data.frame형식으로 정보를 반환함? generic function임임
# aggregate는 입력에 따라 다르게 동작하는 일반함함수임(generic function)
# generic function은 다양한 데이터 유형 or 클래스의 객체에 대한 동작을 다형성(polymorphism)을 통해 제공
# 이러한 함수는 서로 다른 유형의 입력을 처리하고, 이에따라 다른 동작을 수행함 ### 다형성이 먼지는 다음에,, ㅋㅋ 귀찮아아
# R은 polymorphism을 지원하기 위해 S3, S4 method를 지원함 / ex) print(1) 숫자출력, print("R") 문자열 출력
world_agg2 <- aggregate(world["pop"],by = list(world$continent), FUN = sum, na.rm = TRUE)  # class == df, sf
# aggregate(x, by, FUN, ...) x는 집계할 데이터, by는 그룹화 방식
# data(위에선 x인듯?)에 데이터의 subset or 데이터의 열을 전달하면 입력 데이터의 클래스를 따라감감
class(world_agg2)
# group_by랑 summarize로 aggregate 구현  ### world_gs == world_agg2
world_gs <- world %>%
  group_by(continent) %>%   # continent로 묶인(그룹화)것 - continent열의 같은 값을 가진 데이터들이 하나의 집합으로로 묶임
  summarize(pop = sum(pop, na.rm = TRUE)) # 그룹화되는 열을 기준으로 행들을 묶음 > 다른 열들은 여전히 사용 가능 > 이를 이용해 기준 설정

#  "world" 데이터 프레임에서 대륙별로 인구(pop), 면적(area_km2), 그리고 국가의 수(n())를 계산하여 "world_agg4" 데이터 프레임

world_gs1 <- world %>%
  group_by(continent) %>%
  summarise(pop = sum(pop, na.rm = TRUE), area_km2 = sum(area_km2), N = n()) # n()은 현재 그룹의 관찰치 갯수를 반환함함
class(world_gs1)

# 국가별로 대륙을 기준으로 인구 밀도를 계산하고 국가 수에 따라 대륙을 정렬하며, 인구가 가장 많은 상위 3개 대륙

world_top3 <- world %>%
  st_drop_geometry() %>% # 속도향상 + 이거없으면 sf로 정보 봐야됨 불편,,,
#  select(pop, continent, area_km2)  # 필요한것만만
  group_by(continent) %>%  # 대륙 기준
  summarise(pop = sum(pop, na.rm = TRUE), areaa = sum(area_km2), N = n()) %>% # 대륙별 인구, 영토, 국가수
  mutate(Densityd = round(pop/areaa, digits = 0)) %>%  # round로 반올림 해줌줌 # 인구비율
  slice_max(pop,n = 3) %>%  # n = 안넣으니까 에러나더라? # 상위 3개국국
  arrange(desc(N)) # arrange > 주어진 열의 값을 기준으로 데이터 정렬/ desc 내림차순순 # 국가수로 정렬렬
  
world_top3
  

?round
















