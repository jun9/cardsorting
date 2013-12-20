library(shiny)
library(reshape2)
library(vegan)

shinyServer(function(input, output) {
  data <- reactive({
    inFile <- input$file1
    
    if (is.null(inFile))
      inFile$datapath='www/test.csv'
    
    csv <- read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote, fileEncoding=input$encoding)
    return(csv)  
  })
  
  output$table <- renderTable({
  data()  
  })
  
  cs.hc <-reactive({
    csv<-data()
    if (is.null(csv))
      return(NULL)
    cs=melt(csv, measure.vars=1:ncol(csv))
    colnames(cs)=c('label', 'std.cat')
    t=dcast(cs, label ~ std.cat, length)
    cs.dist =vegdist(t[,-1], method='jaccard')
    cs.hc=hclust(cs.dist, method='ward')
    cs.hc$labels=t[,1]
    return(cs.hc)
  })
  
  output$grouptable= renderDataTable({
    t=cutree(cs.hc(), k=1:input$groups)
    t=cbind(row.names(t),t)
  })
  
  output$plot <- renderPlot({
    plot(cs.hc(), family='Courier') 
    rect.hclust(cs.hc(), k=input$groups, border="red")
  })
  
  output$summary <- renderPrint({
    summary(data())
  })
})
