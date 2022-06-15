import requests
import csv
import pandas as pd
from bs4 import BeautifulSoup

filename = open('/Users/irischen/Documents/TED_talk.csv', 'r', encoding="ISO-8859-1")
file = csv.DictReader(filename)
links = []
genres = []
lengths = []
# a = 0
for row in file:
    # a += 1
    links.append(row['link'])
    # if a == 5:
    #     break

a = 0
for link in links:
    a+=1
    print(a)

    response = requests.get(link)

    soup = BeautifulSoup(response.text, "html.parser")
    soup.prettify()
    
# #get most relevant genre
    typegenres = soup.find_all("a")
    for typegenre in typegenres:
        if typegenre["href"] != None and "topics/" in typegenre.get("href"):
            genres.append(typegenre.getText())
            break
            
    if (len(genres) != a):
        genres.append("No genre")
# #get length
    seconds = soup.find_all("meta")
    for second in seconds:
        if second.get("property") == "og:video:duration":
            lengths.append(second.get("content"))
            break
    if (len(lengths) != a):
        lengths.append("No length")

df = {'url':[], 'genre':[], 'length':[]}
for i in links:
    i = i.split("\n")[0]
    df['url'].append(i)


for ii in genres:
    ii = ii.split("\n")[0]
    df['genre'].append(ii)


for iii in lengths:
    iii = iii.split("\n")[0]
    df['length'].append(iii)

print(df)

df = pd.DataFrame.from_dict(df)
df.to_csv("TED_talk_v2.csv", index = False)