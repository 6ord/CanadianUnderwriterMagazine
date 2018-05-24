import re, requests, bs4, csv, datetime    
    

def CAUW_PRSS_Scrape(numPages):
# Canadian Underwiter Headlines
# https://www.canadianunderwriter.ca/inspress/page/2/
# https://www.canadianunderwriter.ca/inspress/
    
    tagPick_HL = '.media-body .headline.media-heading' #Headline
    tagPick_SL = '.media-body .meta' #Subline (date and company)
    output = [] #List, to contain Tuples. Each Tuple representing
                #one (Headline, publish date, publishing entity).

    regex_HL = re.compile(r'^[\s]+|[\s]+$')
    regex_SL_date = re.compile(r'[A-Z]{1}[a-z]{2,8}[ ]{1}\d{1,2},[ ]\d{4}')
    regex_SL_enty = re.compile(r'( by ).+$')
    
    for i in range(1,numPages+1):
        url = 'https://www.canadianunderwriter.ca/inspress/page/'+str(i)+'/'
        mySoup = bs4.BeautifulSoup(requests.get(url).text, 'html.parser')
        numHeadlines = len(mySoup.select(tagPick_HL))
        if numHeadlines==len(mySoup.select(tagPick_SL)):
            for j in range(numHeadlines):
                output.append((regex_HL.sub('',mySoup.select(tagPick_HL)[j].getText()),
                               regex_SL_date.search(mySoup.select(tagPick_SL)[j].getText()).group(),
                               regex_SL_enty.search(mySoup.select(tagPick_SL)[j].getText()).group().strip()
                               ))
        else: print('Error on page '+str(i))

    print('Canadian Underwriter Headlines Scrape Complete. CSV file writing in working path...')

    dump = open('cdnUWScrape.csv','w',newline='',encoding='utf-8') #hardcode encoding. was getting encoding error.
                                                                   #https://stackoverflow.com/questions/16346914/python-3-2-unicodeencodeerror-charmap-codec-cant-encode-character-u2013-i
    csvWriter = csv.writer(dump,delimiter=',',lineterminator='\n')
    for i in range(len(output)):
        csvWriter.writerow(output[i])        
    dump.close()
    print('CSV file written.')
    
    #Check in Console
    for k in range(len(output)):
        print(str(output[k]))



###########BELOW IN PROGRESS....

def CAUW_NEWS_Scrape(numPages):
#arturl=pgSoup.select('.col-md-9 > a')[0].get('href')
#pgSoup.select('a[href="'+arturl+'"] .label.label-light.label-tags')[0].getText()

    
    tagPick_CT = '.meta-type span' #Category
    tagPick_HL = 'a > .headline.media-heading' #Headline
    tagPick_SL = 'a > .meta' #Subline (date and company)
    output = [] #List, to contain Tuples. Each Tuple representing
                #one (Headline, publish date, publishing entity).

    regex_HL = re.compile(r'^[\s]+|[\s]+$')
    regex_SL_date = re.compile(r'[A-Z]{1}[a-z]{2,8}[ ]{1}\d{1,2},[ ]\d{4}')
    regex_SL_enty = re.compile(r'( by ).+$')
    
    for i in range(1,numPages+1):
        url = 'https://www.canadianunderwriter.ca/news/page/'+str(i)+'/'
        mySoup = bs4.BeautifulSoup(requests.get(url).text, 'html.parser')
        numHeadlines = len(mySoup.select(tagPick_HL))
        if numHeadlines==len(mySoup.select(tagPick_SL)):
            for j in range(numHeadlines):
                output.append((regex_HL.sub('',mySoup.select(tagPick_HL)[j].getText()),
                               regex_SL_date.search(mySoup.select(tagPick_SL)[j].getText()).group(),
                               regex_SL_enty.search(mySoup.select(tagPick_SL)[j].getText()).group().strip()
                               ))
        else: print('Error on page '+str(i))

    print('Canadian Underwriter Headlines Scrape Complete. CSV file writing in working path...')

    dump = open('cdnUWScrape.csv','w',newline='')
    csvWriter = csv.writer(dump,delimiter=',',lineterminator='\n')
    for i in range(len(output)):
        csvWriter.writerow(output[i])        
    dump.close()
    print('CSV file written.')
    
    #Check in Console
    for k in range(len(output)):
        print(str(output[k]))

