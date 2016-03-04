#################################################
#   Version 3
#   柯林斯英汉双解大词典 from 有道
#################################################

rm(list=ls())
library("rvest")
setwd("/Users/jiaru2014/Desktop/wordlist_scrape")

##### I. 定义Afile,Bfile,word.list,hline ###############################

Afile <- "list/1-2-list.txt"  # word.list to read from, a txt file, type in by hand
Bfile <- "content_Collins/1-2-content.txt"  # finished word.list

word.list <- read.table(file=Afile,header = F ,sep = "\n",col.names = "v")
word.list <- as.character(word.list$v)
title <- word.list[1]
word.list <- word.list[-1]

hline <- "\n###############################################\n"

##### II.定义爬取单词信息的函数 ###############################

# define function "Scrape()"  
Scrape <- function(word) {
  
  # 单词页面
  page <-  
    paste0("http://dict.youdao.com/w/",word,"/#keyfrom=dict.top") %>%
    read_html() 
  
  # 单词
  word.title <-
    html_nodes(page,"#collinsResult .title") %>%
    html_text(trim=TRUE) 
  
  # 若Collins中查不到该单词：
  if (length(word.title)==0) stop("Not Find in Collins")
  
  # 音标
  word.phonetic <-
    html_nodes(page,"#phrsListTab .phonetic") %>%
    html_text(trim=TRUE) 
  
  
  # 单词解释部分，三个一组：释义、英文例句、中文翻译
  word.collins <-
    html_nodes(page,".examples p , .collinsMajorTrans p") %>%
    html_text(trim=TRUE) %>%
    gsub(pattern = "  ", replacement = "") %>%
    gsub(pattern = "\t", replacement = "") %>%
    gsub(pattern = "\n", replacement = " ") 
       # 这一步得到的是一个字符向量，length正常情况下应该是3的倍数
  
  num <- ceiling(seq_along(word.collins)/3) 
  num[duplicated(num)]<-""     # 生成编号vector
  
  word.collins <-       # 加编号，分行
    paste(num,word.collins)%>%
    sapply(FUN = function(x) paste0("\n",x), USE.NAMES = FALSE)
  
  # 整合
  word.content <- c(word.title,"\n",word.phonetic,
                    word.collins,hline)
  return(word.content)
}

# include Error_Handling : "RScrape()" 
RScrape <- function(word) {
  tryCatch(
    Scrape(word),
    error = function(e) {
      print(paste0("There is error in Scraping \"",word,"\""))
      paste("There is an error in scraping \"",word,"\"",
            "\nThe original error is \n",e,hline)
    },
    message = function(m){"There is an message"}
  )
}

##### III. 开始逐个爬取并写入txt文件 ###############################

cat(title,file = Bfile,append=F)
cat(hline,file = Bfile,append=T)

for (word in word.list) {
  cat(RScrape(word),file = Bfile,append=T)
  print(paste0("Searching for : \"",word,"\" ...  ",
                 match(word,word.list)," in ",length(word.list)))
  
}

