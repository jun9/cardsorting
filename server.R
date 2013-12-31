library(shiny)
library(reshape2)
library(vegan)
library(ggdendro)
library(ape)

shinyServer(function(input, output) {
  data <- reactive({
    inFile <- input$file1
    
    if (is.null(inFile))
      inFile$datapath='www/test.csv'
    
    csv <- read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote, fileEncoding=input$encoding)
    return(csv)  
  })
  
  output$table <- renderTable(data())
  
  cs.hc <-reactive({
    csv<-data()
    if (is.null(csv))
      return(NULL)
    cs=melt(csv, measure.vars=1:ncol(csv))
    colnames(cs)=c('label', 'std.cat')
    t=dcast(cs, label ~ std.cat, length)
    if (input$hc_dist=='jaccard')
      cs.dist =vegdist(t[,-1], method='jaccard')
    else
      cs.dist= dist(t[,-1], method=input$hc_dist)
    cs.hc=hclust(cs.dist, method=input$hc_meth)
    cs.hc$labels=t[,1]
    return(cs.hc)
  })
  
  output$grouptable= renderDataTable({
    t=cutree(cs.hc(), k=1:input$groupt)
    t=cbind(row.names(t),t)
  })
  
  output$plot <- renderPlot({
    plot(cs.hc(), family='serif', cex=.8,  xlab='cardsorting') 
    rect.hclust(cs.hc(), k=input$groups, border="red")
  })
  
  output$dendroplot <- renderPlot({
    #plot(as.phylo(cs.hc()), cex = 1)
    print(ggdendrogram(cs.hc(), rotate=T, cex=.8, theme_dendro = F))
  })

  output$summary <- renderPrint({
    summary(data(), maxsum=100)
  })
})

