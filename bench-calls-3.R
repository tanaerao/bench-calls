# Bench calls analysis by Tanae Rao
# a) Takes tournament data (in this case, WUDC 2020 and WUDC 2021) and calculates the proportion of bench calls in each round
# b) Runs a 'relative strength' Monte Carlo simulation, yielding expected proportions of bench calls after taking into account motion bias

#general set-up
setwd("~/Documents/R Directory")
library(readxl)
library(dplyr)
library(gtools)
library(ggplot2)
library(stargazer)

#creates a dataframe for every sheet in the motion-balance-dataset excel file, with the same name as the sheet
#file included in Github repo
for (sheet in 1:length(excel_sheets('motion-balance-dataset.xlsx'))) {
  
  sheet_name <- excel_sheets('motion-balance-dataset.xlsx')[sheet]
  
  assign(sheet_name,read_excel('motion-balance-dataset.xlsx',sheet = sheet_name))
  
}

#read tables of simulated relative strength data
#files included in Github repo; produced by running:
#rs_govpoints -> simulate_rs_govpoints(10000,1001)
#rs_benchcalls <- simulate_rs_benchcalls(10000,1001)
rs <- read.csv('relative_strength.csv')
rsfit <- lm(benchcalls ~ poly(govpoints,10,raw=TRUE),data=rs)

#for intervals number of relative strengths evenly spaced from 0 to 1, calculate the mean points won in the round by government teams
simulate_rs <- function(iterations, intervals) {
  
  #initialise a dataframe with relative strength and mean gov points
  output_table <- data.frame(pgovwin = numeric(intervals),
                             govpoints = numeric(intervals),
                             benchcalls = numeric(intervals))
  
  
  
  for (interval in 1:intervals) {
    
    #in each repetition of the for loop, pgovwin increases by an equal amount such that, on the first time, pgovwin=0, and on the last time, pgovwin=1
    pgovwin <- 1-((interval-1)/(intervals-1))
    
    #initialising dataframe to store the results of the round
    teams <- data.frame(og = numeric(iterations),
                        oo = numeric(iterations),
                        cg = numeric(iterations),
                        co = numeric(iterations))
    
    for (i in 1:nrow(teams)) {
      #first, we generate a numerical score for each team
      #opp teams get a standard normal distribution, while gov teams get a mean such that pgovwin = the probability that a gov team would win a (hypothetical) head-to-head match up with an opp team
      teams[i,1] <- rnorm(1, mean = qnorm(pgovwin,0,1), sd = 1)
      teams[i,2] <- rnorm(1, mean = 0, sd = 1)
      teams[i,3] <- rnorm(1, mean = qnorm(pgovwin,0,1), sd = 1)
      teams[i,4] <- rnorm(1, mean = 0, sd = 1)
      
      #convert numerical scores into the number of points each team wins in the round (1st = 3 points, 2nd = 2 points, etc.)
      teams[i,] <- rank(teams[i,]) - 1
      
    }
    #record results for the interval in output_table
    output_table$pgovwin[interval] <- pgovwin
    output_table$govpoints[interval] <- (mean(teams$og) + mean(teams$cg))/2
    output_table$benchcalls[interval] <- output_table$benchcalls[interval] + sum(teams[,1]+teams[,3]==5 | teams[,2]+teams[,4]==5)
    
  }
  output_table$benchcalls <- output_table$benchcalls/iterations
  return(output_table)
  
}

#a vector of the variable names of every dataframe for which we'll calculate the proportion of bench calls
roundsheets <- excel_sheets('motion-balance-dataset.xlsx')

#initialize a data.frame to contain the results of the analysis of WUDC results + simulations
data <- data.frame(benchcall.mean = numeric(length(roundsheets)),
                   benchcall.sd = numeric(length(roundsheets)),
                   nteams = numeric(length(roundsheets)),
                   govpoints.mean = numeric(length(roundsheets)),
                   benchcall.null = numeric(length(roundsheets)),
                   benchcall.total = numeric(length(roundsheets)),
                   nrooms = numeric(length(roundsheets)))

#make the rownames clearly identify the round to which the data in the row corresponds (e.g., 'R1_WUDC_2020')
rownames(data) <- excel_sheets('motion-balance-dataset.xlsx')[-c(1,2)]

