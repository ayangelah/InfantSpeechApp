library(howler)

server <- function(input, output) {
  output$selected_ipa <- renderText({
    paste("you have entered", input$ipa)
  })
  
  output$selected_tier <- renderText({
    paste("You have selected", input$tier)
  })
}