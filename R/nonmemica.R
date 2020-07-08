tinytex::tlmgr_update()

library(tinytex)



library(curl)
library(nonmemica)

readr::read_csv('http://repository.kpml.or.kr/file/133')

curl_download("http://repository.kpml.or.kr/file/133", "data/PKdata_ver5.csv")
curl_download("http://repository.kpml.or.kr/file/135", "run206.mod")
curl_download("http://repository.kpml.or.kr/file/134", 'run206.lst')



(url = "http://repository.kpml.or.kr/file/135")


partab('206', project='./')

#- [PKdata_ver5.csv](http://repository.kpml.or.kr/file/133)
#- [run206.lst](http://repository.kpml.or.kr/file/134)
#- [run206.mod](http://repository.kpml.or.kr/file/135)



#install.packages('nonmemica')

partab

vignette('parameter-table', package = 'nonmemica')
partab(1001, project='../model')
