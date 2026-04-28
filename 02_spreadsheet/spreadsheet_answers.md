# Spreadsheet Answers 
 
## Cleaning Steps 
- Standardized merchant names using TRIM and PROPER functions 
- Removed double spaces using SUBSTITUTE function 
- Cleaned status values using nested IF with SEARCH function 
- Extracted numeric risk scores from score:XX and risk-XX formats 
- Filled missing risk scores with column median of 61 
- Filled missing gateway regions using merchant name lookup 
- Converted all amounts to USD using exchange rates
