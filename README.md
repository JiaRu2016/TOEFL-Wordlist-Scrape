# TOEFL-Wordlist-Scrape
R语言爬虫程序，自动查单词，并汇总成一个单词库。

### V1
1. 输入：Afile 在list文件夹下，命名规则："1-1-list.txt"；格式：第一行是标题，每一个单词占一行。	
2. 输出：Bfile 在content文件夹下。	
3. 每次运行需要	：	
更改程序中的两行：Afile/Bfile赋值	
手动输入1-1-list.txt文件	

### V2
1. 修复BUG：某些单词查不到，会报错No match， 改成用tryCatch(...)	
2. 尝试用lapply代替for循环，未果

### V3
尝试其他词典：有道、海词。。。
