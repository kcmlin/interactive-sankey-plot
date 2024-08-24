#######################################
# Plot an Interactive Graph
#
# Katherine Schaughency
# Created: 20 Aug 2024
# Updated: 20 Aug 2024
#######################################

# --------------------------------- #
# Prep Work
# --------------------------------- #

# Enter the folder path where you save the file:
# Example (Windows): "C:/Desktop/" 
# Example (Mac or Posit Cloud): "/cloud/project/"

folder.path <- "ENTER YOUR FOLDER PATH (with a forward slash at the end)"

# Enter the Excel file name that has the interactive graph that you want to plot:
# Example: "filename.xlsx"

file.name <- "ENTER A FILE NAME.xlsx"

# Enter the Excel sheet name that include data for the interactive graph:
# Example: "Sheet1"

sheet.name <- "ENTER SHEET NAME"

# If you want to show the information flow from "Column A" (e.g., col_a) to "Column B" (e.g., col_b), 
# Column A is considered as the "source" and Column B is considered as the "target" in the code below

# Enter the column number where you have the "source" info for the interactive graph:
# Example: 1

source.num <- 1

# Enter the column number where you have the "target" info for the interactive graph:
# Example: 2

target.num <- 2

# Enter the title for your interactive graph:
# Example: "Example Figure - Left: A, Right: B"

figure.title <- "ENTER A FIGURE TITLE"

# Enter the HTML file name for the interactive graph (saved output):
# Example: "export_filename.html"

export.file.name <- "ENTER A FILE NAME.html"

# If you have never loaded the following packages in R, please un-comment the following 
# block of code using CTNL+SHIFT+C and install the packages. Otherwise, you can skip this portion

# install.packages("tidyverse")
# install.packages("dplyr")
# install.packages("readxl")
# install.packages("networkD3")
# install.packages("htmlwidgets")
# install.packages("htmltools")


# --------------------------------- #
# Code to Run the Sankey Plot
# --------------------------------- #


# --------------------------------- #
# working directory

getwd()
setwd(folder.path)


# --------------------------------- #
# load packages

# for coding style 
library(tidyverse)
library(dplyr)

# for data import
library(readxl)

# for plots
library(networkD3)   # sankey
library(htmlwidgets) # update sankey in networkd3
library(htmltools)   # update sankey in networkd3

# --------------------------------- #
# load data

data <- read_xlsx(file.name, sheet = sheet.name)


# A connection data frame is a list of flows (source and target) with intensity for each flow (value)
links <- data.frame(source=data[[source.num]], 
                    target=data[[target.num]],
                    value=0.1)


# From these flows we need to create a node data frame: it lists every entities involved in the flow
nodes <- data.frame(
  name=c(as.character(links$source), 
         as.character(links$target)) %>% unique()
)

# With networkD3, connection must be provided using id, not using real name like in the links dataframe. We need to reformat it.
links$IDsource <- match(links$source, nodes$name)-1 
links$IDtarget <- match(links$target, nodes$name)-1

# Make the Network
sankey.plot <- sankeyNetwork(Links = links, Nodes = nodes,
                             Source = "IDsource", Target = "IDtarget",
                             Value = "value", NodeID = "name", 
                             fontSize = 20, nodeWidth = 5,
                             height = 1080, width = 1080,
                             sinksRight=FALSE)

sankey.plot <- prependContent(sankey.plot, tags$h2(figure.title))

sankey.plot


# save it as an html file
saveNetwork(sankey.plot, export.file.name)
