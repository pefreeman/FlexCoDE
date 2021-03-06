% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/basicFunctions (Cópia em conflito de rizbicki-Gazelle-Professional 2017-10-04).R, R/basicFunctions.R
\name{combineFlexCoDE}
\alias{combineFlexCoDE}
\title{Finds best linear combination of several FlexCoDE estimates}
\usage{
combineFlexCoDE(objectCDE_binded, xValidation, zValidation, xTest = NULL,
  zTest = NULL)

combineFlexCoDE(objectCDE_binded, xValidation, zValidation, xTest = NULL,
  zTest = NULL)
}
\arguments{
\item{objectCDE_binded}{An object of the class FlexCoDE_binded with a fitted CDE, typically fitted used \code{\link{bindFlexCoDE}} beforehand}

\item{xValidation}{Covariates x used to validate (tune) the model (one x observation per row).}

\item{zValidation}{Responses z used to validate (tune) the model  (matrix with 1 column). Each row corresponds to a row of the xValidation argument}

\item{xTest}{Covariates x used to estimate risk of final model (one observation per row; same number of columns as xTrain). Default is NULL}

\item{zTest}{Responses z used to estimate risk of final model  (matrix with one column; one observation per row). Default is NULL}

\item{objectCDE_binded}{An object of the class FlexCoDE_binded with a fitted CDE, typically fitted used \code{\link{bindFlexCoDE}} beforehand}

\item{xValidation}{Covariates x used to validate (tune) the model (one x observation per row).}

\item{zValidation}{Responses z used to validate (tune) the model  (matrix with 1 column). Each row corresponds to a row of the xValidation argument}

\item{xTest}{Covariates x used to estimate risk of final model (one observation per row; same number of columns as xTrain). Default is NULL}

\item{zTest}{Responses z used to estimate risk of final model  (matrix with one column; one observation per row). Default is NULL}
}
\value{
Returns an object of the class "combinedFlexCoDE" which contains the weights best linear combination of the input models, together with all fitted models

Returns an object of the class "combinedFlexCoDE" which contains the weights best linear combination of the input models, together with all fitted models
}
\description{
Finds best linear combination of several FlexCoDE estimates

Finds best linear combination of several FlexCoDE estimates
}
\examples{
set.seed(400)

# generate data
n=1000
d=10
data=matrix(NA,n,d+1)
data[,1:d]=matrix(rnorm(n*d),n,d)
data[,d+1]=data[,1]+rnorm(n,0,0.1)

# determine sample sizes
nTrain=round(0.7*n)
nValidation=round(0.25*n)
nTest=n-nTrain-nValidation

# split data
randomIndex=sample(1:n)
xTrain=data[randomIndex[1:nTrain],1:d]
xValidation=data[randomIndex[(nTrain+1):(nTrain+nValidation)],1:d]
xTest=data[randomIndex[(nTrain+nValidation+1):n],1:d]
zTrain=data[randomIndex[1:nTrain],d+1]
zValidation=data[randomIndex[(nTrain+1):(nTrain+nValidation)],d+1]
zTest=data[randomIndex[(nTrain+nValidation+1):n],d+1]

############################################################
###### fit 3 FlexCoDE
############################################################
fit1=fitFlexCoDE(xTrain,zTrain,xValidation,zValidation,xTest,zTest,
            nIMax = 20,regressionFunction = regressionFunction.NN)
fit2=fitFlexCoDE(xTrain,zTrain,xValidation,zValidation,xTest,zTest,
                nIMax = 50,regressionFunction = regressionFunction.SpAM)
fit3=fitFlexCoDE(xTrain,zTrain,xValidation,zValidation,xTest,zTest,
                nIMax = 30,regressionFunction = regressionFunction.Forest)


############################################################
######## Combine estimators
############################################################

# First, bind  them
fitBind=bindFlexCoDE(fit1,fit2,fit3)

# Then, combine them
combinedEstimator=combineFlexCoDE(fitBind,xValidation,zValidation,xTest,zTest)
combinedEstimator$weights # best weights
combinedEstimator$estimatedRisk

predictedValues=predict(combinedEstimator,xTest,zTest)
plot(predictedValues$z,predictedValues$CDE[1,])
lines(predictedValues$z,dnorm(predictedValues$z,xTest[1,1],0.1),col=2)

plot(combinedEstimator,xTest,zTest,nPlots = 6,predictionBandProb = 0.95)
print(combinedEstimator)
set.seed(400)

# generate data
n=1000
d=10
data=matrix(NA,n,d+1)
data[,1:d]=matrix(rnorm(n*d),n,d)
data[,d+1]=data[,1]+rnorm(n,0,0.1)

# determine sample sizes
nTrain=round(0.7*n)
nValidation=round(0.25*n)
nTest=n-nTrain-nValidation

# split data
randomIndex=sample(1:n)
xTrain=data[randomIndex[1:nTrain],1:d]
xValidation=data[randomIndex[(nTrain+1):(nTrain+nValidation)],1:d]
xTest=data[randomIndex[(nTrain+nValidation+1):n],1:d]
zTrain=data[randomIndex[1:nTrain],d+1]
zValidation=data[randomIndex[(nTrain+1):(nTrain+nValidation)],d+1]
zTest=data[randomIndex[(nTrain+nValidation+1):n],d+1]

############################################################
###### fit 3 FlexCoDE
############################################################
fit1=fitFlexCoDE(xTrain,zTrain,xValidation,zValidation,xTest,zTest,
            nIMax = 20,regressionFunction = regressionFunction.NN)
fit2=fitFlexCoDE(xTrain,zTrain,xValidation,zValidation,xTest,zTest,
                nIMax = 50,regressionFunction = regressionFunction.SpAM)
fit3=fitFlexCoDE(xTrain,zTrain,xValidation,zValidation,xTest,zTest,
                nIMax = 30,regressionFunction = regressionFunction.Forest)


############################################################
######## Combine estimators
############################################################

# First, bind  them
fitBind=bindFlexCoDE(fit1,fit2,fit3)

# Then, combine them
combinedEstimator=combineFlexCoDE(fitBind,xValidation,zValidation,xTest,zTest)
combinedEstimator$weights # best weights
combinedEstimator$estimatedRisk

predictedValues=predict(combinedEstimator,xTest,zTest)
plot(predictedValues$z,predictedValues$CDE[1,])
lines(predictedValues$z,dnorm(predictedValues$z,xTest[1,1],0.1),col=2)

plot(combinedEstimator,xTest,zTest,nPlots = 6,predictionBandProb = 0.95)
print(combinedEstimator)
}

