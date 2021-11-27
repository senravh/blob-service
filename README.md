# blob-service
Testing out Github actions and Bicep functionality. Creating a blob service and uploading a file to the blob service. Authenticating with a SAS token

## prerequisites: 
1. Create a service principal in Azure for GitHub actions and store the service principal json output as a secret in your GitHub repository.  
   https://docs.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#use-the-azure-login-action-with-a-service-principal-secret
2. Update variable spobjectid in main.bicep
3. change the Expire date for SAS token in Bicep file. param accountSasProperties object > signedExpiry: '2021-11-29T00:00:01Z'

## What is deployed here:
1. Storage account blob container
2. Key vault
3. SAS token that is stored in the key vault
4. retrieves the SAS token with the service principal created in prerequisites. (ideally this should be a separate identity that is assigned the proper permission to retrieve the SAS token)
5. Uploads a file to the blob container with the SAS token from the key vault

## Notes from the field
The service principal objectID is hardcoded as a variable in the bicep file. Tried to automatically get the service principal object ID, but did not find a way to do it....yet. Investigated how to use PowerShell/Azure cli inside Bicep to accomplish this and tried to use a GitHub azure cli action to do the lookup and pass the value as a parameter into the bicep file.