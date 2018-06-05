creditcard = read_csv('data/creditcard.csv', col_types = cols())

set.seed(123)

normal = creditcard %>% filter(Class == 0)
fraud = creditcard %>% filter(Class == 1)

subsample = normal %>% nrow %>% seq_len %>% createDataPartition(times = 1,
																p = 0.051026, #0.03343
																list = F)
subsample = normal %>% nrow %>% seq_len %>% createDataPartition(times = 1, p = 0.03343, list = F)
data_raw = normal %>% slice(subsample) %>% bind_rows(fraud)

data_raw %>% head

write_csv(data_raw,
		  'data/creditcard_15k.csv' #'data/creditcard_10k.csv'
		  )