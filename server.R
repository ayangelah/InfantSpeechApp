library(howler)
library(tuneR)
library(DT)
source("utils.R")

# Loading in textGrid Files
allGrids <- load_textGrids()
print("loaded grids")

foo_func <- function(ipa, select, allGrids) {
  td <- tempdir()
  addResourcePath("aud", "./audio")
  addResourcePath("tmp", td)
  audio_files <- file.path("aud", list.files("./audio", ".wav$"))
  
  if (select == "neighbor") {
    searchResults <- get_timestamps_for_neighbor(regex=ipa, allGrids)
  }
  else {
    searchResults <- get_timestamps_for(regex=ipa, tierSearch=select, allGrids)
  }
  result <- tagList(h2(paste('Audio Clips of', ipa, 'in the context of', select)))
  #TODO if searchResult is a list of empty list, no match was found for these settings
  #right now a nonfound search results in an out of bounds error
  for (x in 1:length(searchResults[[1]])) {
    #find audio file
    addResourcePath("aud", "./audio")
    audio_files <- file.path("aud", list.files("./audio", ".wav$"))
    file_name <- gsub("textgrid/", "", gsub(".txt", ".wav", searchResults[[1]][[x]]))
    name_local_file <- file.path("./audio", file_name)
    temp_file <- file.path(td, paste0("temp", ipa, x, ".wav"))
    writeWave(readWave(name_local_file, from=searchResults[[2]][[x]], to=searchResults[[3]][[x]], units="seconds"), filename=temp_file)
    seeked_audio_file <- file.path("tmp", paste0("temp", ipa, x, ".wav"));
    if (select == "neighbor") {
    tagListResult <- tagList(
      fluidRow(
        p("from grid: ",
          searchResults[[1]][[x]], 
          " | the start timestamp is: ",
          searchResults[[2]][[x]],
          "lefthand neighbor is: ",
          searchResults[[4]][[x]], 
          " | The end timestamp is: ",
          searchResults[[3]][[x]],
          "righthand neighbor is: ",
          searchResults[[5]][[x]], 
        ),
        howler::howlerModuleUI(
          id = paste0("clip","-",x),
          files = list(
            seeked_audio_file
          )
        )
      )
    )
    }
    else {
      tagListResult <- tagList(
        fluidRow(
          p("from grid: ",
            searchResults[[1]][[x]], 
            " | the start timestamp is: ",
            searchResults[[2]][[x]],
            " | The end timestamp is: ",
            searchResults[[3]][[x]]
          ),
          howler::howlerModuleUI(
            id = paste0("clip","-",x),
            files = list(
              seeked_audio_file
            )
          )
        )
      )
    }
    result <- tagAppendChild(result, tagListResult)
  }
  sidebarPanel(style = "height: 90vh; overflow-y: auto;", result)
}

dummy_loop <- function () {
  result <- tagList(p('bruhhh:'))
  for(x in 1:5) {
    result <- tagAppendChild(result, tagList(p(paste(x))))
  }
  result
}


server <- function(input, output) {
  NewSection = "https://cdn.pixabay.com/download/audio/2022/05/16/audio_db6591201e.mp3"

  output$audiotable <- renderUI({
    validate(
      need(input$ipainput, 'Please Enter a phoneme.')
    )
    foo_func(input$ipainput, input$select, allGrids) #note to self: figure out reactivity in function call.
  })
}