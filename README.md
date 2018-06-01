# CanadianUnderwriterMagazine
Text mining magazine headlines from this property and casualty insurance industry news outlet.

cdnUWScrape.py
- Contains a function called CAUW_PRSS_Scrape(numPages), which scrapes user specified numPages worth of Canadian Underwriter online insPRESS  articles' Headline, Data and Author. Data captured as List of Tuples, (over)written to 'cdnUWScrape.csv' in working path.
- Also contains a function called CAUW_NEWS_Scrape(numPages) - IN PROGRESS - which scrapes Canadian Underwriter online News articles.
- Uses the following Modules: re, requests, bs4, csv, datetime

cdnUW.r
- Uses 'cdnUWScrape.csv' to build a comparison word cloud by year, and plots positive/negative sentiment score by year.
- Uses the following Libraries: tm, wordcloud, ggplot2
