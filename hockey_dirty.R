library(tidyverse)

## IMPORT DATA -----------------------------------------------------------------

# See:
# https://github.com/rfordatascience/tidytuesday/blob/master/data/2024/2024-01-09/readme.md

canada_births_1991_2022 <- read.csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-01-09/canada_births_1991_2022.csv')
nhl_player_births <- read.csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-01-09/nhl_player_births.csv')
nhl_rosters <- read.csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-01-09/nhl_rosters.csv')
nhl_teams <- read.csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-01-09/nhl_teams.csv')

## DATA EXPLORATION ------------------------------------------------------------

# explooooooring
all(nhl_player_births$player_id %in% nhl_rosters$player_id)
all(nhl_rosters$player_id %in% nhl_player_births$player_id)

length(unique(nhl_player_births$player_id))
length(unique(nhl_rosters$player_id))

nhl_rosters %>% 
  count(player_id) %>% 
  arrange(desc(n)) %>% 
  head

nhl_rosters %>% 
  filter(player_id == "8450725")

nhl_rosters %>% 
  select(
    position_type, player_id, first_name, last_name, 
    position_code:birth_state_province
  ) %>% 
  unique() %>% 
  filter(player_id == "8446324")

# final data set: each player only appears once: first entry for most 
# recent season
nhl <- 
  nhl_rosters %>% 
  select(-headshot) %>% 
  group_by(player_id) %>% 
  filter(season == max(season)) %>% 
  filter(row_number() == 1) %>% 
  ungroup()

# Calculate age
nhl <- 
  nhl %>% 
  mutate(birth_date = as.Date(birth_date)) %>% 
  mutate(
    age_at_season = 
      as.numeric(
        diff.Date(
          c(
            birth_date, 
            as.Date(paste0(substr(season, 1, 4),"-01-01"))
          )
        ) / 365.25
      ),
    .by = player_id,
    .after = birth_date
  )

nhl %>% 
  ggplot(aes(x=weight_in_kilograms, y=height_in_centimeters)) + 
  geom_point(alpha=.4) +
  geom_smooth(method="lm", color="#FE12AB") +
  labs(x="Weight in kg", y="Height in cm") +
  theme_grey()

cor.test(nhl$weight_in_kilograms, nhl$age_at_season)
cor.test(nhl$height_in_centimeters, nhl$age_at_season)
cor.test(nhl$height_in_centimeters, nhl$weight_in_kilograms)  
