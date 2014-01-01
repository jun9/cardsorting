library(shiny)

  hc_method <- list("Ward's" = "ward", "Single" = "single", "Complete" = "complete", "Average" = "average", 
                      "McQuitty" =  "mcquitty", "Median" = "median", "Centroid" = "centroid")
  hc_dist_method <- c("jaccard", "euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski")

  shinyUI(pageWithSidebar(
  headerPanel("CardSorting Analysis App"),
  sidebarPanel(
    tags$a('Check out the source code at GitHub.', href='https://github.com/jun9/cardsorting'),
    tags$h5('Try it with your own cardsorting data now!'),
    tags$a('Download the example datasheet template here.', href='test.csv'),
    tags$a("Download Donna Spencer's example datasheet.", href='iasumit.example.std.csv'),    
    tags$a("(Reference)", href="http://rosenfeldmedia.com/blogs/card-sorting/card-sort-analysis-spreadsheet/"),
    tags$hr(),
    fileInput('file1', 'Upload CSV File in the above template format only. 
              Internet Explorer 9 and older browsers not supported.',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    helpText('Options: Use only when you know what you are doing'),
    checkboxInput('customCSV', 'Custom CSV format/encoding options', F),
    
    conditionalPanel(
        condition = 'input.customCSV',
        checkboxInput('header', 'With header row', T),
        selectInput('sep', 'Separator',
                    c(Comma=',',
                      Semicolon=';',
                      Tab='\t'),
                    'Comma'),
        selectInput('quote', 'Quote',
                    c(None='',
                      'Double Quote'='"',
                      'Single Quote'="'"),
                    'Double Quote'),
        selectInput('encoding', 'Encoding',
                    iconvlist(),
                    'GB2312')
      ),
    
    checkboxInput('customHC', 'Custom distance measure/clustering options', F),
    conditionalPanel(
        condition='input.customHC',
        selectInput("hc_dist", label = "Distance measure:", choices = hc_dist_method, selected = hc_dist_method[1], multiple = FALSE),
        selectInput("hc_meth", label = "Method:", choices = hc_method, selected = hc_method[1], multiple = FALSE)
    )
    #todo: custom dist and hc methods
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Table", tableOutput("table")),
      tabPanel("Summary", verbatimTextOutput("summary")), 
      tabPanel("Dendrogram", plotOutput("dendroplot", height=900)),
      tabPanel("Explore clusters",  
               numericInput("groups", "Choose the number of groups/clusters:", 7 ), 
               plotOutput("plot")),
      tabPanel("Group members", 
               numericInput("groupt", "Choose the number of groups/clusters:", 7 ), 
               dataTableOutput("grouptable"))
      #Todo: download this group membership table.
    )
    )
))

