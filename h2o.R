install.packages("C:/Users/pauli/OneDrive/Desktop/h2o-3.44.0.2/R/h2o_3.44.0.2.tar.gz",
                 repos = NULL, type = "source")
library(h2o)
demo(h2o.glm)


install.packages("h2o")
library(h2o)
localH2O = h2o.init()

H2O is not running yet, starting it now...
Performing one-time download of h2o.jar from
http://s3.amazonaws.com/h2o-release/h2o/rel-knuth/11/Rjar/h2o.jar
(This could take a few minutes, please be patient...)
