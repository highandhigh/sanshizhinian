library(XML)
#获取日历史交易记录，从网易网获取
cntrade <- function(tickers, path = "", start = 19910101, end = "") {
  
  address <- "http://quotes.money.163.com/service/chddata.html"
  field <- "&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;TURNOVER;VOTURNOVER;VATURNOVER;TCAP;MCAP"
  
  if (path == "") {
    path <- getwd()
  }
  
  if (!file.exists(path)) {
    dir.create(path)
  }
  
  if (substr(path, nchar(path), nchar(path)) != "/") {
    path <- paste(path, "/", sep = "")
  }
  
  if (end == "") {
    year <- substr(Sys.time(), 1, 4)
    month <- substr(Sys.time(), 6, 7)
    day <- substr(Sys.time(), 9, 10)
    end <- paste(year, month, day, sep = "")
  }
  
  count <- 0
  tickers <- as.character(tickers)
  for (name in tickers) {
    while (nchar(name) < 6) {
      name <- paste("0", name, sep = "")
    }
    
    if (nchar(name) > 6) {
      warning(paste("invalid stock code: ", name, sep = ""))
      next
    }
    
    if (as.numeric(name) >= 600000) {
      url <- paste(address, "?code=0", name, "&start=", start, "&end=", end, field, sep = "")
    } else {
      url <- paste(address, "?code=1", name, "&start=", start, "&end=", end, field, sep = "")
    }
    destfile <- paste(path, name, ".csv", sep = "")
    data<- htmlParse(url,encoding="GBK")
    
    data<-getNodeSet(data,"//body/p")
    data<-xmlValue(data[[1]])
    write(data,file=destfile)
    
    count <- count + 1
  }
  
  if (count == 0) {
    cat("一个数据文件都没下载下来！\n")
  } else {
    cat("数据下载完成！\n")
    cat(paste("共下载", count, "个文件\n", sep = ""))
  }
}



cntrade(c('600000', '000001', '600810'), path = "~/temp", start = 19900101, end = 20141231)
