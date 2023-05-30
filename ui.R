library(shiny)
library(howler)
library(tuneR)
source("utils.R")

# Loading in textGrid Files
allGrids <- load_textGrids()
print("loaded grids")
searchResults <- get_timestamps_for(regex="l",tier="Words",allGrids)


for (x in 1:length(searchResults[[1]])) {
  print("from grid: ")
  print(searchResults[[1]][[x]])
  print("The start timestamp is: ")
  print(searchResults[[2]][[x]])
  print("The end timestamp is: ")
  print(searchResults[[3]][[x]])
}

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
  titlePanel(textgrid),
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
      howler::howlerModuleUI(
        id = "howler",
        files = list(
          "Winning Elevation" = "https://cdn.pixabay.com/download/audio/2022/05/16/audio_db6591201e.mp3",
          "soundhelix" = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
        )
      ),
      paste0(h)
    )
  ),
  howler::howlerModuleUI(
    id = "sound2",
    files = list(
      seeked_audio_file
    )
  ),
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