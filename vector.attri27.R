# 9/27 vector attri

library(sf)
library(terra)
library(dplyr)
library(spData)
library(tidyverse)

# sf클래스는 공간, 비공간 데이터를 동일한 방식으로 저장함   
# sf는 하나의 속성변수(ex: name)당 하나의 열(column), 하나의 feature or 관측치 당 하나의 row(행)을 가짐 
# 일반적인 함수(generics)를 가짐 /  aggregate(), cbind(), merge(), rbind() 및 [같은 df 조장, 혹은 범용적인 함수들 
# / 여기까지는 sf, df가 거의 같음
# 그러나 sf는 a range of geographic entities를 가지는 sfc클래스의 geometry열을 가짐 / wkt, wkb
# sf는 Tidyverse랑 호환됨/tbl, tbl_df등의 클래스 /  data.table와 호환은 되지만 완전히는 아님

s <- st_sf(data.frame(n = world$name_long), g = world$geom) # data.frame(n = world$name_long)만하면 그냥 df
s                                                           #  x <- sf[]는 geom 가지고(sf class), xx <- sf$m 은 geom없음(df class) 
class(world)   #  "sf"         "tbl_df"     "tbl"        "data.frame"
dim(world)   # 177 행   11 열

world_df <- st_drop_geometry(world)  # geomery 제거거
class(world_df)  #  "tbl_df"     "tbl"        "data.frame"
ncol(world_df) # 10 ,  geom 열 사라짐짐

# Tidyverse 쓸때 조심 해야함, geom의 변형, 유실, 일관성 유지등에 신경쓰고 sf > df >sf > df,,,일때  geom 유지에 신경
# sf는 새 열이 들어오면 자동적으로 geom를 첨가함, geom를 제거 할거면 명시적으로 확인 해 줘야함
world[,c(T,F,F,F,T,F,F,F,T,T,T)] # 논리 연산자 사용 가능 / 열수에 갯수 맞춰야 되는듯/ 
# geom는 F 해도 다른 열에 딸려 오는 거라서 같이 포함 되는듯

i_small <- world$area_km2 < 10000  # $ 사용해서(geom 없음) T,F유무 판단 > logical 클래스 생성
summary(i_small)                   # world[world$area_km2 < 10000,] 이렇게 가져오면 전부 다 가져와버림 
world[i_small,]  # i_small의 순서은 world 행의 순서랑 같음음      \ >  world[i_small,]랑 같은값















