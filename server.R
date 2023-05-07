library(howler)

server <- function(input, output) {
  #observeEvent(input$number, changeHowlerSeek("howler", input$number))
  #observeEvent(input$track, changeHowlerTrack("howler", input$track))
  output$howleroutput <- renderHowler({
    howler(
      source("/audio.mp3"),
      seek.connection(where=100))
  })
}