#populate data, row by row (round by round)
#this is inefficient, but we don't have to do this for very large numbers of rounds
for (roundnum in 1:length(roundsheets)) {
  
  #call each sheet in roundsheets, one by one in each iteration of the for loop
  varname <- (roundsheets[roundnum])
  varname <- get(varname)
  
  #add resultpoints column to varname, such that a 1st = 3 points, 2nd = 2 points, etc.
  varname$resultpoints <- ifelse(varname$result == '1st', 3,
                                 ifelse(varname$result == '2nd', 2,
                                        ifelse(varname$result == '3rd', 1,0)))
  
  #add nteams column, which equals the number of teams
  data$nteams[roundnum] <- nrow(varname)
  
  #this makes it so that the actual dataframe has all of the above modifications, instead of merely reassigning varname over and over again and losing all of the modifications
  assign(roundsheets[roundnum],varname)
  
  roomids <- levels(factor(varname$adjudicators))
  teamorder <- c('Opening Government','Opening Opposition','Closing Government','Closing Opposition')
  
  nrooms <- 0
  
  #this for loop gets the number of *full* rooms (i.e., rooms for which we have data for every team), which may differ from nteams/4
  #because the same panel of adjudicators cannot judge more than one debate in the same round, we can use the adjudicators column as a unique identifier for each room
  for (room in 1:length(roomids)) {
    
    teamsinroom <- varname[which(varname$adjudicators == roomids[room]),] #the advantage 
    
    if (nrow(teamsinroom) == 4) {
      
      nrooms <- nrooms + 1
    }
  }
  
  #we then initialise a matrix where each row represents the result of a room, e.g., 0 1 2 3 means OG took 0 points (4th), OO took 1 point (3rd), etc.
  #the reason we can't just reshape varname$resultpoints into a 4 by nrooms array is because the WUDC 2020 data is not consistently organised by rooms
  byroom <- t(matrix(0,nrow = 4,ncol=nrooms))
  
  #for loop fills in results in the byroom matrix, row by row
  for (room in 1:length(roomids)) {
    
    teamsinroom <- varname[which(varname$adjudicators == roomids[room]),] 
    
    if (nrow(teamsinroom) == 4) {
      
      teamsinroom <- teamsinroom[match(teamorder,teamsinroom$side),]
      byroom[room,] <- as.vector(teamsinroom$resultpoints)
    }
  }
  
  #add the nrooms figure into data
  data$nrooms[roundnum] <- nrooms
  
  #if OG and CG receive a sum of 5 points (3+2), or the same for OO and CO, add 1 to benchcallcount.
  benchcallcount <- sum((byroom[,1]+byroom[,3]==5 | (byroom[,2]+byroom[,4]==5)))
  
  #from benchcallcount and the number of rooms, record the proportion of bench calls in the round, and the total number of bench calls in the round
  data$benchcall.mean[roundnum] <- benchcallcount/nrow(byroom)
  data$benchcall.total[roundnum] <- benchcallcount
  
  #using a similar method as for benchcallcount, get the mean points won by gov teams (OG and CG) in the round
  data$govpoints.mean[roundnum] <- mean(byroom[,1]+mean(byroom[,3]))/2
  
  #call the govpoints_benchcalls function to get the expected proportion of benchcalls, given motion bias = observed motion bias
  data$benchcall.null[roundnum] <- predict(rsfit,data.frame(govpoints = data$govpoints.mean[roundnum]))
  
  #get the standard deviation of the proportion of benchcalls, and use this to populate the benchcall.sd column
  data$benchcall.sd[roundnum] <- data$benchcall.mean[roundnum]*(1-data$benchcall.mean[roundnum])
}

#with p=2.702e-10, we have enough evidence to reject the null hypothesis that the true probability of a bench call is equal to or lower than 1/3
binom.test(sum(data$benchcall.total),sum(data$nrooms),p=1/3,alternative = c("t"))

# Steps to replicate Figure 1 

#tiff('bench-calls-figure-1.tiff',width=12,height=8,units='in',res=300)

figure1 <- plot(rs$govpoints,rs$benchcalls, type = 'p',cex=0.5, pch =16,col='gray',
                xlab = 'Mean points won by government teams',
                ylab = 'Proportion of bench calls',
                ylim = c(0,1),
                sub = 'Figure 1')

rsfit <- lm(benchcalls ~ poly(govpoints,10,raw=TRUE),data=rs)
rsfitline <- predict(rsfit)
lines(rs$govpoints,rsfitline,col='blue')
grid(NULL,NULL,lty=2,col='lightgray')
points(data$govpoints.mean,data$benchcall.mean, pch=4, col='red')
legend(x='bottomleft',legend = c('Expected proportion of bench calls implied by RS model (polynomial fit)','Proportion of bench calls is 1/3','Data from WUDC 2020 & 2021 inrounds'),
       col=c('blue','darkgreen','cornsilk2','cornsilk2'),lwd=c(1,2), lty=c(1,2),pch=c(NA,NA,NA,NA),bg='cornsilk2')
legend(x='bottomleft',legend = c('Expected proportion of bench calls implied by RS model (polynomial fit)','Proportion of bench calls is 1/3','Data from WUDC 2020 & 2021 inrounds'),
       col=c('red','gray'),lwd=1, lty=c(0),pch=c(NA,NA,4,16),bty='n')
abline(h=1/3,lty=2,lwd=2,col='darkgreen')

#dev.off()

data_to_print <- data[,c(1,7,6,4,5)]

stargazer(data_to_print,type='html',summary=FALSE,title = 'Inrounds bench call frequency; WUDC 2020 & WUDC 2021')
