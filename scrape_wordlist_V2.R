#################################################
#   Version 2 
#   When searching, some word can't match, use
#   tryCatch(expr, error = function(e) ... )
#################################################

rm(list=ls())
library("rvest")
setwd("/Users/jiaru2014/Desktop/wordlist_scrape")

Afile <- "list/1-2-list.txt"  # word.list to read from, a txt file, type in by hand
Bfile <- "content/1-2-content.txt"  # finished word.list

word.list <- read.table(file=Afile,header = F ,sep = "\n",col.names = "v")
word.list <- as.character(word.list$v)
title <- word.list[1]
word.list <- word.list[-1]
cat(title,file = Bfile,append=F)
cat("\n======================================================\n",
    file = Bfile,append=T)

# Search word and Clean the raw data scraped
SC <- function(word) {
  word.raw<-
    paste("http://toefl.kaomanfen.com/vocab/detail/",word,sep="") %>%
    read_html() %>%
    html_node(".s-word-detail") %>%
    html_text(trim=TRUE)
  
  word.tidy<-
    gsub(word.raw,pattern="\r\n\\s*",replacement = "\n") %>%
    gsub(pattern="深入学习\n考满分大辞典\n",replacement = "") %>%
    gsub(pattern="US\n",replacement = "") %>%
    gsub(pattern="UK\n",replacement = "") %>%
    gsub(pattern="\\d*人查过，\\d*人收藏\n",replacement = "")
  
  return(word.tidy)
}

# Revised or Robust version of SC: if the word searched has no match...
rSC <- function(word){
  tryCatch( SC(word),
            error = function (e) {
              print(paste0("There is an Error in searching for '",word,"'"))
              paste0(word,"\n There is an Error, probabaliy no match.")
            }
          )
}

# starting scraping and write into Bfile
for (word in word.list) {
  word.tidy <-rSC(word)

  cat(word.tidy,file = Bfile,append=T)
  cat("\n============================================\n",file = Bfile,append=T)
  message(paste0("Searching for : '",word,"' ...  ",
                 match(word,word.list)," in ",length(word.list)))
}


