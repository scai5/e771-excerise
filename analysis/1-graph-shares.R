# About ------------------------------------------------------------------------

# Graph distribution of market shares over time
# ECON 771 Exercise 4
# Author:         Shirley Cai 
# Date created:   02/28/2024 
# Last edited:    04/15/2024 

# Graph hospital ZIP shares over time ------------------------------------------

df %>% 
  filter(!is.na(zip_share)) %>%
  mutate(year = as.factor(year)) %>% 
  ggplot(aes(x = fct_rev(year), y = zip_share, fill = year, color = year)) + 
  geom_violin(scale = "width") + 
  coord_flip() + 
  labs(
    title = "", 
    x = "Year", 
    y = "Market share"
  ) +
  theme_ipsum() + 
  theme(legend.position = "none") 

ggsave("results/zip-market.jpg")

df %>% 
  filter(!is.na(zip_share), zip_share >= 0.85) %>%
  mutate(year = as.factor(year)) %>% 
  ggplot(aes(x = fct_rev(year), y = zip_share, fill = year, color = year)) + 
  geom_violin(scale = "width") + 
  coord_flip() + 
  labs(
    title = "", 
    x = "Year", 
    y = "Market share"
  ) +
  theme_ipsum() + 
  theme(legend.position = "none") 

ggsave("results/zip-zoom.jpg")

# Graph hospital HRR shares over time ------------------------------------------

df %>% 
  filter(!is.na(hrr_share)) %>%
  mutate(year = as.factor(year)) %>% 
  ggplot(aes(x = fct_rev(year), y = hrr_share, fill = year, color = year)) + 
  geom_violin(scale = "width") + 
  coord_flip() + 
  labs(
    title = "", 
    x = "Year", 
    y = "Market share"
  ) +
  theme_ipsum() + 
  theme(legend.position = "none")

ggsave("results/hrr-market.jpg")

df %>% 
  filter(!is.na(hrr_share), hrr_share <= 0.15) %>%
  mutate(year = as.factor(year)) %>% 
  ggplot(aes(x = fct_rev(year), y = hrr_share, fill = year, color = year)) + 
  geom_violin(scale = "width") + 
  coord_flip() + 
  labs(
    title = "", 
    x = "Year", 
    y = "Market share"
  ) +
  theme_ipsum() + 
  theme(legend.position = "none")

ggsave("results/hrr-zoom.jpg")

# Graph hospital mkt shares over time ------------------------------------------
 
df %>% 
  filter(!is.na(mkt_share)) %>%
  mutate(year = as.factor(year)) %>%
  ggplot(aes(x = fct_rev(year), y = mkt_share, fill = year, color = year)) +
  geom_violin(scale = "width") +
  coord_flip() +
  labs(
    title = "",
    x = "Year",
    y = "Market share"
  ) +
  theme_ipsum() +
  theme(legend.position = "none")

ggsave("results/mkt-market.jpg")

df %>% 
  filter(!is.na(mkt_share), mkt_share <= 0.15) %>%
  mutate(year = as.factor(year)) %>%
  ggplot(aes(x = fct_rev(year), y = mkt_share, fill = year, color = year)) +
  geom_violin(scale = "width") +
  coord_flip() +
  labs(
    title = "",
    x = "Year",
    y = "Market share"
  ) +
  theme_ipsum() +
  theme(legend.position = "none")

ggsave("results/mkt-zoom.jpg")
