#
# Copyright (C) 2013-2018 University of Amsterdam
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# When making changes to this file always mention @koenderks as a 
# reviewer in the Pull Request

# This analysis is based on the blog post "Number-Bunching: A New Tool for Forensic Data Analysis"
# by Uri Simonsohn which is available at: http://datacolada.org/77.

auditClassicalNumberBunching <- function(jaspResults, dataset, options, ...){
  
  # Create the procedure paragraph
  .jfaNumberBunchingAddProcedure(options, jaspResults, position = 1)
  
  # Read in the data 
  dataset <- .jfaBenfordsLawReadData(dataset, options)
  
  # Perform early error checks
  .jfaBenfordsLawDataCheck(dataset, options)
  
  # Ready for analysis
  ready <- .jfaBenfordsLawReadyCheck(options)
  
  numberBunchingContainer <- .jfaNumberBunchingStage(options, jaspResults, position = 2)
  
  # --- TABLES
  
  .jfaTableNumberInit(jaspResults) # Initialize table numbers
  
  # Create the goodness-of-fit table
  .jfaNumberBunchingTable(dataset, options, numberBunchingContainer, jaspResults, ready, positionInContainer = 1)
  
  # Create the correlation table
  .jfaNumberBunchingCorrelationTable(dataset, options, numberBunchingContainer, jaspResults, ready, positionInContainer = 2)
  
  # Create the observed counts table                                
  .jfaNumberBunchingDescriptivesTable(dataset, options, numberBunchingContainer, jaspResults, ready, positionInContainer = 3)
  
  # ---
  
  # --- PLOTS
  
  .jfaFigureNumberInit(jaspResults) # Initialize figure numbers
  
  # Create the observed versus expected plots
  .jfaNumberBunchingSimulationPlots(dataset, options, numberBunchingContainer, jaspResults, ready)
  
  # Create the frequency plot of individual values
  .jfaNumberBunchingHistorgramPlot(dataset, options, numberBunchingContainer, jaspResults, ready, positionInContainer = 6)
  
  # ---
  
  # Create the conclusion paragraph
  .jfaNumberBunchingAddConclusion(options, numberBunchingContainer, jaspResults, ready, position = 3)
  
  # ---
}

.jfaNumberBunchingAddProcedure <- function(options, jaspResults, position){
  
  if(options[["explanatoryText"]] && is.null(jaspResults[["procedureContainer"]])){
    
    procedureContainer 			<- createJaspContainer(title = gettext("<u>Procedure</u>"))
    procedureContainer$position <- position
    
    confidenceLabel <- paste0(round((1 - options[["confidence"]]) * 100, 2), "%")
    procedureText 	<- gettextf("This procedure analyzes the frequency with which values get repeated within a data set to statistically identify whether the data were likely tampered with. Unlike Benford's law, and its generalizations, this approach examines the entire number at once, not only the first or last digit.\n\nTo determine whether the data show an excessive amount of repeated values, the null hypothesis that the data do not contain an unexpected amount of repeated values is tested with a type-I error of <b>%1$s</b>. To quantify what is expected, this test requires the assumption that the integer portions of the numbers are not associated with their decimal portions.", confidenceLabel)
    
    procedureContainer[["procedureParagraph"]] <- createJaspHtml(procedureText, "p")
    procedureContainer[["procedureParagraph"]]$position <- 1
    procedureContainer$dependOn(options = c("explanatoryText", "confidence"))
    
    jaspResults[["procedureContainer"]] <- procedureContainer
  }
}

.jfaNumberBunchingStage <- function(options, jaspResults, position){
  
  numberBunchingContainer <- createJaspContainer(title = gettext("<u>Assessing repeated values</u>"))
  numberBunchingContainer$position <- position
  numberBunchingContainer$dependOn(options = c("values"))
  
  jaspResults[["numberBunchingContainer"]] <- numberBunchingContainer
  
  return(numberBunchingContainer)
}

