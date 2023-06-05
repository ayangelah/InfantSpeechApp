library(shiny)
library(howler)
library(tuneR)
source("utils.R")

print("original:")
sampa <- c('a','3','e','Q','p\\', 'r\\`', 's\\','a','[ar_?\\b_?\\@<\\a]' )
print(sampa)
print("IPA:")
IPA <- translate_sampa(sampa)
print(IPA)

#Loading tracks
tracks <- c("https://cdn.pixabay.com/download/audio/2022/05/16/audio_db6591201e.mp3", 
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")

addResourcePath("aud", "./audio")
audio_files <- file.path("aud", list.files("./audio", ".wav$"))

japanese_local_file <- file.path("./audio", "Japanese.wav")
temp_file <- file.path("./audio", "temp.wav")
writeWave(readWave(japanese_local_file, from=10, to=30, units="seconds"), filename=temp_file)
seeked_audio_file <- file.path("aud", "temp.wav");

print(paste0(audio_files))

#UI
ui <- fluidPage(
  fluidRow (
    #IPA Input
    column(2,
      textInput("ipainput", h3("IPA:"), value = "l")
    ),
    #Tier Input
    column(2,
      selectInput("select", h3("TextGrid Tier:"), 
                  choices = list("Phoneme" = 1, "Immediate Neighbor" = 2, "Syllable" = 3, "Word" = 4), selected = 1),
    ),
    column(2,
           selectInput("track", "Select Track", basename(tracks)),
           howler(elementId = "howler", tracks),
           howlerPlayPauseButton("howler")
    ),
  ),
  sidebarLayout(
    sidebarPanel(
      #info Panel
      h1("info panel"),
    ),
    mainPanel (
      uiOutput("audiotable"),
      textOutput("foo_bar")
    )
  ),
)