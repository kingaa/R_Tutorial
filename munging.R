library(tidyr)

data.frame(
  a=letters[1:10],
  b=1:10,
  c=sample(LETTERS[1:3],10,replace=TRUE),
  d=sample(1:10,10,replace=TRUE)
) -> x
x

pivot_longer(x,c(b,d))
pivot_longer(x,-c(a,c)) -> y; y
## pivot_longer(x,-a)

pivot_wider(y)

course.url <- "https://kinglab.eeb.lsa.umich.edu/480/data/"
read.csv(file.path(course.url,"energy_production.csv"),comment="#") -> energy

head(energy)

head(pivot_wider(energy,names_from=source,values_from=TJ))

unite(x,ab,a,b) -> z; z
separate(z,ab,into=c("a","b"))

unite(energy,src_reg,source,region,sep="/") -> nrg
head(nrg)

library(dplyr)

arrange(x,a)
arrange(x,c)
arrange(x,c,b,a)
arrange(x,c,-b)

arrange(energy,year,region,source)
arrange(energy,-TJ,region)

filter(x,d>4)
filter(x,d>1.2 & c != "B")

filter(energy,year>2010)
filter(energy,year>2010 & source%in%c("Nuclear","Oil"))

select(x,a,b)
select(x,-c)
select(x,z=a,d)

select(energy,src=source,year)

summarize(x,mean=mean(b),sd=sd(b),top=c[1])

summarize(energy,tot=sum(TJ),n=length(TJ))
summarize(energy,min(year),max(year))
summarize(energy,min(year),max(year),interval=diff(range(year)))

reframe(x,b=fivenum(b),d=fivenum(d))

reframe(energy,p=c(0.1,0.5,0.9),q=quantile(TJ,probs=p))

mutate(x,d=2*b,c=tolower(c),e=b+d) -> z; z
transmute(x,d=2*b,c=tolower(c),e=b+d)

mutate(energy,hydrocarbon=(source%in%c("Coal","Gas","Oil"))) -> nrg
nrg

count(x,c)
count(x,a,c)

count(energy,source,region)
count(energy,source,TJ)

mutate(
  energy,
  region=plyr::revalue(
                 region,
                 c(
                   `Asia and Oceania`="Asia",
                   `Central and South America`="Latin.America"
                 )
               )
) -> z
head(z)

mutate(
  energy,
  source=plyr::mapvalues(
                 source,
                 from=c("Coal","Gas","Oil"),
                 to=c("Carbon","Carbon","Carbon")
               )
) -> z
head(z)

mutate(
  energy,
  source=recode(
    source,
    Coal="Carbon",
    Gas="Carbon",
    Oil="Carbon"
  )
) -> z
head(z)

group_by(energy,source) -> z
summarize(z,TJ=mean(TJ))

group_by(energy,source,region) -> z
summarize(z,TJ=max(TJ))

x <- expand.grid(a=1:3,b=1:5); head(x)
y <- expand.grid(a=1:2,b=1:5,c=factor(c("F","G"))); head(y)

left_join(x,y,by=c('a','b'))
right_join(x,y,by=c('a','b'))
inner_join(x,y,by=c('a','b'))
full_join(x,y,by=c('a','b'))
full_join(x,y,by='a')
inner_join(x,y,by='a')

categories <- data.frame(
  source=c("Coal","Oil","Nuclear","Gas","Hydro","Other Renewables"),
  cat=c("dirty","dirty","dirty","dirty","clean","clean"))
left_join(energy,categories) -> nrg

energy |> 
  filter(year>=1990) |>
  group_by(source,year) |>
  summarize(TJ=sum(TJ)) |>
  ungroup() |>
  group_by(source) |>
  summarize(TJ=mean(TJ))

energy |> 
  filter(year>=1990) |>
  group_by(region,source) |>
  summarize(TJ=mean(TJ)) |>
  ungroup() |>
  group_by(source) |>
  reframe(
    region=region,
    fraction=TJ/sum(TJ)
  ) |>
  ungroup() |>
  pivot_wider(names_from=source,values_from=fraction)

energy |>
  left_join(categories,by="source") |>
  group_by(region,year,cat) |>
  summarize(TJ=sum(TJ)) |>
  ungroup() |>
  group_by(region,cat) |>
  mutate(change=TJ-lag(TJ,1)) |>
  filter(year>=1990) |>
  summarize(increase=mean(change)) |>
  pivot_wider(names_from=cat,values_from=increase) |>
  mutate(
    overall=clean+dirty,
    factor=dirty/clean
  ) |>
  ungroup()
