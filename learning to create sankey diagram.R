# Creating a sankey diagram by using ggsankey

## installing the required package
# remotes package can be installed by using install.package ("remotes")

# remotes::install_github("davidsjoberg/ggsankey")

library(ggsankey)
library(tidyverse)

# create data which used for sankey diagram
set.seed(1)

# simple 
x1 = sample(x = c("Hosp A","Hosp B","Hosp C"), size = 100, replace = TRUE)
x2 = sample(x = c("Male","Female"), size = 100, replace = TRUE)
x3 = sample(x = c("Survived","Died"), size = 100, replace = TRUE)


d = tibble(x1,x2,x3)

d = d %>% 
  rename(Hospital = x1,
         Gender = x2,
         Outcome = x3)

# Step 1

df = d %>% 
  make_long(Hospital,Gender,Outcome)

# chart 1

df %>% 
  ggplot(aes(x = x,next_x = next_x,node = node, next_node = next_node, fill = factor(node)))+
  geom_sankey(flow.alpha = .5, show.legend = FALSE)+
  geom_sankey_label(aes(label = node), size = 3, fill = "yellow")+
  theme_light()+
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank(),
        axis.ticks = element_blank(),
        panel.border = element_blank())

# creating a subset to be used to add numbers in the second chart

dagg = df %>% 
  group_by(node) %>% 
  count()

# merging the two subsets, df and dagg
df2 = df %>% 
  left_join(dagg, by = "node")

# Chart 2: sankey diagram with numbers on label

df2 %>% 
  ggplot(aes(x = x,next_x = next_x,node = node, next_node = next_node, fill = factor(node)))+
  geom_sankey(flow.alpha = .5, show.legend = FALSE)+
  geom_sankey_label(aes(label = paste0(node, ", n=",n)), size = 3, fill = "yellow")+
  theme_light()+
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank(),
        axis.ticks = element_blank(),
        panel.border = element_blank())
