# blob-service
Testing out Github actions and Bicep functionality. Creating a blob service and uploading a file to the blob service. Authenticating with a SAS token

## prerequisites: 
1. Create a service principal in Azure for GitHub actions and store the service principal json output as a secret in your GitHub repository  (AZURE_CREDENTIALS)  
   https://docs.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#use-the-azure-login-action-with-a-service-principal-secret
   The service principal is used to deploy the solution and needs correct permission in Azure to deploy.
2. manually lookup the objectId of the service princial and store the objectId as a secret in your Github repository (SP_OBJECTID)
3. change the Expire date for SAS token in Bicep file. param accountSasProperties object > signedExpiry: '2021-11-29T00:00:01Z'

## What is deployed here:
1. Storage account blob container
2. Key vault
3. SAS token that is stored in the key vault
4. retrieves the SAS token with the service principal created in prerequisites.
5. Uploads a file to the blob container with the SAS token from the key vault

