library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("CardSorting Analysis App"),
  sidebarPanel(
    tags$h5('Try with your own cardsorting result now!'),
    tags$a('Download the example datasheet template here.', href='test.csv'),
    
    numericInput("groups", "Number of groups to explore:", 10),
    tags$hr(),
    fileInput('file1', 'Choose CSV File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator',
                 c(Comma=',',
                   Semicolon=';',
                   Tab='\t'),
                 'Comma'),
    radioButtons('quote', 'Quote',
                 c(None='',
                   'Double Quote'='"',
                   'Single Quote'="'"),
                 'Double Quote'),
    
    radioButtons('encoding', 'Encoding',
                 c(
                   'UTF-8'='UTF-8',
                   'GB2312'="GB2312",
                   'BIG-5'="BIG-5"),
                   'GB2312')
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Table", tableOutput("table")),
      tabPanel("Summary", verbatimTextOutput("summary")), 
      tabPanel("Hierarchical Clustering Dendrogram", plotOutput("plot")),
      tabPanel("Groups", dataTableOutput("grouptable"))
    )
    )
))
