# Import the Active Directory module
Import-Module ActiveDirectory

# Define the path to the CSV file and the log file
$csvPath = "C:\Scripts\ExtendedADUsers.csv"
$logPath = "C:\Scripts\ADUserCreationLog.txt"
$emailRecipient = "admin.corpdept@gmail.com"

# Clear the log file if it exists
if (Test-Path $logPath) { 
    Clear-Content $logPath 
}

# Import the user data from the CSV
$users = Import-Csv -Path $csvPath

# Function to log messages
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "$timestamp - $message"
    Add-Content -Path $logPath -Value $entry
    Write-Host $entry
}

# Loop through each user in the CSV file
foreach ($user in $users) {
    try {
        # Define the Distinguished Name (DN) for the user
        $userDN = "OU=$($user.OrganizationalUnit),DC=corp,DC=local"

        # Check if the user already exists in AD
        if (Get-ADUser -Filter {SamAccountName -eq $user.Username}) {
            Log-Message "User $($user.Username) already exists. Skipping..."
            continue
        }

        # Create the new user
        New-ADUser `
            -Name "$($user.FirstName) $($user.LastName)" `
            -GivenName $user.FirstName `
            -Surname $user.LastName `
            -SamAccountName $user.Username `
            -UserPrincipalName "$($user.Username)@corp.local" `
            -Department $user.Department `
            -Title $user.Title `
            -Office $user.Office `
            -Path $userDN `
            -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
            -Enabled $true `
            -ChangePasswordAtLogon $true `
            -PasswordNeverExpires $false `
            -PassThru | Out-Null

        # Add the user to the specified groups
        foreach ($group in $user.Groups -split ";") {
            Add-ADGroupMember -Identity $group -Members $user.Username
        }

        Log-Message "Created user: $($user.FirstName) $($user.LastName) and added to groups: $($user.Groups)"
    } catch {
        Log-Message "Error creating user $($user.Username): $_"
    }
}

# Log summary
Log-Message "User creation process completed successfully."

# Send an email notification with the log attached
Send-MailMessage -From "no-reply@corp.local" -To $emailRecipient -Subject "AD User Creation Report" -Body "The AD user creation script has completed. Please find the attached log for details." -Attachments $logPath -SmtpServer "smtp.gmail.com" -Port 587 -UseSsl -Credential (Get-Credential)

# Output the log summary
Get-Content -Path $logPath