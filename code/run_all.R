# Code for the Group Model analysis of the Barents Sea dataset

# Required R packages
install.packages(c("cheddar", "dbscan", "doMC", "igraph", "NetIndices", "readr", 
                   "reshape2", "stringr", "tidyverse", "umap", "vegan"))
# Additionally, the python package "umap-learn" is required for steps 10-11
# Also, the Group Model code is downloaded and run separately, 
# but our result files are also included (see step 3).

# 1. Modify the data files regarding Sebastes spp. which lacks interactions in 14 of the 25 subregions.
  source("seb_mod.R")
  #new edgelist created, ../data/kortsch/PairwiseList_seb.txt

# 2. Create subregion foodwebs from the modified edgelists.
  source("makesubnets.R")
  #Adjacency matrix files added to ../data/sebwebs/ for group model usage
  #Adjacency matrix files added to ../data/sebwebs_with_names/ for other usage linked to species identity

# 3. Run the group model for each network
# Source code for the group model is available from 
# Michalska-Smith et al. 2018 - "Understanding the role of parasites in food webs using the group model"
# at https://git.io/vXciH
#  
#    (Our result files are included in "../results/groups", delete if you want to rerun it yourself)
#
#    --Note that this takes approximately 1000+ hours when executed according to our protocol:
#    * MCMC steps: 300 000
#    * MCMC chains: 20
#    * Max number of groups: 20
#    * Number of repeated runs for each network: 10
# 
#    Using the group model from Michalska-Smith et al. 2018, the command line for executing the script 
#    with the metaweb as an example would be:
#    ./FindGroups 233 ../data/sebwebs/fullnet.txt 123456 300000 20 21 0
#    where 
      # 233 = number of species in the web to be analysed, 
      # ../data/sebwebs/fullnet.txt = path to the adjacency matrix
      # 123456 = randomly generated six-digit random seed (randomised for each repeated run)
      # 300000 = MCMC steps
      # 20 = MCMC chains
      # 21 = Max number of groups (+1 to differentiate in this example)
      # 0 = flag deactivating degree correction (0 = off)
#
#    --Note: place all result files from the group model in "../results/groups"
#    Different numbers of result files for different networks depend on 
#    how many runs ends with exactly the same marginal likelihood.

# 4. Create a data frame with the best groupings for each species in each web.
#    Also fetches taxonomy from Kortsch et al. dataset and calculates 
#    generality, vulnerability, number of links and trophic level
  source("groups_df.R")
  g_df #Data frame with species-specific information (per subregion/metaweb)

# 5. Calculate species overlap between all subregions and the metaweb
  source("overlap.R")
  overlap_matrix #Species overlap matrix

# 6. Calculate the Jaccard distance between all subregions and the metaweb
  source("jaccard.R")
  J_s #Jaccard distance matrix
  
# 7. Calculate the species-wise group turnover
  source("specieswise.R")
  g_df #Turnover column added for each species (per subregion/metaweb)

# 8. Test for spatial autocorrelation
  source("spatial.R")
  c_J #Plot with spatial autocorrelation for Jaccard distance
  col #Plot with spatial autocorrelation for species overlap

# 9. Test for environmental correlation
  source("environmental.R")

# 10. UMAP + HDBSCAN clustering of subregions based on Jaccard distance
#     --Note that this will also require the python package "umap-learn"!
  source("umap_opti_j.R")
  jd_topclusters$c_clusters #Dataframe with subregions and their respective cluster memberships 
  
# 11. UMAP + HDBSCAN clustering of subregions based on Species overlap
#     --Note that this will also require the python package "umap-learn"!
  source("umap_opti_ol.R")
  ol_topclusters$c_clusters #Dataframe with subregions and their respective cluster memberships 
  