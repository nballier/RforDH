# adapted from  https://raw.githubusercontent.com/bkrai/DeepLearningR/master/ImageRecognitionAndClassificationWithR
# data available from https://goo.gl/To15db
# with a former version of tensorflow/keras
# code adapted for the latest version of tensorflow (March 2022)
# https://www.youtube.com/watch?v=iExh0qj2Ouo



# Load Packages
library(EBImage)
library(keras)

# To install EBimage package, you can run following 2 lines;
# install.packages("BiocManager") 
# BiocManager::install("EBImage")

# Read images
setwd('/Users/nballier/Desktop/pix2')
mypath <-  getwd()
pics <- list.files(path = mypath)
mypic <- as.list(list.files(path = mypath))
str(mypic)

#pics <- c('p1.jpg', 'p2.jpg', 'p3.jpg', 'p4.jpg', 'p5.jpg', 'p6.jpg',
#          'c1.jpg', 'c2.jpg', 'c3.jpg', 'c4.jpg', 'c5.jpg', 'c6.jpg')
mypic <- list()
for (i in 1:12) {mypic[[i]] <- readImage(pics[i])}

# Explore the pîctures
print(mypic[[1]])
display(mypic[[8]])
summary(mypic[[1]])
hist(mypic[[2]])
str(mypic)

# Resize   
for (i in 1:12) {
  mypic[[i]] <- resize(mypic[[i]], 28, 28)
}

# Reshape (single vector)
for (i in 1:12) {mypic[[i]] <- array_reshape(mypic[[i]], c(28, 28,3))}
str(mypic)

# Row Bind 
trainx <- NULL
for (i in 1:5) {trainx <- rbind(trainx, mypic[[i]])}
str(trainx)
for (i in 7:11) {trainx <- rbind(trainx, mypic[[i]])}
str(trainx)
testx <- rbind(mypic[[6]], mypic[[12]])
# 0 for first type of pictures
trainy <- c(0,0,0,0,0,1,1,1,1,1 )
testy <- c(0, 1) # assigns the label of the test picture

## generalise with a dataset df of n pictures
# nrow(df)/2
# half <- nrow(df)/2
# maxtrain <- nrow(df) - 1 
# for (i in 1:half)
# testx <- rbind(mypic[[half]], mypic[[nrow(df)]])
# trainy <- c(rep(0,(half-1)),rep(1,(half-1))

# One Hot Encoding
trainLabels <- to_categorical(trainy)
# Loaded Tensorflow version 2.6.2
testLabels <- to_categorical(testy)

# number of layers
# activation function
# Model number of neurons in the hidden layers
model <- keras_model_sequential()
model %>%
         layer_dense(units = 256, activation = 'relu', input_shape = c(2352)) %>%
         layer_dense(units = 128, activation = 'relu') %>%
         layer_dense(units = 2, activation = 'softmax')
summary(model)
# NB: the youtube video explains how you compute the parameters
# https://www.youtube.com/watch?v=iExh0qj2Ouo

# Compile
model %>%
         compile(loss = 'binary_crossentropy',
                 optimizer = optimizer_rmsprop(),
                 metrics = c('accuracy'))

# Fit Model
history <- model %>%
         fit(trainx,
             trainLabels,
             epochs = 30,
             batch_size = 32,
             validation_split = 0.2)

plot(history)

# Evaluation & Prediction - train data
model %>% evaluate(trainx, trainLabels)
# pred <- model %>% predict_classes(trainx) deprecated

prob <- model %>% predict(trainx)
cbind(prob, Predicted = pred, Actual= trainy)

## keras official doc
## In predict_classes(., trainx) :
## `predict_classes()` is deprecated and and was removed from tensorflow in version 2.6.
## Please update your code:
## If your model does multi-class classification:
##  (e.g. if it uses a `softmax` last-layer activation).
## pred <-  model %>% predict(trainx) %>% k_argmax()

# if your model does binary classification
#(e.g. if it uses a `sigmoid` last-layer activation).

# the recommended syntax provides objects with a complex structure
#pred <- model %>% predict(trainx) %>% `>`(0.5) %>% k_cast("int32")
#str(pred)

prob <- model %>% predict(trainx)
DF <- as.data.frame(prob)
colnames(DF)<- c(0,1)
pred <- as.numeric(colnames(DF)[max.col(DF,ties.method="first")])
# var: pred <- as.numeric(colnames(DF)[apply(DF,1,which.max)])
table(Predicted = pred, Actual = trainy)


# probability of belonging to a certain class
cbind(prob, Predicted = pred, Actual= trainy)

model %>% evaluate(testx,testLabels)

# for the test cases
# pred.y <- model %>% predict_classes(testx) deprecated 
prob.test <- model %>% predict(testx)
# selects the highest probability and returns the corresponding label
DF2 <- as.data.frame(prob.test)
colnames(DF)<- c(0,1)
pred.test <- as.numeric(colnames(DF2)[max.col(DF2,ties.method="first")])
# confusion matrix
table(Predicted = pred.test, Actual = testy)

# inspects probability and predicted class
cbind(prob.test, Predicted = pred.test, Actual= testy)