.jfaNumberBunchingTable <- function(dataset, options, numberBunchingContainer, jaspResults, ready, positionInContainer){
  
  .jfaTableNumberUpdate(jaspResults)
  
  if(!is.null(numberBunchingContainer[["numberBunchingTestTable"]])) 
    return()
  
  tableTitle <- gettextf("<b>Table %i.</b> Repeated Values Test", 
                         jaspResults[["tabNumber"]]$object)
  
  table <- createJaspTable(tableTitle)
  table$position <- positionInContainer
  table$dependOn(options = c("noSamples", "shuffle", "seed", "values", "avgFrequency", "entropy"))
  
  table$addColumnInfo(name = 'name', 	title = '', 						type = 'string')
  table$addColumnInfo(name = 'N', 		title = gettext("N"), 				type = 'integer')
  if(options[["avgFrequency"]]){					  
  table$addColumnInfo(name = 'avgFreq', title = gettext('Average'), 		type = 'number', overtitle = gettext('Frequency'))
  table$addColumnInfo(name = 'pvalue1', title = gettext("<i>p</i> value"), 	type = 'pvalue', overtitle = gettext('Frequency'))
  }
  if(options[["entropy"]]){
  table$addColumnInfo(name = 'entropy', title = gettext('<i>S</i>'), 		type = 'number', overtitle = gettext('Entropy'))
  table$addColumnInfo(name = 'pvalue2', title = gettext("<i>p</i> value"), 	type = 'pvalue', overtitle = gettext('Entropy'))
  }					  
  
  table$addFootnote(gettextf("Both <i>p</i> values are one-sided and are computed on the basis of %1$s samples.", 
  							  options[["noSamples"]], 
							  switch(options[["shuffle"]], "lastTwo" = "first two decimals", "last" = "second decimal", "all" = "all decimals")))
  
  numberBunchingContainer[["numberBunchingTestTable"]] <- table
  
  if(!ready){
    row <- data.frame(name = ".", N = ".")
	if(options[["avgFrequency"]])
		row <- cbind(row, avgFreq = ".", pvalue1 = ".")
	if(options[["entropy"]])
		row <- cbind(row, entropy = ".", pvalue2 = ".")
    table$addRows(row)
    return()
  }
  
  state <- .jfaNumberBunchingState(dataset, options, jaspResults, ready)
  
  row <- data.frame(name = options[["values"]], N = state[["N"]])
  if(options[["avgFrequency"]])
	row <- cbind(row, avgFreq = state[["avgFrequency"]], pvalue1 = state[["pvalueAvgFrequency"]])
  if(options[["entropy"]])
  	row <- cbind(row, entropy = state[["entropy"]], pvalue2 = state[["pvalueEntropy"]])
  table$addRows(row)    
}

.jfaNumberBunchingState <- function(dataset, options, jaspResults, ready){
  
  if(!is.null(jaspResults[["state"]])){
    
    return(jaspResults[["state"]]$object)
    
  } else if(ready){
    
    variable 	<- dataset[, options[["values"]]]
    
    if(options[["shuffle"]] == "last"){
      variable 	<- variable * 10
      integers 	<- ifelse(variable > 0, yes = floor(variable), no = ceiling(variable))
      decimals 	<- round(variable - integers, 1)
    } else if(options[["shuffle"]] == "lastTwo"){
      integers 	<- ifelse(variable > 0, yes = floor(variable), no = ceiling(variable))
      decimals 	<- round(variable - integers, 2)
    } else if(options[["shuffle"]] == "all"){
	  integers 	<- ifelse(variable > 0, yes = floor(variable), no = ceiling(variable))
	  decimals <- variable - integers
	}
    
    avgFrequency 	<- .jfaAverageFrequency(variable)
    entropy 		<- .jfaEntropy(variable)
    
    bsAvgFreq 		<- numeric(options[["noSamples"]])
    bsEntropy 		<- numeric(options[["noSamples"]])
    
    startProgressbar(options[["noSamples"]])
    set.seed(options[["seed"]])
    
    for(i in 1:options[["noSamples"]]){
      sim 			<- ifelse(integers > 0, yes = integers + sample(decimals), no = integers - sample(decimals))
      bsAvgFreq[i] 	<- .jfaAverageFrequency(sim)
      bsEntropy[i] 	<- .jfaEntropy(sim)
      progressbarTick()
    }
    
    state 							<- list()
    state[["N"]] 					<- length(variable)
    state[["avgFrequency"]] 		<- avgFrequency
    state[["entropy"]] 				<- entropy
    state[["pvalueAvgFrequency"]] 	<- ifelse(state[["avgFrequency"]] > median(bsAvgFreq), yes = mean(bsAvgFreq >= state[["avgFrequency"]]), no = mean(bsAvgFreq <= state[["avgFrequency"]]))
    state[["pvalueEntropy"]] 		<- ifelse(state[["entropy"]] > median(bsEntropy), yes = mean(bsEntropy >= state[["entropy"]]), no = mean(bsEntropy <= state[["entropy"]]))
    state[["counts"]] 				<- as.numeric(table(factor(table(variable), levels = 1:9)))
    state[["proportions"]] 			<- state[["counts"]] / state[["N"]]
    state[["valueCor"]] 			<- cor.test(integers, decimals)
    state[["simCor"]] 				<- cor.test(bsAvgFreq, bsEntropy)
    state[["bsAvgFreq"]] 			<- bsAvgFreq
    state[["bsEntropy"]] 			<- bsEntropy
    
    jaspResults[["state"]] <- createJaspState(state)
    jaspResults[["state"]]$dependOn(options = c("noSamples", "shuffle", "seed", "values"))
    
    return(jaspResults[["state"]]$object)
    
  } else {
    return(list())
  }
}

