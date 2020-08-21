library(rtweet)
library(tidytext)
library(tidyverse)
library(scales)
library(ggplot2)
library(wordcloud2)
library(lubridate)
library(hrbrthemes)
library(qdapRegex)
library(tm)


corona <- search_tweets(q = "corona OR COVID OR COVID19 OR coronavirus",
                        geocode = lookup_coords("montevideo"),
                        include_rts = FALSE,
                        retryonratelimit = TRUE,
                        lang = "es")


#Fecha y hora no locales (+3)
#corrijo
corona$created_at <- corona$created_at - 60*60*3


#Lo básico: recuento por hora
ts_plot(corona, by = 'hours', color = 'blue')


#corrección sobre horas para gráfico
corona$h.lub <- hour(corona$created_at) + minute(corona$created_at)/60


#tweets por hora
corona %>%
  ggplot(aes(x=h.lub, color=as.factor(as.Date(created_at)), fill=as.factor(as.Date(created_at)))) +
  geom_histogram(alpha=0.6, binwidth = 1) +
  theme(
    legend.position="none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 8)
  ) +
  xlab("Hours day") +
  ylab("Assigned Probability (%)") +
  facet_wrap(~as.factor(as.Date(created_at)))

#Primer conteo general de palabras.
#extraigo texto
corona_txt <- corona$text

#limpio URLs
corona_txt <- rm_twitter_url(corona_txt)

#limpio caracteres
corona_txt <- gsubb("[^A-Za-z]", " ", corona_txt)

#convierto texto a corpus
corona_txt <- corona_txt %>% VectorSource() %>% Corpus()

#minúsculas para evitar problemas de conteo
corona_txt <- tm_map(corona_txt, tolower)

#elimino "stopwords"
corona_txt <- tm_map(corona_txt, removeWords, stopwords("spanish"))

#elimino espacios sobrantes
corona_txt <- tm_map(corona_txt, stripWhitespace)
