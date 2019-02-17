library(rtweet)

result <- get_timeline("SarahMillican75", n = 1000,  parse = TRUE, retryonratelimit = TRUE) %>%
  dplyr::filter(created_at > "2018-12-24" & created_at <="2018-12-26")

dim(result)
