library(howler)
library(tuneR)
source("utils.R")
library(DT)

addResourcePath("aud", "./audio")
audio_files <- file.path("aud", list.files("./audio", ".wav$"))

japanese_local_file <- file.path("./audio", "Japanese.wav")

foo_func <- function(ipa) {
  # Loading in textGrid Files
  allGrids <- load_textGrids()
  print("loaded grids")
  phoneme <- ipa
  tiervar <- "Words"
  searchResults <- get_timestamps_for(regex=phoneme,tier=tiervar,allGrids)
  result <- tagList(h2(paste('Audio Clips of', phoneme, 'in the context of', tiervar)))
  for (x in 1:length(searchResults[[1]])) {
    temp_file <- file.path("./audio", paste0("temp", x, ".wav"))
    writeWave(readWave(japanese_local_file, from=searchResults[[2]][[x]], to=searchResults[[3]][[x]], units="seconds"), filename=temp_file)
    seeked_audio_file <- file.path("aud", paste0("temp", x, ".wav"));
    result <- tagAppendChild(result, tagList(
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
    ))
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
      foo_func(input$ipainput) #note to self: figure out reactivity in function call.
    })
}