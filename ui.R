library(shiny)

shinyUI(fluidPage(
	
	# App title
	titlePanel("Prelect app - Next word prediction"),
	
	# Sidebar
	sidebarLayout(
		sidebarPanel(
			actionButton("bigbutton",label="Clear typed text")
		),
		
		mainPanel(
			tabsetPanel(type="tabs",
				    tabPanel("prediction",textAreaInput("typing",
				    				    width="400px",
				    				    height="200px",
				    				    label="Type here"),
				    	 fluidRow(
				    	 	column(width=4,
				    	 	       actionButton("getpred1",label="Use suggestion 1"),
				    	 	       h3(textOutput("predictedword1")),
				    	 	       HTML("<br/>"),
				    	 	       HTML("<br/>"),
				    	 	       HTML("<br/>"),
				    	 	       h5("Recommended suggestion:",
				    	 	       h3(textOutput("bestword")))),
				    	 	column(width=4,
				    	 	       actionButton("getpred2",label="Use suggestion 2"),
				    	 	       h3(textOutput("predictedword2"))),
				    	 	column(width=4,
				    	 	       actionButton("getpred3",label="Use suggestion 3"),
				    	 	       h3(textOutput("predictedword3"))))),
				    tabPanel("Author",textOutput("credits")),
				    tabPanel("R packages used",textOutput("Rcredits"))
			)
			
		)
	)
)
)