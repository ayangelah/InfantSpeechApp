library(shiny)
library(howler)

ui <- fluidPage(
  titlePanel("Infant Speech App"),
  fluidRow (
    #IPA Input
    column(2,
      textInput("text", h3("IPA:"), value = "Enter text...")
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
    sidebarPanel (
      #audio Panel
      h1("audio panel"),
    )
  ),
  h1("Howler Audio Player"),
  howler::howlerModuleUI(
    id = "sound",
    files = list(
      "Winning Elevation" = "https://cdn.pixabay.com/download/audio/2022/05/16/audio_db6591201e.mp3"
    )
  ),
  howler::howlerBasicModuleUI(
    id = "sound2",
    files = list(
      "Winning Elevation" = "https://cdn.pixabay.com/download/audio/2022/05/16/audio_db6591201e.mp3"
    )
  )
)