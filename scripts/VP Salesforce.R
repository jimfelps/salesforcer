
# Libraries ----------------------------------------------
suppressWarnings(suppressMessages(library(dplyr)))
library(salesforcer)
library(tidyverse)
library(writexl)

# Log into Salesforce ------------------------------------
sf_auth()

# Test connection ----------------------------------------
user_info <- sf_user_info()
sprintf("Organization Id: %s", user_info$organizationId)
sprintf("User Id: %s", user_info$userId)


# Explore fields within objects --------------------------
opps <- sf_describe_object_fields('Opportunity')
comp <- sf_describe_object_fields('OpportunityHistory')

# Search for certain fields ------------------------------
opps %>%
  filter(str_detect(name, regex("account", ignore_case = TRUE))) %>% View()

# Query opportunieies ----------------------------------------
sql_text <- sprintf("SELECT Id,
                           OwnerId, 
                           Name, 
                           StageName,
                           Amount,
                           Probability,
                           ExpectedRevenue,
                           CloseDate,
                           CreatedDate,
                           Square_Footage__c,
                           Total_Tons__c,
                           Engineering_Hours__c,
                           Gross_Margin__c,
                           Factored_Margin__c,
                           Project_City__c,
                           Project_State_Province__c,
                           Project_Zip__c,
                           CSS_Opportunity__c,
                           End_Use_Picklist__c,
                           End_Use__c
                    FROM Opportunity 
                    WHERE CreatedDate >= "
                   )

new_opps <- paste0(sql_text, "2020-04-15","T00:00:00Z")
queried_opps <- sf_query(new_opps)

write_xlsx(opps, "~/R/Git/Project/salesforcer/test.xlsx")

# based on a review, I think we need more info from sales as to what an opportunity means
# there are a bunch of duplicate opportunities that I pull down. I think if I filter for 
# expected revenue > 0, duplicate opportunies will be removed. Looks like some of the PIM
# stage status opportunities are part of the problem.