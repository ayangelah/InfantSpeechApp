library(shiny)
library(howler)
library(tuneR)

tracks <- c("https://cdn.pixabay.com/download/audio/2022/05/16/audio_db6591201e.mp3", "ShinyApp/audio1.mp3", "ShinyApp/audio2.mp3")

#adds resource path
addResourcePath("aud", "./audio")
audio_files <- file.path("aud", list.files("./audio", ".wav$"))

#makes temp file of clipped local file
japanese_local_file <- file.path("./audio", "Japanese.wav")
temp_file <- file.path("./audio", "temp.wav")
writeWave(readWave(japanese_local_file, from=10, to=30, units="seconds"), filename=temp_file)
seeked_audio_file <- file.path("aud", "temp.wav");

#debug console local file
print(paste0(audio_files))

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
  
  #option 1 for howler UI
  howler::howlerModuleUI(
    id = "sound2",
    files = list(
      seeked_audio_file
    )
  ),
  
  #option 2 for howler UI
  title = "howler.js Player",
  howler(seeked_audio_file, elementId = "sound"),
  howlerCurrentTrack("sound"),
  p(
    howlerSeekTime("sound"),
    "/",
    howlerDurationTime("sound")
  ),
  howlerPlayPauseButton("sound")
)