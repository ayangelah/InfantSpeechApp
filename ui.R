library(shiny)
library(howler)
library(tuneR)

tracks <- c("https://cdn.pixabay.com/download/audio/2022/05/16/audio_db6591201e.mp3", "ShinyApp/audio1.mp3", "ShinyApp/audio2.mp3")

#NewSection<-readWave("/Japanese.wav", from=10, to=30, units="seconds")

audio_files_dir <- system.file("./audio", package = "howler")
addResourcePath("ShinyApp", audio_files_dir)
audio_files <- file.path("ShinyApp", list.files(audio_files_dir, ".wav$"))

ui <- fluidPage(
  titlePanel("Infant Speech App"),
  fluidRow (
    #IPA Input
    column(2,
      textInput("text", h3("IPA:"))
    ),
    #Tier Input
    column(2,
      selectInput("select", h3("TextGrid Tier:"), 
                  choices = list("Phoneme" = 1, "Immediate Neighbor" = 2, "Syllable" = 3, "Word" = 4), selected = 1),
    ),
  ),
  sidebarLayout(
    sidebarPanel(
      #info Panel
      h1("info panel"),
    ),
    mainPanel (
      #audio Panel
      h1("audio panel"),
    )
  ),
  howler::howlerModuleUI(
    id = "sound2",
    files = list(
      "Test" = "NewSection"
    )
  ),
  title = "howler.js Player",
  howler(elementId = "sound", audio_files),
  howlerCurrentTrack("sound"),
  p(
    howlerSeekTime("sound"),
    "/",
    howlerDurationTime("sound")
  ),
  howlerPlayPauseButton("sound")
)