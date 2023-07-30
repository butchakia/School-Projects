#1 Load dataset, view for verification
library(readr)
CreditCards <- read_csv("C:/Users/whitl/OneDrive/Desktop/R Files/CreditCards.csv")
View(CreditCards)

#Load cluster and factoextra
library("cluster")
library("factoextra")

#2A Delete first column with NULL
CreditCards$...1 <- NULL
#2B Determine optimal number of clusters using fviz_nbclust
fviz_nbclust(CreditCards, kmeans, method = "gap_stat")
#2C Perform kmeans clustering with 2B optimal cluster number
km.res <- kmeans(CreditCards, 2, nstart=25)
#2D Visualize the clusters with ks.res from 2C
fviz_cluster(km.res, data=CreditCards)

