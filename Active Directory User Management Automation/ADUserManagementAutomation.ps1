# Import the Active Directory module
Import-Module ActiveDirectory

# Define the path to the CSV file and the log file
$csvPath = "C:\Scripts\random_users_20240903_013724.csv"
$logPath = "C:\Scripts\ADUserCreationLog.txt"
$emailRecipient = "admin.greerlab@gmail.com"  # Placeholder email

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

# Function to check and create organizational units
function Ensure-OUExists {
    param (
        [string]$ou
    )
    $ouPath = "OU=$ou,DC=Greerlab,DC=local"
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'" -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $ou -Path "DC=Greerlab,DC=local" | Out-Null
        Log-Message "Created new Organizational Unit: $ou"
    }
    return $ouPath
}

# Loop through each user in the CSV file
foreach ($user in $users) {
    try {
        # Ensure the Organizational Unit exists
        $ouPath = Ensure-OUExists $user.OrganizationalUnit

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
            -UserPrincipalName "$($user.Username)@Greerlab.local" `
            -Path $ouPath `
            -Department $user.Department `
            -Title $user.Title `
            -Office $user.Office `
            -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
            -Enabled $true `
            -ChangePasswordAtLogon $true `
            -PasswordNeverExpires $false `
            -PassThru | Out-Null

        # Add the user to the specified groups
        foreach ($group in $user.Groups -split ";") {
            if (Get-ADGroup -Filter "Name -eq '$group'" -ErrorAction SilentlyContinue) {
                Add-ADGroupMember -Identity $group -Members $user.Username
                Log-Message "Added $($user.Username) to group: $group"
            } else {
                Log-Message "Group $group does not exist. Skipping group assignment for $($user.Username)."
            }
        }

        Log-Message "Created user: $($user.FirstName) $($user.LastName) in OU: $($user.OrganizationalUnit)"
    } catch {
        Log-Message "Error creating user $($user.Username): $_"
    }
}

# Log summary
Log-Message "User creation process completed successfully."

# Send an email notification with the log attached
Send-MailMessage -From "no-reply@Greerlab.local" -To $emailRecipient -Subject "AD User Creation Report" -Body "The AD user creation script has completed. Please find the attached log for details." -Attachments $logPath -SmtpServer "smtp.gmail.com" -Port 587 -UseSsl -Credential (Get-Credential)

# Output the log summary
Get-Content -Path $logPath
