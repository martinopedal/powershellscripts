# SPN Login 

$applicationId = "yourApplicationId" 
$tenantId = "yourTenantId"              
$clientSecret = "yourClientSecret"  

# Secure the client secret
$secureClientSecret = ConvertTo-SecureString $clientSecret -AsPlainText -Force

# Create a credential object
$credential = New-Object System.Management.Automation.PSCredential($applicationId, $secureClientSecret)

# Connect to Azure with the Service Principal
Connect-AzAccount -ServicePrincipal -Credential $credential -Tenant $tenantId

# Get Azure AD applications based on criteria
# Example: Get all applications, or filter using -DisplayName or other properties
$adApplications = Get-AzADApplication

foreach ($app in $adApplications) {
    # Create a new secret for the application
    $newSecret = New-AzADAppCredential -ObjectId $app.Id

    # Display the new secret info for the application
    Write-Host "Application ID: $($app.ApplicationId)"
    Write-Host "New Secret KeyId: $($newSecret.KeyId)"
    Write-Host "New Secret Start Date: $($newSecret.StartDate)"
    Write-Host "New Secret End Date: $($newSecret.EndDate)"
    Write-Host "New Secret Value: $($newSecret.SecretText) - Save this value, it's not retrievable again!"
    Write-Host "--------------------------------------"

    # List current secrets for the application
    $currentSecrets = Get-AzADAppCredential -ObjectId $app.Id
    Write-Host "Current Secrets for $($app.DisplayName):"
    foreach ($secret in $currentSecrets) {
        Write-Host "KeyId: $($secret.KeyId) - Start Date: $($secret.StartDate) - End Date: $($secret.EndDate)"
    }
    Write-Host "--------------------------------------"

    # Optional: Remove an old secret by KeyId for the application
    # $oldKeyId = "yourOldKeyIdHere"
    # Remove-AzADAppCredential -ObjectId $app.Id -KeyId $oldKeyId
}
