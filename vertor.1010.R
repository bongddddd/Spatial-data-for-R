# 10/10 R attri

library(sf)
library(spData)
library(dplyr)


world_coffee <- left_join(world, coffee_data) # world는 sf, coffee_data는 attri, 둘을 묶어 주는 열은 name_long
world_coffee  # 이름이 같은열 > key variable / 여기서는 name_long / dplyr에서는 이름 같은 열 다 사용함
names(world_coffee)
plot(world_coffee["coffee_production_2017"])
# 일치하지 않을때는 1. rename 2. by를 사용

renamed_coffee <- rename(coffee_data, nm = name_long)
names(renamed_coffee)
world_coffee2 <- left_join(world, renamed_coffee, join_by(name_long == nm))
world_coffee2 # 해당 sfc는 world가 가진 177개의 행을 전부 가지며 coffee_data는 행이 47개 뿐이지만 나머지를 na로 채움움
#world_coffee2 <- left_join(renamed_coffee,world, join_by(nm == name_long )) # 앞의 데이터에 뒤의 데이터를 넣는듯?
#class(world_coffee2) # 그래서 순서를 바꾸면 geom가 사라 지는듯듯

world_coffee_inner <- inner_join(world, coffee_data) # coffee_data랑 일치하는 행만 선별/na로 안채우고 날려버림
nrow(world_coffee_inner) # 45개의 열,, 2개는?

setdiff(coffee_data$name_long, world$name_long) #첫번째 집합에는 있지만 두번째 집합에는 없는값 추출

# 10/11

dcr <- stringr::str_subset(world$name_long,"Dem*.+Congo") # str_subset - 문자열 벡터에서 일치하는 문자열 추출
  # str_subset(str_vector, pattern, negate : 기본값 FULSE, TRUE이면 일치하지 않는거 반환 ) 
  # Dem_으로 시작, *_뒤에 0개 이상의 문자열, .+_ 1번이상 반복, congo 
dcr
# coffee_data[grepl("congo",coffee_data)] <- dcr  # coffee_data 는 df형식
coffee_data$name_long[grepl("Congo", coffee_data)] <- dcr # coffee_data$name_long는 str벡터
world_coffee_inner <- inner_join(world, coffee_data)
nrow(world_coffee_inner)

world_new <- world
world_new$dens <- world$pop/world$area_km2
world_new

world_new2 = world |>   # 위랑 같음음
  mutate(pop_dens = pop / area_km2) # mutate는 새 열을 추가, transmute는 만든값만 추출

library(tidyverse)
library(terra)

world_unite <- world %>%  # 열 두개를 합쳐서(unite) 하나의 새 열을 만듬
  unite("con_rig",continent:region_un, sep = ":", remove = TRUE)
world_unite

world_split <- world_unite %>%  # unite의 반대, remove = 기본값은 TRUE
  separate("con_rig", c("continent", "region_un"), sep = ":",)
world_split
# rename / part or all
world %>% rename(name = name_long)
world %>% setNames(c("i","n","c","r","s","t","a","p","l","gdp","geom"))

elev <- rast(nrows = 6, ncols = 6, xmax = 1.5, xmin = -1.5, ymax =  1.5, ymin = -1.5, vals = 1:36)
elev
plot(elev)

grain <- c("silt", "clay", "sand")  # character class의 함수
grain_char <- sample(grain, 36, replace = TRUE) # sample - grain의 값을 36번 무작위 추출, 반복 허용
grain_fact <- factor(grain_char, levels = grain) # categorical data를 다루는 factor함수(클래스), grain의 값에 level을 달아 범위를 설정
class(grain_char) # character범위가 없는 문자열 벡터 - plot 불과
class(grain_fact) # factor는 내부 categorical vector들의 범위(범주)가 있음! > plot 가능
grain_plot1 <- rast(nrows = 6, ncols = 6, xmax = 1.5, xmin = -1.5, ymax = 1.5, ymin = -1.5, vals = grain_fact)
cats(grain_plot1) # cats(category)는 RAT(Raster Attribute table)을 확인, 검사하는 일을 함
class(grain_plot)
levels(grain_plot) <- data.frame(v = c(1,2,3), mm = c("w","m","d"))
plot(grain_plot)
plot(grain_plot1)

### coltab 래스터파일의 현재 색정 성보를 확인, 설정하고 저장 가능 
values(elev)

# summarizing rater objects / summarize or global

hist(elev)

library(sf)
library(dplyr)
library(terra)
library(spData)
data(us_states)
data(us_states_df)
ncol(us_states)


ex1 <- us_states["NAME"]
ncol(ex1)
ex1.1 <- select(us_states, NAME)
class(ex1.1) # class는 sf, df이고 sf형식의 데이터를 다룰때 geom의 경우 정확히 명시하지 않으면 같이 따라감감

ex2 <- us_states[c("total_pop_10","total_pop_15")]
ex2.1 <- select(us_states,total_pop_10,total_pop_15)
# ex2.2 <- us_states %>% contains("total")  # us_states는 문자열 벡터가 아니다? / contains, matches는 보통 select랑 같이 쓴다네요
ex2.2 <- us_states %>% select(contains("total")) # 문자열 찾기!
ex2.3 <- us_states %>% select(matches("^total")) # 정규 표현식! 메타 문자 사용 가능!
















