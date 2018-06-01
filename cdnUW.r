
rm(list=ls())
require('tm')
require('wordcloud')
require('ggplot2')

headlines <- read.csv("C:\\Users\\trunk\\Downloads\\BigData\\python\\cdnUWScrape.csv"
                              ,stringsAsFactors = FALSE
                      ,header = FALSE
                     )
names(headlines) <- c('Headline','Date','By')

#create year column
headlines$Year <- sapply(headlines$Date, function(x){as.factor(substr(x,nchar(x)-4,nchar(x)))})

#drop date and by
headlines <- data.frame(Headline=as.character(headlines$Headline)
                        ,Year=headlines$Year
                        )

#create generic cleanup jobs

sweepTxt <- function(x){
  x <-  tm_map(
    tm_map(
      tm_map(
        tm_map(
          tm_map(
            tm_map(x,removePunctuation)
            ,content_transformer(tolower))
          ,removeWords,stopwords('english'))
        ,removeWords,c(' inc ','insurance'
                       ,' ltd ','canada'
                       ,' new ','canadian'))
      ,removeNumbers)
    ,stripWhitespace)
}

sweepTxtArray <-  function(x){content(sweepTxt(Corpus(VectorSource(x))))}

getTopWrdCount <- function(x){head(sort(rowSums(as.matrix(TermDocumentMatrix(
                                      sweepTxt(Corpus(VectorSource(x)))
                                          )))
                                  ,decreasing = TRUE))
}

#credit https://stackoverflow.com/questions/28305685/get-column-from-list-of-dataframes-r
docArray <- sapply(
              sapply(split(headlines,headlines$Year),'[[',1)
              ,as.character)

myCorp <- Corpus(VectorSource(docArray))

tdm <- as.matrix(TermDocumentMatrix(sweepTxt(myCorp)))
colnames(tdm) <- c(2018:2009)

x11() #x-eleven
comparison.cloud(tdm[,2:9], random.order=F
                 ,max.words=200
                 #,min.freq=5
                 ,scale=c(4,0.5) #max,min font size
                 #,colors=rainbow(12)
                )
x11()
wordcloud(sweepTxt(Corpus(VectorSource(docArray[[3]]))), random.order=F
                 ,max.words=200
                 ,min.freq=5
                 ,scale=c(4,0.5) #max,min font size
                 ,colors=rainbow(5)
)

findAssocs(TermDocumentMatrix(sweepTxt(Corpus(VectorSource(docArray[[3]])))),'online',0.3)

getTopWrdCount(docArray[[3]])

#SENTIMENT

#load pos/neg lexicon, 2 ways same result

posWords <- read.table("C:\\Users\\trunk\\Downloads\\BigData\\python\\positive-words.txt", stringsAsFactors = F)$V1
negWords <- scan("C:\\Users\\trunk\\Downloads\\BigData\\python\\negative-words.txt",what='character')

WrdBagList <- lapply(docArray,function(x){strsplit(paste(sweepTxtArray(x),collapse=' '),split=' ')[[1]]})

sentDF <- data.frame(Yr=as.factor(2018:2009)
                     ,sentiment = sapply(WrdBagList,function(x){
                          sum(!is.na(match(x,posWords)))-sum(!is.na(match(x,negWords)))}
                          ))
x11()
qplot(x=Yr,y=sentiment,data=sentDF)

#################################  SAND #################################
#################################   BOX #################################

a <- 'alina is sick today today is thursday today today today alina today alina today alina'
b <- strsplit(a,' ')[[1]]
b <- unlist(strsplit(a,split=' '))
wordcloud(b,random.order=F)
?getText()

sweepTxtArray(docArry[[1]])
