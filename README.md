# blob-service
Testing out Github actions and Bicep functionality.Creating a blob service and uploading a file to the blob service. Authenticating with a SAStoken

## prerequisites: 
1. Create a service principal in Azure for Github actions
   Store the service prinipal json output as a secret in your Github repository
    https://docs.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#use-the-azure-login-action-with-a-service-principal-secret
2. change the Expire date for sastoken in Bicep file. param accountSasProperties object > signedExpiry: '2021-11-29T00:00:01Z'

## What is deployed here:
1. Storage account blob container
2. Keyvault
3. Sas token that is stored in the key vault
4. retreives the sas token with the service principal created in prerequisites.(ideally this should be a seperate identity that is assigned the propper permission to retreive the sastoken)
5. Uploads a file to the blob container with the sas token from the key vault

## Notes from the field
The service principal objectID is hardcoded as a parameter in the bicep file. Tried to automatically get the service principal object ID, but did not manage to get it right. Investigated how to use powershell/Azure cli inside Bicep to accomplish this and tried to use a Github azure cli action to do the lookup and pass the value as a parameter into the bicep file....no luck yet.
