import zipfile
import urllib.request
import os
import pandas as pd

news_path = "https://archive.ics.uci.edu/ml/machine-learning-databases/00359/NewsAggregatorDataset.zip"
zip_file = "all_news.zip"

if not os.path.exists(zip_file):
    print("Downloading file")
    urllib.request.urlretrieve(news_path, zip_file)

with open("all_news.csv", "wb") as out:
    with zipfile.ZipFile(zip_file) as zf:
        csvfiles = [name for name in zf.namelist() if name.endswith('.csv') and not name.startswith("__MACOSX") ]
        for item in csvfiles:
            if not os.path.exists(item):
                print("Extracting %s" % item)
                zf.extract(item)

print("Finished extracting")

news = pd.read_csv("newsCorpora.csv", delimiter="\t", header=None, index_col=0)
news.columns = ["title", "url", "publisher", "category", "story", "hostname", "timestamp"]
news['timestamp'] = pd.to_datetime(news['timestamp'], unit='ms')
news.index = news['timestamp']
del news['timestamp']
start_date, end_date = (min(news.index), max(news.index))
print(start_date, end_date, len(news))

print("Loading symbols")
symbols = pd.read_csv("symbols.csv")

sym = symbols["symbol"].tolist()
sym_str = '\)|\('.join(sym)
filtered = news[news["title"].str.contains(sym_str)]

filtered = filtered[filtered["title"].str.len() < 120]  # Some garbage data

print("Saving data")

filtered["title"].to_csv("news.csv")