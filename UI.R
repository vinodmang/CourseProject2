library(shiny)

# Define UI 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("visualization of decision boundaries"),
  
  # Sidebar with controls to select the variable to plot against
  # mpg and to specify whether outliers should be included
  sidebarLayout(
    sidebarPanel(
      radioButtons("tool", "Training Tool:",
                   c("svm" = "Support Vector Machine(svm)")),numericInput("svmCval", "C:",value=.1,min=.1,max=20,step=.1),(numericInput("svmgamma", "Gamma:",value=.1,min=.1,max=20,step=.1)
                                                                                                                           
      
    ),
    p(strong(em("Documentation:",a("Visualization of descision boundaries",href="readme.html")))),
    sidebarPanel()),
    mainPanel(
      plotOutput("out.plot")
    )
  )
))
