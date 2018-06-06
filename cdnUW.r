
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

# Translate 'headlines' dataframe to character array 'docArray': Character Array with each element
# containing all headlines for a given year. (One array element per year)
# *CREDIT* https://stackoverflow.com/questions/28305685/get-column-from-list-of-dataframes-r
docArray <- sapply(
              sapply(split(headlines,headlines$Year),'[[',1)
              ,as.character)

#create generic cleanup jobs and top word count function or Deep Dive

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

getTop10WrdCnt <- function(x){head(sort(rowSums(as.matrix(TermDocumentMatrix(
                                      sweepTxt(Corpus(VectorSource(x)))
                                          )))
                                  ,decreasing = TRUE),10)
  }

# Initiate Corpus
myCorp <- Corpus(VectorSource(docArray))

# COMPARISON CLOUD

tdm <- as.matrix(TermDocumentMatrix(sweepTxt(myCorp)))
colnames(tdm) <- c(2018:2009)

x11() #x-eleven
comparison.cloud(tdm[,2:9], random.order=F
                 ,max.words=200
                 #,min.freq=5
                 ,scale=c(4,0.5) #max,min font size
                 #,colors=rainbow(12)
                )
# WORD CLOUD

x11()
wordcloud(sweepTxt(Corpus(VectorSource(docArray[[1]]))), random.order=F
                 ,max.words=200
                 ,min.freq=5
                 ,scale=c(4,0.5) #max,min font size
                 ,colors=rainbow(5)
)

# Deep Dives
findAssocs(TermDocumentMatrix(sweepTxt(Corpus(VectorSource(docArray[[2]])))),'payments',0.3)
getTop10WrdCnt(docArray[[1]]) #user defined above

# SENTIMENT

# load pos/neg Opinion Lexicon

   # Minqing Hu and Bing Liu. "Mining and Summarizing Customer Reviews." 
   #     Proceedings of the ACM SIGKDD International Conference on Knowledge 
   #     Discovery and Data Mining (KDD-2004), Aug 22-25, 2004, Seattle, 
   #     Washington, USA, 
   # Bing Liu, Minqing Hu and Junsheng Cheng. "Opinion Observer: Analyzing 
   #     and Comparing Opinions on the Web." Proceedings of the 14th 
   #     International World Wide Web conference (WWW-2005), May 10-14, 
   #     2005, Chiba, Japan.

# Two methods, same results
posWords <- read.table("C:\\Users\\trunk\\Downloads\\BigData\\python\\positive-words.txt", stringsAsFactors = F)$V1
negWords <- scan("C:\\Users\\trunk\\Downloads\\BigData\\python\\negative-words.txt",what='character')

# From array of annual headlines (docArray), create array of annual words from headlines (WrdBagList)
WrdBagList <- lapply(docArray[2:9],function(x){strsplit(paste(sweepTxtArray(x),collapse=' '),split=' ')[[1]]})

# create dataframe that tallies difference between pos/neg words per year
sentDF <- data.frame(Yr=as.factor(2017:2010)
                     ,sentiment = sapply(WrdBagList,function(x){
                          sum(!is.na(match(x,posWords)))-sum(!is.na(match(x,negWords)))}
                          ))
# Plot above dataframe
x11()
ggplot(data=sentDF,aes(x=Yr,y=sentiment,group=1))+
        geom_line(color='blue')+geom_point()+
        geom_hline(aes(yintercept=0))+
        ggtitle('Canadian Underwriter insPRSS Headline Sentiments')
            
#################################  SAND #################################
#################################   BOX #################################

a <- 'alina is sick today today is thursday today today today alina today alina today alina'
b <- strsplit(a,' ')[[1]]
b <- unlist(strsplit(a,split=' '))
wordcloud(b,random.order=F)
?getText()

sweepTxtArray(docArry[[1]])
