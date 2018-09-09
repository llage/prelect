library(shiny)
library(triebeard)
library(stringr)

shinyServer(function(input, output, session) {
	all<-read.csv("all.csv",stringsAsFactors = F)
	thetrie<-trie(all$prediktor,all$predixion)
	output$credits<-renderPrint("LL Agelink, September 2018. Created for the Johns Hopkins Data Science (Coursera) Capstone project. Name of the app was a working title that stuck, I was thinking of words like predict, lecture and predilection.")
	output$Rcredits<-renderPrint("Running on the server: shiny, triebeard, stringr. Used to create the lookup database: ngram (for extracting n-grams), tidytext (for flagging negative/rude words for removal), hunspell (for spell checking), plyr and tidyr (for data manipulation).")
	observeEvent(input$bigbutton, {updateTextInput(session,"typing",value="")})
	observeEvent(input$getpred1, {updateTextInput(session,"typing",value=paste(input$typing,w1()))})
	observeEvent(input$getpred2, {updateTextInput(session,"typing",value=paste(input$typing,w2()))})
	observeEvent(input$getpred3, {updateTextInput(session,"typing",value=paste(input$typing,w3()))})
	observeEvent(input$getbest, {updateTextInput(session,"typing",value=paste(input$typing,wb()))})

	w1 <- function(x=1) {
		string<-gsub("\\s+$","",input$typing)
		set.seed(length(input$typing)+1001)
		if (2>length(input$typing)) prediction1<-sample(all$predixion,1)
		new1<-longest_match(thetrie,paste(word(string,-1)))
		if (is.na(new1)) new1<-longest_match(thetrie,tolower(paste(word(string,-1))))
		if (!is.na(new1)) prediction1<-new1
		prediction1<<-prediction1
		prediction1
	}	
	
	w2 <- function(x=1) {
		string<-gsub("\\s+$","",input$typing)
		set.seed(length(input$typing)+2002)
		prediction2<-sample(all$predixion,1)
		new2<-longest_match(thetrie,paste(word(string,c(-2,-1)),collapse=" "))
		if (is.na(new2)) new2<-longest_match(thetrie,tolower(paste(word(string,c(-2,-1)),collapse=" ")))
		if (!is.na(new2)) prediction2<-new2
		set.seed(length(input$typing)+2222)
		while (prediction1==prediction2) prediction2<-sample(all$predixion,1)
		prediction2<<-prediction2
		prediction2	
	}
	
	w3 <- function(x=1) {
		string<-gsub("\\s+$","",input$typing)
		set.seed(length(input$typing)+3003)
		prediction3<-sample(all$predixion,1)
		new3<-longest_match(thetrie,paste(word(string,c(-3,-2,-1)),collapse=" "))
		if (is.na(new3)) new3<-longest_match(thetrie,tolower(paste(word(string,c(-3,-2,-1)),collapse=" ")))
		if (!is.na(new3)) prediction3<-new3
		while (prediction2==prediction3|prediction1==prediction3) prediction3<-sample(all$predixion,1)
		prediction3<<-prediction3
		prediction3
	}
	
	wb <- function(x=1) {
		#if (nchar(w1())>=nchar(w2())) best<-w1()
		#if (nchar(w2())>nchar(w1())) best<-w2()
		#if (nchar(w3())>=nchar(w2())&&nchar(w3())>nchar(w1())) best<-w3()
		if (nchar(prediction1)>=nchar(prediction2)) best<-w1()
		if (nchar(prediction2)>nchar(prediction1)) best<-w2()
		if (nchar(prediction3)>nchar(prediction2)&&nchar(prediction3)>nchar(prediction1)) best<-w3()
		if (word(input$typing,-1)==best) best<-w1()
		best
	}
		
  output$predictedword1 <- renderText({w1()})
  output$predictedword2 <- renderText({w2()})
  output$predictedword3 <- renderText({w3()})
  output$bestword <- renderText({wb()})
	
})
