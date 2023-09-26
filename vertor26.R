#9/26일일
library(sf)

p1 <- st_point(c(1,2))  # sfg를 한 열에 박은거 sfc
p2 <- st_point(c(2,3)) # sfc는 주로 동일한 유형의 sfg를 묶음음
p_sfc <- st_sfc(p1, p2)
p_sfc

mp1 <- list(rbind(c(1, 5), c(2, 2), c(4, 1), c(4, 4), c(1, 5)))
mmp1 <- st_polygon(mp1)
mp2 <- list(rbind(c(0, 2), c(1, 2), c(1, 3), c(0, 3), c(0, 2)))
mmp2 <- st_polygon(mp2)
mpp <- st_sfc(mmp1,mmp2)
st_geometry_type(mpp)

multilinestring_list1 = list(rbind(c(1, 5), c(4, 4), c(4, 1), c(2, 2), c(3, 2)), 
                             rbind(c(1, 2), c(2, 4)))
multilinestring1 = st_multilinestring((multilinestring_list1))
multilinestring_list2 = list(rbind(c(2, 9), c(7, 9), c(5, 6), c(4, 7), c(2, 7)), 
                             rbind(c(1, 7), c(3, 8)))
multilinestring2 = st_multilinestring((multilinestring_list2))
multilinestring_sfc = st_sfc(multilinestring1, multilinestring2)
st_geometry_type(multilinestring_sfc)  # geometry type 확인

mpp1 <- st_sfc(mmp1,mmp2,multilinestring1, multilinestring2) # 다른 타입의 sfg 섞는것도 가능

st_crs(mpp1)  # crs확인 default값은 NA

mpp <- st_sfc(mmp1,mmp2, crs = "EPSG:4326")  # 인수 crs 추가하는 방식으로 설정 가능능
mpp


install.packages("sfheaders")
library(sfheaders)
# sfheaders - 빠른 sf 객체의 생성, 변환 및 조작에 중점을 둠 / c++ 사용함
# sf가 실행될때와 되지 않을때 결과값이 다름, sf가 없으면 행렬식으로 표시 + 클래스를 띄워줌줌
# sf는 st_로 시작하고 sfheaders는 sfg_ ,sfc_, sf_같이 넣고 싶은 형식을 지정하는 식인듯

c1 <- c(1,2)
shp <- sfheaders::sfg_point(obj = c1)
shp1 <- sfg_point(obj = c1)
shp1

v = c(1, 1)
v_sfg_sfh = sfheaders::sfg_point(obj = v)
v_sfg_sfh

m <- matrix(1:8, ncol = 2)
m
class(m)
sfheaders::sfg_linestring(obj = m)
df <- data.frame(x = 1:4, y = 4:1)
sfheaders::sfg_polygon(obj =df)

sfheaders::sfc_point(obj = v)
sfheaders::sfc_linestring(obj = m)
sfheaders::sfc_polygon(obj = df)
#WKT - well known text 지리정보를 text로 나타내기 위한 국제표준 형식중 하나

sfheaders::sf_point(obj = v)
sfheaders::sf_linestring(obj = m)
sfheaders::sf_polygon(obj = df)

class(v)

# 이러한 설정들은 crs의 default가 NA라서서 crs를 따로 넣어줘야함
st_crs(multilinestring_sfc) <- "EPSG:4326"  # sfheaders에서 지정한 sf는 st_crs 사용 못하는듯
# sfheaders는 sf와의 상호작용을 "추구" 한다고 했음, 아직 다 못만들어서 이런듯?
# sfheaders는 deconstructing(분해)에 좋음, sf가 가진 지리, geom에서 geom를 따로 꺼낼수 있음
# reconstructing(재구성)/ geometry feature ID 정보를 가진 DF 기반으로 sf object를 만들수 있음


# 2.2.9 Spherical geometry operations with S2
# Spherical geometry는 구면 기하학, 지구가 둥글다는 사실을 기반으로 하는 기하학/ 지구의 곡률의 고려함
# sf 는 google의 S2 구면 기하학 엔진과 연동됨 / 이산 전역 그리드 시스템 사용 Discrete Global Grid System, DGGS
# 다양한 해상도, 격자 분할, 계층 구조, 전역범위, 정확한 공간 위치 표현이 가능함 / DGGS 
# 기본적으로 S2는 항상 켜져있으며 sf_use_s2()로 확인 가능, sf_use_s2(FALSE) 할 경우 Spherical 대신 Euclidean가 사용됨 

# 2.6 Exercises
library(spData)
library(ggplot2)
library(raster)

class(world)
world

dd <- world$pop # 그냥 pop의 값이 수열로 들어오네 / class(dd),  [1] "numeric"
ddd <- world["pop"] # geom랑 같이 들어옴옴 / class(ddd) [1] "sf"   "tbl_df" "tbl"   "data.frame"
class(dd)
class(ddd)
head(world)

ggplot(world) + geom_bar(aes(x = iso_a2, y = pop))

ggplot(world) + geom_dotplot(aes(x = iso_a2, y = pop))

ggplot(world) + geom_boxplot(aes(x = iso_a2, y = pop), binwidth = 1/30)

nnn <- world[world$name_long == "Nigeria",] # 나이지리아 가져오기, 행만 선택되게 [ ,] 해줘야됨
nnn
plot(st_geometry(nnn), expandBB = c(0, 0.2, 0.1, 1), col = "gray", lwd = 3) 
# nnn 의 경우 이미 sf 형식이라 st_geometry가 없어도 plot가 생성 되지만 그러면 모든 열 속성 정보(geom 제외) 수 만큼(10개) plot가 생성됨

raster/nlcd.tif






















