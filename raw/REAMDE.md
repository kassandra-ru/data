# raw data

В этой папке находятся исходные файлы (xls, doc, html, и т.д.) сортированные по дате скачивания.

Данные скачиваются с помощью пакета `kassandr`. 
Про него есть [страничка](https://kassandra-ru.github.io/kassandr/articles/intro.html)

Возможно стоит добавить скрипт, который надо запускать после скачивания новой версии для обработки сырых данных?


## Комментарии


источником данных о потрибительских ценах является Роскомстат, изначальная таблица:
http://www.gks.ru/free_doc/new_site/prices/potr/I_ipc.xlsx

ссылка на эту таблицу идет с
http://www.gks.ru/free_doc/new_site/prices/potr/tab-potr1.htm

Возможно, имеет смысл скачивать Краткосрочные показатели по следующей ссылке: 
http://www.gks.ru/wps/wcm/connect/rosstat_main/rosstat/ru/statistics/publications/catalog/doc_1140080765391

Таблицы по дефляторам ввп:
http://www.gks.ru/free_doc/new_site/vvp/kv/tab9.htm

* Посчитать хэш-сумму md5:
```r
digest::digest(file = "___")
```
