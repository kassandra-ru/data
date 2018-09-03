import requests
from requests.packages.urllib3.util.retry import Retry
from requests.adapters import HTTPAdapter
from bs4 import BeautifulSoup
import os.path
import datetime
import hashlib


req = requests.Session()
retries = Retry(total=10,
        backoff_factor=0.1,
        status_forcelist=[ 500, 502, 503, 504 ])
req.mount('http://', HTTPAdapter(max_retries=retries))
interval_days = 7



# Assembling a list of links to watch
catalog = 'http://www.gks.ru/gis/images/graf_sroch1.htm'
links = catalog_updater(catalog)
links_updater(links, 'watchdog.csv', interval_days)


def catalog_updater(catalog):
    watch_links = []
    text = req.get(catalog)
    soup = BeautifulSoup(text.content)
    for link in soup('a'):
        if "безработица" in link.get_text():
            watch_links.append(link['href'])
    return watch_links

def links_updater(links, hashfile, interval):
    content = read_watchdog(hashfile)

    for url in links:
        row = next((i for i in content if i[0] == url), None)


        page = req.get(url)
        text = page.content

        hash_md5 = hashlib.md5()
        hash_md5.update(text)
        page_hash = hash_md5.hexdigest()


        file = url.split("/")[-1]
        last_download = datetime.date.today().strftime("%Y-%m-%d")

        if not row is None and page_hash == row[1]:
            last_download = row[3]
        else:
            filename = last_download + "/" + file
            dirname = os.path.dirname(filename)
            if not os.path.exists(dirname):
                os.makedirs(dirname)
            with open(filename, 'wb') as f:
                f.write(text)

        last_access = datetime.date.today().strftime("%Y-%m-%d")
        next_access = datetime.datetime.strptime(last_access, "%Y-%m-%d") + datetime.timedelta(days = interval)
        next_access = next_access.strftime("%Y-%m-%d")
        comment = "Employment statistics from Russian Statistical Agency (monthly)"
        with open(hashfile, 'a') as f:
            print(url, page_hash, file, last_download, last_access, next_access, comment, sep=',', file=f)


def read_watchdog(hashfile):
    with open(hashfile) as f:
        content = f.read()
    content = content.split("\n")
    return [i.split(",") for i in content[1:]]
