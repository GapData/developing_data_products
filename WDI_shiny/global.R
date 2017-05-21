library(WDI)
library(dplyr)

# Indices for the indicators

all_Indices <- c(25,26,39,40,41,46,50,2259,2260,2265,2266,4372,4378,5404,5405,
                 5406,5878,5879,5880,2293,2297,2298,2299,2300,2301,2302,5893,
                 5894,5895,610,611,616,623,661,662,667,668,669,670,671,675,676,
                 677,1235,1346,1347,1504,1505,1673,1675,1840,2048,2050,2053,
                 2330,2336,2380,2450,2452,2465,2493,4248,4252,4253,4256,4260,
                 4305,4308,4311,4318,4375,4379,4382,4385,4387,4390,4392,4398,
                 4401,4404,4449,4455,4457,4470,4474,4478,4481,4487,4490,4492,
                 4495,4505,4515,599,628,694,695,696,697,698,699,700,2321,2322,
                 2323,2324,2325,2326,2327,2328,2333,2334,2350,2357,2379,2381,
                 2382,2386,2387,2389,2390,4949,4951,4952,4953,4954,4955,4956,
                 4982,4983,4984,4994,4995,4996,5003,5004,5005,5022,5024,5051,
                 5052,5056,5060,5061,5062,5126,5129,5133,5136,5521,5522,5523,
                 5574,5689,5149,5150,5151,5154,5157,5160,5161,5162,5163,5165,
                 5166,5167,5168,5171,5176,5178,5204,5205,5207,5208,5210,5212,
                 5218,5221,5222,5224,5225,5227,5228,5229,5231,5232,5233,5235,
                 5237,5238,5239,5240,5241,5242,5243,5245,5246,5247,5259,5260,
                 5261,5270,5272,5273,5274,5275,5277,5281,5282,5283,5284,5287,
                 5532,5534,5535,5540,5541,5542,5545,5546,5547,5548,5551,5552,
                 5553,5554,5555,5556,5557,5560,5561,5562,5563,5564,5565,5566,
                 5716,5855,5856,5857,5858,5861,5863,5896,3287,3288,3289,3303,
                 3304,3305,3311,3312,3341,3342,3353,3354,3358,3359,3363)


# Extract the names, codes, and descriptions of all the selected indicators
all_indicators <- WDI_data[[1]] %>%
    as_data_frame() %>%
    slice(all_Indices) %>%
    select(1:3)

# Divide the indicators based on their categories
ard <-   setNames(all_indicators$indicator[1:19], 
                  all_indicators$name[1:19])

ud <-    setNames(all_indicators$indicator[20:29], 
                  all_indicators$name[20:29])

eg <-    setNames(all_indicators$indicator[30:93], 
                  all_indicators$name[30:93])

fs <-    setNames(all_indicators$indicator[94:121], 
                  all_indicators$name[94:121])

edu <-   setNames(all_indicators$indicator[122:154], 
                  all_indicators$name[122:154])

hlth <-  setNames(all_indicators$indicator[155:244], 
                  all_indicators$name[155:244])

infra <- setNames(all_indicators$indicator[245:259], 
                  all_indicators$name[245:259])


# Header color for the DT table
headerColor <- htmlwidgets::JS(
    "function(settings, json) {",
    "$(this.api().table().header()).css({'background-color': 'thistle', 
  'color': 'sienna4', 'font-size': '18px'});",
    "}")

# Extract the list of all countries along with their iso2c codes
all_countries <- WDI(country = "all", indicator = "NY.GDP.PCAP.CD",
                     start = 2015, end = 2015) %>%
    select(iso2c, country) %>% slice(-(1:47))

countries <- setNames(all_countries$iso2c, all_countries$country)


# Font style for the plotly legend
font <- list(family = "Old Standard TT, serif", 
             face = "bold", size = 20, color = "black")

