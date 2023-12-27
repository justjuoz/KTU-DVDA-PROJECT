library(h2o)
library(tidyverse)
h2o.init(max_mem_size = "8g")



df <- h2o.importFile("C:/Users/pauli/OneDrive/Documents/GitHub/KTU-DVDA-PROJECT/project/1-data/train_data.csv")
test_data <- h2o.importFile("C:/Users/pauli/OneDrive/Documents/GitHub/KTU-DVDA-PROJECT/project/1-data/test_data.csv")
df
class(df)
summary(df)

y <- "y"
x <- setdiff(names(df), c(y, "id"))
df$y <- as.factor(df$y)
summary(df)

splits <- h2o.splitFrame(df, c(0.6,0.2), seed=123)
train  <- h2o.assign(splits[[1]], "train") # 60%
valid  <- h2o.assign(splits[[2]], "valid") # 20%
test   <- h2o.assign(splits[[3]], "test")  # 20%

# GBM

gbm_model <- h2o.gbm(x,
                     y,
                     training_frame = train,
                     validation_frame = valid,
                     ntrees = 80,
                     max_depth = 15,
                     stopping_metric = "AUC",
                     seed = 1234)

### ID, Y
h2o.saveModel(gbm_model, "../4-model/", filename = "my_best_gbmmodel")
model <- h2o.loadModel("../4-model/my_best_gbmmodel")
h2o.varimp_plot(model)

h2o.auc(gbm_model)
h2o.auc(h2o.performance(gbm_model, valid = TRUE))
h2o.auc(h2o.performance(gbm_model, newdata = test))

h2o.performance(model, train = TRUE)
h2o.performance(model, valid = TRUE)
perf <- h2o.performance(model, newdata = test)

h2o.auc(perf)
plot(perf, type = "roc")

predictions <- h2o.predict(model, test_data)

predictions

predictions %>%
  as_tibble() %>%
  mutate(id = row_number(), y = p0) %>%
  select(id, y) %>%
  write_csv("C:/Users/pauli/OneDrive/Documents/GitHub/KTU-DVDA-PROJECT/project/5-predictions/predictionsgbm1.csv")



