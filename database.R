#!/usr/bin/Rscript


#libs, yo!
library(DBI)
library(RPostgres)
library(janitor)


#Reading and cleaning the data! BIG DATA!
intel <- read.csv("clean.csv")		#Reading
intel <- janitor::clean_names(intel)	#Cleaning the column names

#Removing units from data, so not every data type ends up as "text"
intel$max_turbo_taktfrequenz <- as.numeric(gsub(" GHz", "", intel$max_turbo_taktfrequenz))
intel$lithographie <- gsub("Intel 7", "10 nm", intel$lithographie)
intel$lithographie <- as.numeric(gsub(" nm", "", intel$lithographie))
intel$intel_turbo_boost_technik_2_0_taktfrequenz <- as.numeric(gsub(" GHz", "", intel$intel_turbo_boost_technik_2_0_taktfrequenz))
intel$grundtaktfrequenz_des_prozessors <- gsub(" \\| ", ".", intel$grundtaktfrequenz_des_prozessors)
intel$grundtaktfrequenz_des_prozessors <- as.numeric(gsub(" GHz", "", intel$grundtaktfrequenz_des_prozessors))
intel$cache <- gsub(" MB Intel® Smart Cache", "", intel$cache)
intel$cache <- as.numeric(gsub(" MB", "", intel$cache))
intel$bus_taktfrequenz <- as.numeric(gsub(" GT/s", "", intel$bus_taktfrequenz))
intel$verlustleistung_tdp <- as.numeric(gsub(" W", "", intel$verlustleistung_tdp))
intel$intel_turbo_boost_max_technology_3_0_frequency <- gsub(" \\| ", ".", intel$intel_turbo_boost_max_technology_3_0_frequency)
intel$intel_turbo_boost_max_technology_3_0_frequency <- as.numeric(gsub(" GHz", "", intel$intel_turbo_boost_max_technology_3_0_frequency))
intel$single_p_core_turbo_frequency <- as.numeric(gsub(" GHz", "", intel$single_p_core_turbo_frequency))
intel$single_e_core_turbo_frequency <- as.numeric(gsub(" GHz", "", intel$single_e_core_turbo_frequency))
intel$e_core_base_frequency <- gsub(" GHz", "", intel$e_core_base_frequency)
intel$e_core_base_frequency <- as.numeric(gsub("900 MHz", "0.9", intel$e_core_base_frequency))
intel$total_l2_cache <- as.numeric(gsub(" MB", "", intel$total_l2_cache))
intel$processor_base_power <- as.numeric(gsub(" W", "", intel$processor_base_power))
intel$maximum_turbo_power <- as.numeric(gsub(" W", "", intel$maximum_turbo_power))
intel$grundtaktfrequenz_der_grafik <- as.numeric(gsub(" MHz", "", intel$grundtaktfrequenz_der_grafik))
intel$max_dynamische_grafikfrequenz <- as.numeric(gsub(" GHz", "", intel$max_dynamische_grafikfrequenz))
intel$max_videospeicher_der_grafik <- as.numeric(gsub(" GB", "", intel$max_videospeicher_der_grafik))
intel$x4k_unterstutzung <- gsub("Hz", "", intel$x4k_unterstutzung)
intel$x4k_unterstutzung <- as.numeric(gsub("Yes \\|  at ", "", intel$x4k_unterstutzung))


#Putting the units back into the column name, so we actually know what unit we are talking about
colnames(intel)[colnames(intel) == "max_turbo_taktfrequenz"] <- "max_turbo_taktfrequenz_GHz"
colnames(intel)[colnames(intel) == "lithographie"] <- "litographie_nm"
colnames(intel)[colnames(intel) == "intel_turbo_boost_technik_2_0_taktfrequenz"] <- "intel_turbo_boost_technik_2_0_taktfrequenz_GHz"
colnames(intel)[colnames(intel) == "grundtaktfrequenz_des_prozessors"] <- "grundtaktfrequenz_des_prozessors_GHz"
colnames(intel)[colnames(intel) == "cache"] <- "cache_MB"
colnames(intel)[colnames(intel) == "bus_taktfrequenz"] <- "bus_taktfrequenz_GT_per_s"
colnames(intel)[colnames(intel) == "verlustleistung_tdp"] <- "verlustleistung_tdp_W"
colnames(intel)[colnames(intel) == "intel_turbo_boost_max_technology_3_0_frequency"] <- "intel_turbo_boost_max_technology_3_0_frequency_GHz"
colnames(intel)[colnames(intel) == "single_p_core_turbo_frequency"] <- "single_p_core_turbo_frequency_GHz"
colnames(intel)[colnames(intel) == "single_e_core_turbo_frequency"] <- "single_e_core_turbo_frequency_GHz"
colnames(intel)[colnames(intel) == "e_core_base_frequency"] <- "e_core_base_frequency_GHz"
colnames(intel)[colnames(intel) == "total_l2_cache"] <- "total_l2_cache_MB"
colnames(intel)[colnames(intel) == "processor_base_power"] <- "processor_base_power_W"
colnames(intel)[colnames(intel) == "maximum_turbo_power"] <- "maximum_turbo_power_W"
colnames(intel)[colnames(intel) == "grundtaktfrequenz_der_grafik"] <- "grundtaktfrequenz_der_grafik_MHz"
colnames(intel)[colnames(intel) == "max_dynamische_grafikfrequenz"] <- "max_dynamische_grafikfrequenz_GHz"
colnames(intel)[colnames(intel) == "max_videospeicher_der_grafik"] <- "max_videospeicher_der_grafik_GB"
colnames(intel)[colnames(intel) == "x4k_unterstutzung"] <- "x4k_unterstutzung_at"


#database shizz (Raw SQL is scary)
con <- dbConnect(
  RPostgres::Postgres(),
  dbname = "bda",
  host = "localhost" ,
  port = 5432,
  user = "bda",
  password = "bda",
)

dbWriteTable(con, "intel", intel, row.names = FALSE, overwrite = TRUE)
dbDisconnect(con)
