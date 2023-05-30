library(textgRid)

# load_textGrids: func for gatherings and loading all textGrids
#allGrids is a list of gridNames and TextGrids (see textgRid for formats)
load_textGrids <- function(){
  addResourcePath("text", "./textgrid")
  grid_files <- file.path("textgrid", list.files("./textgrid", ".TextGrid$"))
  allGrids <- lapply(grid_files, TextGrid)
  return(list(grid_files, allGrids))
}

#input: a regex to search for, a tier to search on, and a list of loaded textGrids. Output: three lists, gridNames, startTimes, endTimes
#The index of each list represents a start time, endtime, and origin grid for each search.
#outputs empty start and end times if cannot find pattern in textgrids on this tier.
get_timestamps_for <- function(regex, tier, allGrids) {
  startTimes = list()
  endTimes = list()
  gridNames = list()
  for (index in 1:length(allGrids[[1]])) {
    name <- allGrids[[1]][[index]]
    grid <- allGrids[[2]][[index]]
    #search the correct tier
    t <- grid[[tier]]
    #find intervals for this regex
    intervals <- findIntervals(tier=t, pattern=regex)
    #add to lists
    startTimes <- append(startTimes, intervals$StartTime)
    endTimes <- append(endTimes, intervals$EndTime)
    #Grid name
    for (x in intervals$StartTime) {
      gridNames <- append(gridNames, name)
    }
  }
  #return object
  return(list(gridNames, startTimes, endTimes))
}