.jfaNumberBunchingCorrelationTable <- function(dataset, options, numberBunchingContainer, jaspResults, 
                                               ready, positionInContainer){
  
  if(!options[["correlationTable"]])
    return()
  
  .jfaTableNumberUpdate(jaspResults)
  
  if(is.null(numberBunchingContainer[["correlationTable"]])){
    
    tableTitle <- gettextf("<b>Table %i.</b> Assumption Checks",
                           jaspResults[["tabNumber"]]$object)
    
    table <- createJaspTable(tableTitle)
    table$position <- positionInContainer
    
    table$dependOn(options = c("correlationTable", "values", "noSamples", "seed", "shuffle", "avgFrequency", "entropy"))
    
    table$addColumnInfo(name = 'var1', 		title = "", 					   type = 'string')
    table$addColumnInfo(name = 'separator', title = "", 					   type = 'separator')
    table$addColumnInfo(name = 'var2', 		title = "", 					   type = 'string')
    table$addColumnInfo(name = 'n', 		title = gettext("n"), 			   type = 'integer')
    table$addColumnInfo(name = 'cor', 		title = gettext('r'), 			   type = 'number')
    table$addColumnInfo(name = 't', 		title = gettext('t'), 			   type = 'number')
    table$addColumnInfo(name = 'df', 		title = gettext('df'), 			   type = 'integer')
    table$addColumnInfo(name = 'pvalue',	title = gettext("<i>p</i> value"), type = 'pvalue')
    
    table$addFootnote(gettext("The displayed <i>p</i> value is for a two-sided test against H\u2080: <i>r = 0</i>."))
    
    numberBunchingContainer[["correlationTable"]] <- table
    
    if(!ready){ 
		if(options[["avgFrequency"]] && options[["entropy"]]){
      row <- data.frame(var1 = c("Integer values", "Samples frequency"), separator = c("-", "-"),
                        var2 = c("Decimal values", "Samples entropy"), n = c(".", "."),
                        cor = c(".", "."), t = c(".", "."), df = c(".", "."), pvalue = c(".", "."))
		} else {
			      row <- data.frame(var1 = "Integer values", separator = "-", var2 = "Decimal values",
                        n = ".", cor = ".", t = ".", df = ".", pvalue = ".")
		}
      table$addRows(row)
      return()
    } 
    
    state <- .jfaNumberBunchingState(dataset, options, jaspResults, ready)
    
	if(options[["avgFrequency"]] && options[["entropy"]]){
    row <- data.frame(var1 = c("Integer values", "Samples frequency"), 
                      separator = c("-", "-"),
                      var2 = c("Decimal values", "Samples entropy"),
                      n = c(nrow(dataset), options[["noSamples"]]),
                      cor = c(state[["valueCor"]]$estimate, state[["simCor"]]$estimate),
                      t = c(state[["valueCor"]]$statistic, state[["simCor"]]$statistic),
                      df = c(state[["valueCor"]]$parameter, state[["simCor"]]$parameter),
                      pvalue = c(state[["valueCor"]]$p.value, state[["simCor"]]$p.value))
	} else {
    row <- data.frame(var1 = "Integer values", 
                      separator = "-",
                      var2 = "Decimal values",
                      n = nrow(dataset),
                      cor = state[["valueCor"]]$estimate,
                      t = state[["valueCor"]]$statistic,
                      df = state[["valueCor"]]$parameter,
                      pvalue = state[["valueCor"]]$p.value)		
	}
    table$addRows(row)
  }
}

