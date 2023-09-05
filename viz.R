set.seed(594709947L)
library(ggplot2)
theme_set(theme_bw())

dat <- read.csv("https://kingaa.github.io/R_Tutorial/data/mosquitoes.csv")

wt <- subset(dat,type=="wildtype",select=lifespan)
tg <- subset(dat,type=="transgenic",select=-type)

dat$type <- factor(dat$type)
plot(dat)
op <- par(mfrow=c(1,2))
hist(tg$lifespan,breaks=seq(0,55,by=5),ylim=c(0,40))
hist(wt$lifespan,breaks=seq(0,55,by=5),ylim=c(0,40))
par(op)

plot(sort(dat$lifespan),seq(1,nrow(dat))/nrow(dat),type='n')
lines(sort(wt$lifespan),seq(1,nrow(wt))/nrow(wt),type='s',col='blue')
lines(sort(tg$lifespan),seq(1,nrow(tg))/nrow(tg),type='s',col='red')

library(MASS)

plot(mammals)
plot(mammals,log='x')
plot(mammals,log='xy')
plot(mammals$body,mammals$brain,log='xy')
plot(brain~body,data=mammals,log='xy')

read.csv(
  "https://kingaa.github.io/R_Tutorial/data/oil_production.csv",
  comment.char="#"
) -> oil
head(oil)
summary(oil)
plot(oil)
plot(Gbbl~year,data=oil,subset=region=="North.America",type='l')
lines(Gbbl~year,data=oil,subset=region=="Eurasia",type="l",col='red')

library(tidyr)
library(dplyr)

oil |>
  group_by(year) |>
  summarize(Gbbl=sum(Gbbl)) -> total
plot(Gbbl~year,data=total,type='l')

library(readr)
read_csv(
  "https://kingaa.github.io/R_Tutorial/data/energy_production.csv",
  comment="#"
) -> energy

library(ggplot2)

ggplot(data=energy,mapping=aes(x=year,y=TJ,color=region,linetype=source))+
  geom_line()
ggplot(data=energy,mapping=aes(x=year,y=TJ,color=region))+
  geom_line()+
  facet_wrap(~source)
ggplot(data=energy,mapping=aes(x=year,y=TJ,color=source))+
  geom_line()+
  facet_wrap(~region,ncol=2)

ggplot(data=energy,mapping=aes(x=year,y=TJ))+
  geom_line()
ggplot(data=energy,mapping=aes(x=year,y=TJ,group=source))+
  geom_line()

ggplot(data=energy,mapping=aes(x=year,y=TJ,group=interaction(source,region)))+
  geom_line()

energy |>
  group_by(year,source) |>
  summarize(TJ=sum(TJ)) |>
  ungroup() -> tot

tot |>
  ggplot(aes(x=year,y=TJ,color=source))+
  geom_line()

tot |>
  ggplot(aes(x=year,y=TJ,fill=source))+
  geom_area()

energy |>
  group_by(region,source) |>
  summarize(TJ=mean(TJ)) |>
  ungroup() -> reg

reg |>
  ggplot(aes(x=region,y=TJ,fill=source))+
  geom_bar(stat="identity")+
  coord_flip()

reg |>
  group_by(region) |>
  mutate(frac = TJ/sum(TJ)) |>
  ungroup() -> reg

reg |>
  ggplot(aes(x=region,y=frac,fill=source))+
  geom_bar(stat="identity")+
  coord_flip()+
  labs(y="fraction of production",x="region")

data.frame(
  source=c("Coal","Gas","Oil","Nuclear","Hydro","Other Renewables"),
  source1=c("Carbon","Carbon","Carbon","Nuclear","Renewable","Renewable")
) |>
  right_join(energy,by="source") -> energy

energy |>
  group_by(source1,region,year) |>
  summarize(TJ = sum(TJ)) |>
  ungroup() -> x

x |>
  ggplot(aes(x=year,y=TJ,fill=source1))+
  geom_area()+
  facet_wrap(~region,ncol=2)+
  labs(fill="source")

x |>
  ggplot(aes(x=year,y=TJ,fill=source1))+
  geom_area()+
  facet_wrap(~region,scales="free_y",ncol=2)+
  labs(fill="source")

x |>
  group_by(source1,year) |>
  summarize(TJ = sum(TJ)) |>
  ungroup() -> y

y |>
  ggplot(aes(x=year,y=TJ,fill=source1))+
  geom_area()+
  labs(fill="source")
