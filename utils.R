library(textgRid)
library(ipa)

# load_textGrids: func for gatherings and loading all textGrids
# If previous version of textgrids exits, use this file.
#allGrids is a list of gridNames and TextGrids (see textgRid for formats)
load_textGrids <- function(){
  if(file.exists("textGrid_Processed_File.RData")) {
    load(file="textGrid_Processed_File.RData")
    return(save)
  }
  else {
  addResourcePath("txt", "./textgrid")
  grid_files <- file.path("textgrid", list.files("./textgrid", ".txt"))
  allGrids <- lapply(grid_files, TextGrid)
  save <- list(grid_files, allGrids)
  save(save, file="textGrid_Processed_File.RData")
  return(save)
  }
}

#input: a regex to search for, a tier to search on, and a list of loaded textGrids. Output: three lists, gridNames, startTimes, endTimes
#The index of each list represents a start time, endtime, and origin grid for each search.
#outputs empty start and end times if cannot find pattern in textgrids on this tier.
#cannot handle a tier other than phoneme, immediate neighbor, syllable, word 
get_timestamps_for <- function(regex, tierSearch, allGrids) {
  startTimes = list()
  endTimes = list()
  gridNames = list()

  for (index in 1:length(allGrids[[1]])) {
    name <- allGrids[[1]][[index]]
    grid <- allGrids[[2]][[index]]
    #search the correct tier
    t <- grid[[tierSearch]]

    #find intervals for this regex
    if (!is.null(t)) {
    intervals <- findIntervals(tier=t, pattern=regex)
      if (!is.null(intervals)){
        #add to lists
        startTimes <- append(startTimes, intervals$StartTime)
        endTimes <- append(endTimes, intervals$EndTime)
        #Grid name
        for (x in intervals$StartTime) {
          gridNames <- append(gridNames, name)
        }
      }
    }
  }
  #return object
  return(list(gridNames, startTimes, endTimes))
}

#input: a regex to search for, a tier to search on, and a list of loaded textGrids. Output: three lists, gridNames, startTimes, endTimes
#The index of each list represents a start time, endtime, and origin grid for each search.
#outputs empty start and end times if cannot find pattern in textgrids on this tier.
#cannot handle a tier other than phoneme, immediate neighbor, syllable, word 
get_timestamps_for_neighbor <- function(regex, allGrids) {
  startTimes = list()
  endTimes = list()
  gridNames = list()
  leftRegex = list()
  rightRegex = list()
  
  for (index in 1:length(allGrids[[1]])) {
    name <- allGrids[[1]][[index]]
    grid <- allGrids[[2]][[index]]
    #search the phone tier
    t <- grid[["phones"]]
    
    #find intervals for this regex
    if (!is.null(t)) {
      index_of_regex <- which(t@labels == regex)
      for (x in index_of_regex) {

        #find neighbors' index_of_regex
        leftIndex <- max((x-1),1)
        rightIndex <- min((x+1), length(t@labels))
        left_neighbor_start <- t@startTimes[leftIndex]
        right_neighbor_end <- t@endTimes[rightIndex]
        #add to lists
        startTimes <- append(startTimes, left_neighbor_start)
        endTimes <- append(endTimes, right_neighbor_end)
        #Grid name
        gridNames <- append(gridNames, name)
        #left and right neighbor regex
        leftRegex <- append(leftRegex, t@labels[leftIndex])
        rightRegex <- append(rightRegex, t@labels[rightIndex])
      }
    }
  }
  return(list(gridNames, startTimes, endTimes, leftRegex, rightRegex))
}

#given a vector of X-SAMPA symbols, OR a string of X_SAMPA symbols, returns its IPA equivalent
#NOTE in X-SAMPA, when a backslash is used it MUST be replaced by 2 backslashes to avoid parsing errors for R
translate_sampa <- function(sampa_vector){
  return(convert_phonetics(sampa_vector, from = "xsampa", to = "ipa"))
}

#given a vector of ascii/ipa symbols, OR a string of ascii symbols, returns its X_SAMPA equivalent
#NOTE in X-SAMPA, when a backslash is used it MUST be replaced by 2 backslashes to avoid parsing errors for R
translate_ipa <- function(ipa_vector){
  return(convert_phonetics(ipa_vector, from = "ipa", to = "xsampa"))
}
