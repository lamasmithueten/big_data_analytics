library(tidyverse)
library(janitor)

# Necessary, because we need to manually fix one of the names that 
# includes a comma ...
intel <- readLines("Intel_UPE_ComparisonChart_2024_11_04_i7.csv")

# skip first two lines
intel <- intel[-c(1:2)]

# clean up unnecessary lines - i.e. those without a comma
intel <- intel[grepl(",", intel)]

# fix name with comma
intel[1] <- 
  sub(
    "Cache, up to",
    "Cache - up to",
    intel[1]
  )

# not all elements have the same length after splitting ...
# For some lines that are mostly empty, an empty element at the end 
# seems to be missing
intel <- strsplit(intel, split = ",")

# add missing empty element
# TO DO: check whether data was correctly converted, because this makes the 
# assumption that there's always a an empty cell missing for each of the 
# lines that are too short ...
intel <- 
  lapply(intel, function(x) {
    if (length(x) == 56) {
      x <- c(x, "")
    }
    x
  })


intel <- do.call(rbind, intel) 
intel <- as.data.frame(intel)

intel <- 
  intel %>%
  pivot_longer(-V1, names_to = "id", values_to = "value") %>%
  pivot_wider(names_from = V1, values_from = value) %>% 
  select(-id) %>% 
  rename(product_name = ` `)

# from janitor:
intel <- clean_names(intel)

intel <- 
  intel %>% 
  mutate(anzahl_der_kerne = as.numeric(anzahl_der_kerne)) %>% 
  separate(einfuhrungsdatum, into = c("quartal", "year"), sep = "'") %>% 
  mutate(einfuhrungsdatum = paste0(year, " - ", quartal))

# count how many data points we have per einführungsdatum
intel <- 
  intel %>% 
  add_count(einfuhrungsdatum)

intel %>% 
  ggplot(aes(x = einfuhrungsdatum, y = anzahl_der_kerne)) +
  geom_point(aes(size = n)) +
  labs(x = "Einführungsdatum", y = "Anzahl der Kerne") +
  theme_bw() +
  theme(legend.position = "top")


#-----------------------------Meins---------------------------------

intel <- read.csv("clean.csv")

intel$Max..Turbo.Taktfrequenz <- as.numeric(gsub(" GHz", "", intel$Max..Turbo.Taktfrequenz))

colnames(intel)[colnames(intel) == "Max..Turbo.Taktfrequenz"] <- "Max._Turbo_Taktfrequenz_GHz"

intel$Lithographie <- gsub("Intel 7", "10 nm", intel$Lithographie)

intel$Lithographie <- as.numeric(gsub(" nm", "", intel$Lithographie))

colnames(intel)[colnames(intel) == "Lithographie"] <- "Litographie_nm"

intel$Intel..Turbo.Boost.Technik.2.0.Taktfrequenz. <- as.numeric(gsub(" GHz", "", intel$Intel..Turbo.Boost.Technik.2.0.Taktfrequenz.))

colnames(intel)[colnames(intel) == "Intel..Turbo.Boost.Technik.2.0.Taktfrequenz."] <- "Intel._Turbo_Boost_Technik_2.0_Taktfrequenz_GHz"

intel$Grundtaktfrequenz.des.Prozessors <- gsub(" \\| ", ".", intel$Grundtaktfrequenz.des.Prozessors)

intel$Grundtaktfrequenz.des.Prozessors <- as.numeric(gsub(" GHz", "", intel$Grundtaktfrequenz.des.Prozessors))

colnames(intel)[colnames(intel) == "Grundtaktfrequenz.des.Prozessors"] <- "Grundtaktfrequenz_des_Prozessors_GHz"

intel$Cache <- gsub(" MB Intel® Smart Cache", "", intel$Cache)

intel$Cache <- as.numeric(gsub(" MB", "", intel$Cache))

colnames(intel)[colnames(intel) == "Cache"] <- "Cache_MB"