.jfaNumberBunchingDescriptivesTable <- function(dataset, options, numberBunchingContainer, jaspResults, 
                                                ready, positionInContainer){
  
  if(!options[["summaryTable"]])
    return()
  
  .jfaTableNumberUpdate(jaspResults)
  
  if(is.null(numberBunchingContainer[["numberBunchingTable"]])){
    
    tableTitle <- gettextf("<b>Table %i.</b> Frequencies",
                           jaspResults[["tabNumber"]]$object)
    
    table <- createJaspTable(tableTitle)
    table$position <- positionInContainer
    
    table$dependOn(options = c("summaryTable", "values"))
    
    table$addColumnInfo(name = 'values', title = gettext("Value"), type = 'integer')
    table$addColumnInfo(name = 'counts', title = gettext('Count'), type = 'integer')
    table$addColumnInfo(name = 'percentage', title = gettext('Percentage'), type = 'string')
    
    numberBunchingContainer[["numberBunchingTable"]] <- table
    
    if(!ready)
      return()
    
    variable   <- dataset[, options[["values"]]]
    tab        <- table(variable)
    values     <- as.numeric(names(tab))
    counts     <- as.numeric(tab)
    percentage <- paste0(round(counts / length(variable) * 100, 2), "%")
    
    row <- data.frame(values = values, 
                      counts = counts, 
                      percentage = percentage)
    row <- row[order(-row$counts, row$values),]
    
    table$addRows(row)
  }
}

.jfaNumberBunchingSimulationPlots <- function(dataset, options, numberBunchingContainer, jaspResults, ready){

  # Create the observed versus expected average frequency plot
  if(options[["avgFrequency"]])
  .jfaNumberBunchingFrequencyPlot(dataset, options, numberBunchingContainer, jaspResults, ready, positionInContainer = 4)
  
  # Create the observed versus expected entropy plot
  if(options[["entropy"]])
  .jfaNumberBunchingEntropyPlot(dataset, options, numberBunchingContainer, jaspResults, ready, positionInContainer = 5)

}

.jfaNumberBunchingFrequencyPlot <- function(dataset, options, numberBunchingContainer, jaspResults, 
                                            ready, positionInContainer){
  
  if(!options[["numberBunchingSimulationPlots"]])
    return()
  
  .jfaFigureNumberUpdate(jaspResults)
  
  if(is.null(numberBunchingContainer[["numberBunchingPlotFrequency"]])){
    
    plot <- createJaspPlot(plot = NULL, 
                           title = gettext("Observed vs. Expected Average Frequency"), 
                           width = 600, height = 400)
    
    plot$position <- positionInContainer
    plot$dependOn(options = c("numberBunchingSimulationPlots", "noSamples", "seed", "shuffle", "avgFrequency"))
    
    numberBunchingContainer[["numberBunchingPlotFrequency"]] <- plot
    
    if(!ready) 
      return()
    
    state <- .jfaNumberBunchingState(dataset, options, jaspResults, ready)
    
    xBreaks <- jaspGraphs::getPrettyAxisBreaks(c(state[["bsAvgFreq"]], state[["avgFrequency"]]))
    yBreaks <- jaspGraphs::getPrettyAxisBreaks(c(hist(state[["bsAvgFreq"]], plot = F)$counts + 100, 0))
    
    if(state[["avgFrequency"]] > median(state[["bsAvgFreq"]])){
      hjust <- -0.2
      if(state[["avgFrequency"]] > max(state[["bsAvgFreq"]]))
        hjust <- 1.2
    } else {
      hjust <- 1.2
      if(state[["avgFrequency"]] < min(state[["bsAvgFreq"]]))
        hjust <- -0.2
    }
    
    plotData <- data.frame(x = state[["bsAvgFreq"]])
    
    p <- ggplot2::ggplot(data = plotData, mapping = ggplot2::aes(x = x)) +
      ggplot2::scale_x_continuous(name = gettext("Average frequency"), limits = range(xBreaks), breaks = xBreaks) +
      ggplot2::scale_y_continuous(name = gettext("Simulated frequency"), limits = range(yBreaks), breaks = yBreaks) +
      ggplot2::geom_histogram(fill = "darkgray", color = "black", size = 1, breaks = hist(state[["bsAvgFreq"]], plot = F)$breaks) +
      ggplot2::geom_segment(x = state[["avgFrequency"]], xend = state[["avgFrequency"]], y = 0, yend = max(yBreaks), 
                            linetype = "dashed", size = 1, color = "dodgerblue") +
      ggplot2::annotate(geom = "text", x = state[["avgFrequency"]], y = yBreaks[length(yBreaks)-1] + (yBreaks[2]/3*2), label = "Observed", color = "dodgerblue", size = 7, hjust = hjust)
    
    p <- jaspGraphs::themeJasp(p, legend.position = "none")
    
    plot$plotObject <- p
  }
  
  if(options[["explanatoryText"]]){
    
    plotText <- createJaspHtml(gettextf("<b>Figure %i:</b> The expected average frequencies of values versus the observed average frequency in the data set.", jaspResults[["figNumber"]]$object), "p")
    
    plotText$position <- positionInContainer + 1
    plotText$dependOn(optionsFromObject = numberBunchingContainer[["numberBunchingPlotFrequency"]])
    numberBunchingContainer[["numberBunchingPlotFrequencyText"]] <- plotText
  }
}

