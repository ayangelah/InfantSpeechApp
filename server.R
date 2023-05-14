library(howler)

server <- function(input, output) {
  NewSection = "https://cdn.pixabay.com/download/audio/2022/05/16/audio_db6591201e.mp3"
  #observeEvent(input$number, changeHowlerSeek("howler", input$number))
  #observeEvent(input$track, changeHowlerTrack("howler", input$track))
  #output$howleroutput <- renderHowler({
    #howler(
    #  source("/audio.mp3"),
    #  seek.connection(where=100))
  #})
}