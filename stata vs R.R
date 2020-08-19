library(rtweet)
library(ggplot2)
library(dplyr)
library(reshape)

stata <- search_tweets("#stata", n = 18000, include_rts = FALSE, lang = "en")
rstats <- search_tweets("#rstats", n = 18000, include_rts = FALSE, lang = "en")

stata_ts <- ts_data(stata, by = "hours")
names(stata_ts) <- c("time", "stata_n")

rstats_ts <- ts_data(rstats, by = "hours")
names(rstats_ts) <- c("time", "rstats_n")

merged_df <- merge(stata_ts, rstats_ts, by = "time", all = TRUE)

melt_df <- melt(merged_df, na.rm = TRUE, id.vars = "time")

ggplot(data = melt_df, aes(x = time, y = value, col = variable))+
  geom_line(lwd = 0.8)