.jfaNumberBunchingEntropyPlot <- function(dataset, options, numberBunchingContainer, jaspResults, 
                                          ready, positionInContainer){
  
  if(!options[["numberBunchingSimulationPlots"]])
    return()
  
  .jfaFigureNumberUpdate(jaspResults)
  
  if(is.null(numberBunchingContainer[["numberBunchingPlotEntropy"]])){
    
    plot <- createJaspPlot(plot = NULL, 
                           title = gettext("Observed vs. Expected Entropy"), 
                           width = 600, height = 400)
    
    plot$position <- positionInContainer
    plot$dependOn(options = c("numberBunchingSimulationPlots", "noSamples", "seed", "shuffle", "entropy"))
    
    numberBunchingContainer[["numberBunchingPlotEntropy"]] <- plot
    
    if(!ready) 
      return()
    
    state <- .jfaNumberBunchingState(dataset, options, jaspResults, ready)
    
    xBreaks <- jaspGraphs::getPrettyAxisBreaks(c(state[["bsEntropy"]], state[["entropy"]]))
    yBreaks <- jaspGraphs::getPrettyAxisBreaks(c(hist(state[["bsEntropy"]], plot = F)$counts + 100, 0))
    
    if(state[["entropy"]] > median(state[["bsEntropy"]])){
      hjust <- -0.2
      if(state[["entropy"]] > max(state[["bsEntropy"]]))
        hjust <- 1.2
    } else {
      hjust <- 1.2
      if(state[["entropy"]] < min(state[["bsEntropy"]]))
        hjust <- -0.2
    }
    
    
    plotData <- data.frame(x = state[["bsEntropy"]])
    
    p <- ggplot2::ggplot(data = plotData, mapping = ggplot2::aes(x = x)) +
      ggplot2::scale_x_continuous(name = gettext("Entropy"), limits = range(xBreaks), breaks = xBreaks) +
      ggplot2::scale_y_continuous(name = gettext("Simulated frequency"), limits = range(yBreaks), breaks = yBreaks) +
      ggplot2::geom_histogram(fill = "darkgray", color = "black", size = 1, breaks = hist(state[["bsEntropy"]], plot = F)$breaks) +
      ggplot2::geom_segment(x = state[["entropy"]], xend = state[["entropy"]], y = 0, yend = max(yBreaks), 
                            linetype = "dashed", size = 1, color = "dodgerblue") +
      ggplot2::annotate(geom = "text", x = state[["entropy"]], y = yBreaks[length(yBreaks)-1] + (yBreaks[2]/3*2), label = "Observed", color = "dodgerblue", size = 7, hjust = hjust)
    
    p <- jaspGraphs::themeJasp(p, legend.position = "none")
    
    plot$plotObject <- p
  }
  
  if(options[["explanatoryText"]]){
    
    plotText <- createJaspHtml(gettextf("<b>Figure %i:</b> The expected entropy of values versus the observed entropy in the data set.", jaspResults[["figNumber"]]$object), "p")
    
    plotText$position <- positionInContainer + 1
    plotText$dependOn(optionsFromObject = numberBunchingContainer[["numberBunchingPlotEntropy"]])
    numberBunchingContainer[["numberBunchingPlotEntropyText"]] <- plotText
  }
}

