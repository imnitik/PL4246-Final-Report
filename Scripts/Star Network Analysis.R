library(igraph)
library(bootnet) # needed to compute partial correlation matrix
library(tidyverse) # for data wrangling 


#1. Generate network object: 

# Load the stars dataset
data <- read.csv('stars-data_182.csv', header = T)

# Retain the 51 items for estimating the correlation matrix
data <- data |> select(item_1:item_51) 

# Create partial correlation matrix from the 51 stars items
stars_matrix <- estimateNetwork(data, default = "pcor", 
                                threshold = 'sig') # recommended to retain sig. correlations; can also try other regularization techniques

# Extract the matrix for conversion to igraph 
# Abs function gives the absolute values in the matrix as igraph cannot handle negative edges 
stars_adj_mat <- abs(stars_matrix$graph) # you should know how to convert stars_adj_mat into an igraph object 

stars_network <- graph_from_adjacency_matrix(stars_adj_mat, mode = 'undirected',  weighted = T)
save(stars_network,
     file = "stars_network.RData")

summary(stars_network)
plot(stars_network)


# 2. Macro-level Network Analysis 

# Average Degree 
degree(stars_network) |> mean()

# ASPL
mean_distance(graph = stars_network, weights = NA, directed = F)

# Global Clustering Coefficient 
transitivity(stars_network, type = 'global')

# Small World Index 
set.seed(2)

er_graphs <- list()

for(i in 1:5) { # number of networks to generate
  er_graphs[[i]] <- sample_gnm(n = gorder(stars_network), m = gsize(stars_network), directed = F, loops = F)
}

# compute the L and C for each ER network, take the mean 
sapply(er_graphs, mean_distance) |> mean() # L_rand
sapply(er_graphs, transitivity, type = 'global') |> mean() # C_rand -

# SWI for stars_network  
(0.2018349/0.09588185)/(2.658039/2.548863)

# Network Density 
edge_density(stars_network)

# Network Diameter 
diameter(stars_network, directed = F, weights = NA)

# Assortative Mixing 
# By degree
assortativity_degree(stars_network, directed = F)

# Network Components 
mean_distance(stars_network, weights = NA, unconnected = F)
g_comp <- components(stars_network)
g_comp$csize 



# 3. Community detection

# 3.1 Louvain community detection
set.seed(1)

stars_louvain <- cluster_louvain(stars_network)

# Community membership of each item
data.frame(node = V(stars_network)$name, community = stars_louvain$membership) |> head(10)

# Number and size of communities
table(stars_louvain$membership)

# Modularity
modularity(stars_louvain)

# 3.2 Walktrap community detection


# 6. Bridge and node strength analysis