# download the package "devtools" to have access
# to R packages posted on github (only once)
install.packages('devtools')
#load the package onto R (every time)
library(devtools)
#load the desired package on my computer (only once) 
devtools::install_github("statsmaths/fasttextM")
#load the package onto R (every time)
library(fasttextM)
# download the trained daatasets (only once)
ft_download_model("en", mb = 500)
ft_download_model("fr", mb = 500)
# system.time(ft_download_model("en", mb = 500))
# user  system elapsed 
# 46.109   6.012 219.426

# load the downloaded models
ft_load_model("en")
ft_load_model("fr")

# We can now compute the embeddings of words in either language. Each of these embeddings is a length 300 vector:

en_embed

en_embed2 <- ft_nn(words = c("sight", "vision"),lang = "en", lang_out = "fr", n = 10)

en_embed2

en_embed3 <- ft_nn(words = c("can", "could"),
                             lang = "en", lang_out = "fr", n = 10)

en_embed3

en_embed.ex  <- ft_nn(words = c("can", "could"),
                      lang = "en", lang_out = "fr", n = 10)

en_embed.ex

en_embed4 <- ft_nn(words = "must",lang = "en", lang_out = "fr", n = 10)

# disambiguation ??
en_embed5 <- ft_nn(words = c("can", "could"),
                   lang = "en", lang_out = "en", n = 10)
en_embed5

# looking for syntactic realisations in French
fr_embed6 <- ft_nn(words = c("mais"),
                   lang = "fr", lang_out = "fr", n = 10)

fr_embed7 <- ft_nn(words = c("or"),
                             lang = "fr", lang_out = "fr", n = 10)

fr_embed8 <- ft_nn(words = c("et"),
                   lang = "fr", lang_out = "fr", n = 10)
fr_embed8

fr_embed9 <- ft_nn(words = c("car"),
                   lang = "fr", lang_out = "fr", n = 10)

fr_embed9

fr_embed_ni <- ft_nn(words = c("ni"),
                     lang = "fr", lang_out = "fr", n = 10)

fr_embed_ni