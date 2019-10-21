## Example data for motion charts
# Lightweight emulation of gapminder presentations by Prof Hans Rosling.

## Packages ----
library( tidyverse )
library( googleVis )

## Data load ----
rawCountryData <- readr::read_csv( 'country.csv' ) 

countryData <- rawCountryData %>%
  # Remove regions
  filter( !is.na( CurrencyUnit ) ) %>%
  # Downselect variables 
  select( CountryCode, ShortName, Region )

# Note this is big...
rawIndicatorData <- readr::read_csv( 'Indicators.csv' ) 

indicatorData <- rawIndicatorData%>%
  # Trim down code
  select( -IndicatorCode ) %>%
  # Select only a few indicators
  filter( IndicatorName %in% c('Fertility rate, total (births per woman)'
                               , 'Life expectancy at birth, total (years)'
                               , 'Mortality rate, infant (per 1,000 live births)'
                               , 'Population, total'
                               , 'GDP, PPP (current international $)'
                               , 'GDP per capita, PPP (current international $)' 
                               )
  ) %>%
  # Limit the years, too
  filter( Year >= 1975 )

indicatorData1 <- indicatorData %>% 
  inner_join( countryData, by='CountryCode' ) %>%
  spread( IndicatorName, Value, drop = TRUE ) %>%
  as.data.frame()


# Here's the command to make the motion chart
motionChart <- gvisMotionChart( data=indicatorData1
                                , idvar='CountryName'
                                , timevar = 'Year'
                                , xvar='Fertility rate, total (births per woman)'
                                , yvar='Mortality rate, infant (per 1,000 live births)'
                                , colorvar='Region'
                                , sizevar='Population, total' 
                                , options=list( width=700 ) )

save( indicatorData1, file='motionChartData.RData' )

# Save some memory
rm( rawIndicatorData, indicatorData, rawCountryData, countryData, motionChart )
