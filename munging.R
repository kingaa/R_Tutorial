## .folder {

## 	color: #3333ff;

##     font-weight: bold;

## }



library(reshape2)

x <- data.frame(a=letters[1:10],b=1:10,
                c=sample(LETTERS[1:3],10,replace=TRUE),d=sample(1:10,10,replace=TRUE))
x
melt(x,id.vars=c("a","b"))
melt(x,measure.vars=c("c","d")) -> y; y

dcast(y,a+b~variable) -> d1; d1
class(d1)
acast(y,b~variable) -> a1; a1
class(a1); dim(a1)
acast(y,a~b~variable) -> a2; a2
class(a2); dim(a2)

library(plyr)

x <- data.frame(a=letters[1:10],b=runif(10),c=sample(LETTERS[1:3],10,replace=TRUE))
arrange(x,a,b,c)
arrange(x,b,c,a)
arrange(x,c,b,a)

read.csv("https://kingaa.github.io/R_Tutorial/data/energy_production.csv",comment="#") -> energy
arrange(energy,region,source,year)
arrange(energy,-TJ,year)

count(x,~c)
count(x,~a+c)
count(x,vars=c('a','c'))

count(energy,~source+region)
count(energy,~source+TJ)

summarize(x,mean=mean(b),sd=sd(b),top=c[1])

summarize(energy,tot=sum(TJ),n=length(TJ))
summarize(energy,range(year))
summarize(energy,min(year),max(year),interval=diff(range(year)))

x <- mutate(x,d=2*b,c=tolower(c),e=b+d,a=NULL); x

subset(x,d>1.2)
subset(x,select=c(b,c))
subset(x,select=-c(d))
subset(x,d>1.2,select=-e)
subset(energy,year>2010,select=c(source,TJ))
subset(energy,year>2010&source%in%c("Nuclear","Oil"),select=-source)

x <- expand.grid(a=1:3,b=1:5)
y <- expand.grid(a=1:2,b=1:5,c=factor(c("F","G")))
m1 <- merge(x,y); m1
m2 <- merge(x,y,by='a'); m2
m3 <- merge(x,y,all=TRUE); m3
m4 <- merge(x,y,by='a',all=TRUE); m4

join(x,y,by=c('a','b'),type='left')
join(x,y,by=c('a','b'),type='right')
join(x,y,by=c('a','b'),type='inner')
join(x,y,by=c('a','b'),type='full')
join(x,y,by='a',type='full')
join(x,y,by='a',type='inner')

x <- ddply(energy,~region+source,subset,TJ==max(TJ)); x
x <- ddply(energy,~region+source,summarize,TJ=mean(TJ)); x

daply(energy,~region,function(df) sum(df$TJ))
daply(energy,~region+source,function(df) sum(df$TJ))

dlply(energy,~region,summarize,TJ=sum(TJ))

mutate(energy,time=year-min(year)) -> dat
daply(dat,~source+region,function(df) min(df$time)) -> A; A
aaply(A,1,max)

x <- rename(energy,c(TJ='energy',year="time")); head(x)

mutate(energy,region=revalue(region,c(`Asia and Oceania`="Asia",
                                      `Central and South America`="Latin.America"))); 

mutate(energy,source=mapvalues(source,from=c("Coal","Gas","Oil"),
                               to=c("Carbon","Carbon","Carbon")))

library(magrittr)

energy %>% 
  subset(year>=1990) %>%
  ddply(~source+year,summarize,TJ=sum(TJ)) %>%
  ddply(~source,summarize,TJ=mean(TJ))
