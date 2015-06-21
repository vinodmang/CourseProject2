library(shiny)
library(kernlab)
dat <- moon <- read.csv("./sampledat.csv", 
                        stringsAsFactors=FALSE,
                        colClasses="numeric")


shinyServer(function(input, output) {
  
  output$out.plot <- renderPlot({
    dat$Y = as.factor(dat$Y)
    modelx1x2 <- dat[,-3]
    svmmodel <- ksvm(Y~.,data=dat,kernel="rbfdot",kpar=list(sigma=input$svmgamma),C=input$svmCval,prob.model = T)
    
    pred <- predict(svmmodel,modelx1x2)
    truth <- pred==dat$Y
    accuracy <- sum(truth)*100/length(truth)
    thex1 <- dat[,1]
    thex2 <- dat[,2]
    somex1 <- seq(min(thex1), max(thex1), by=.1)
    somex2 <- seq(min(thex2), max(thex2), length.out=length(somex1))
    z <- matrix(0, nrow=length(somex1), ncol=length(somex1))
    for (i in 1:length(somex1)){
      for (j in 1:length(somex1)){
        z1 <- predict(svmmodel,newdata= data.frame(X1 = somex1[i],X2=somex2[j]),type="probabilities")
        z[i,j] = z1[1]
        
        
      }
    }
    z = z - .5
    plot(dat$X2 ~ dat$X1,  pch=20, 
    col=c("red","green3")[as.numeric(as.character(dat$Y))+1],
    xlab="X1", ylab="X2")
    title(paste("Accuracy:", accuracy))
      
    contour(somex1, t(somex2), z, nlevels=1, add=TRUE, drawlabels=FALSE)
    
  })
  
})