.jfaNumberBunchingHistorgramPlot <- function(dataset, options, numberBunchingContainer, jaspResults, 
                                             ready, positionInContainer){
  
  if(!options[["numberBunchingHistogram"]])
    return()
  
  .jfaFigureNumberUpdate(jaspResults)
  
  if(is.null(numberBunchingContainer[["numberBunchingHistogram"]])){
    
    plot <- createJaspPlot(plot = NULL, 
                           title = gettext("Histogram of Individual Values"), 
                           width = 600, height = 400)
    
    plot$position <- positionInContainer
    plot$dependOn(options = c("numberBunchingHistogram", "noHeads"))
    
    numberBunchingContainer[["numberBunchingHistogram"]] <- plot
    
    if(!ready) 
      return()
    
    variable <- dataset[, options[["values"]]]
    tab <- table(variable)
    plotData <- data.frame(x = as.numeric(names(tab)), y = as.numeric(tab))
    
    xBreaks <- jaspGraphs::getPrettyAxisBreaks(plotData$x)
    yBreaks <- jaspGraphs::getPrettyAxisBreaks(c(0, max(plotData$y) + 3))
    
    p <- ggplot2::ggplot(data = plotData, mapping = ggplot2::aes(x = x, y = y)) +
      ggplot2::scale_x_continuous(name = options[["values"]], limits = range(xBreaks), breaks = xBreaks) +
      ggplot2::scale_y_continuous(name = gettext("Frequency"), limits = range(yBreaks), breaks = yBreaks) +
      ggplot2::geom_bar(fill = "black", color = "black", size = 0.2, stat = "identity")
    
    if(options[["noHeads"]] != 0){
      maxx <- plotData$x[order(-plotData$y)][1:options[["noHeads"]]]
      maxy <- plotData$y[order(-plotData$y)][1:options[["noHeads"]]]
      maxData <- data.frame(x = maxx, y = maxy)
      p <- p + ggrepel::geom_text_repel(ggplot2::aes(label = x, x = x, y = y), data = maxData, vjust = 1, size = 5)
    }
    
    jfaTheme <- ggplot2::theme(panel.grid.major.y = ggplot2::element_line(color = "#cbcbcb", size = 0.5))
    
    p <- jaspGraphs::themeJasp(p, legend.position = "none") + jfaTheme
    
    plot$plotObject <- p
  }
  
  if(options[["explanatoryText"]]){
    
    plotText <- createJaspHtml(gettextf("<b>Figure %i:</b> Histogram of the individual values in the data set.", jaspResults[["figNumber"]]$object), "p")
    
    plotText$position <- positionInContainer + 1
    plotText$dependOn(optionsFromObject = numberBunchingContainer[["numberBunchingHistogram"]])
    numberBunchingContainer[["numberBunchingHistogramText"]] <- plotText
  }
}

.jfaNumberBunchingAddConclusion <- function(options, numberBunchingContainer, jaspResults, ready, position){
  
  if(!is.null(jaspResults[["conclusionContainer"]]) || !ready || !options[["explanatoryText"]])
    return()
  
  conclusionContainer <- createJaspContainer(title= gettext("<u>Conclusion</u>"))
  conclusionContainer$position <- position
  conclusionContainer$dependOn(options = c("values",
                                           "confidence",
                                           "shuffle",
                                           "explanatoryText",
                                           "noSamples",
                                           "seed"))
  
  confidenceLabel <- paste0(round(options[["confidence"]] * 100, 2), "%")
  
  state <- .jfaNumberBunchingState(dataset = NULL, options, jaspResults, ready)
  
  rejectnull <- state[["pvalueAvgFrequency"]] < (1 - options[["confidence"]])
  conclusion <- if(rejectnull) gettext("is rejected") else gettext("is not rejected")

  pvalue <- format.pval(state[["pvalueAvgFrequency"]], eps = 0.001)
  pvalue <- if(rejectnull) gettextf("%1$s < \u03B1", pvalue) else gettextf("%1$s >= \u03B1", pvalue)
  
  conclusionText <- gettextf("The <i>p</i> value is %1$s and the null hypothesis that the data do not contain an unexpected amount of repeated values <b>%2$s</b>.", pvalue, conclusion)
  
  conclusionContainer[["conclusionParagraph"]] <- createJaspHtml(conclusionText, "p")
  conclusionContainer[["conclusionParagraph"]]$position <- 1
  conclusionContainer$dependOn(options = c("explanatoryText", 
                                           "confidence",
                                           "values",
                                           "digits",
                                           "distribution"))
  
  jaspResults[["conclusionContainer"]] <- conclusionContainer
}

.jfaEntropy <- function(x){
  frequencies <- as.numeric(table(x))
  # Probailities instead of frequencies
  prob <- frequencies / sum(frequencies)
  logProb <- log(prob)
  # Compute sum(p*log(p))
  entropy <- -sum(ifelse(!is.infinite(logProb), prob*logProb, 0))
  return(entropy) 
}

#0.3 Average frequency function
.jfaAverageFrequency <- function(x){
  tx <- table(x)
  af <- sum(tx^2)/sum(tx)
  return(af)
}