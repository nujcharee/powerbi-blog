library(rtweet)
library(tidyverse)
rt <- search_tweets(
    "#loneliness", n = 18000, include_rts = FALSE
)

rt

tweets = rt %>% select(status_id, created_at, text, screen_name, location)
