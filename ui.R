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

#UI
ui <- fluidPage(
  fluidRow (
    #IPA Input
    column(2,
      textInput("ipainput", h3("IPA:"))
    ),
    #Tier Input
    column(2,
      selectInput("select", h3("TextGrid Tier:"), 
                  choices = list("Phoneme" = "phones", "Immediate Neighbor" = "neighbor", "Syllable" = "syll", "Word" = "words", "Phonology"="phono", "Orthography"="ortho"), selected = "phones"),
    )
  ),
  sidebarLayout(
    sidebarPanel(
      #info Panel
      h1("info panel"),
      actionButton("prev", "Previous"),
      actionButton("nxt", "Next")
    ),
    mainPanel (
      uiOutput("audiotable"),
      textOutput("foo_bar")
    )
  ),
)