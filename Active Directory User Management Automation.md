# Active Directory User Management Automation Project

## Project Overview

This project automates the process of creating and managing user accounts in Active Directory (AD) based on information stored in a CSV file. The PowerShell script is designed to handle user creation, organizational unit (OU) management, group assignments, and additional attribute configurations such as department, title, and office location. This project demonstrates the practical application of PowerShell in managing Active Directory environments efficiently within a home lab setting.

## Environment Setup

### Home Lab Configuration

This project was set up and executed in a home lab environment, simulating a small-scale Active Directory deployment with the domain name "Greerlab". Here are the details of the setup:

- **Operating System**: Windows Server 2019 running on a virtual machine (VM) or dedicated server.
- **Active Directory Domain**: The server was configured with an AD domain named `Greerlab.local`.
- **Network Configuration**: The server was part of a home network, with DNS configured locally to resolve internal domain names like `Greerlab.local`.
- **PowerShell Version**: PowerShell 5.1, included with Windows Server 2019, was used to run the script.
- **Modules Used**: Active Directory PowerShell Module, installed and configured on the Windows Server.
- **CSV File Path**: The CSV file containing user data was stored in the `C:\Scripts\` directory on the server.
- **Virtualization**: The server and any connected workstations were virtualized using software like VMware Workstation, VirtualBox, or Hyper-V, providing a flexible and scalable environment for testing and development.

### Security Considerations

- **Administrator Account**: The script was executed using a domain administrator account, ensuring the necessary permissions to create and manage users and groups in Active Directory.
- **Password Handling**: User passwords were securely processed using PowerShell’s `ConvertTo-SecureString` cmdlet to avoid exposing them in plain text.

### Placeholders for Security

In the PowerShell script, certain sensitive information, such as email addresses and SMTP server details, were intentionally replaced with placeholders. This approach was adopted to ensure the security and privacy of the actual credentials and configuration details, especially when sharing the script publicly or in a collaborative environment.

- **Placeholders Used**:
  - **Email Address**: The recipient's email address for notifications was replaced with `"admin.greerlab@gmail.com"` as a placeholder.
  - **SMTP Server Information**: The SMTP server and related credentials were also placeholder values, such as `"smtp.gmail.com"` and `"no-reply@Greerlab.local"`.
  - **Credentials**: When sending an email, the script uses `Get-Credential` to prompt for the SMTP server credentials securely, rather than hardcoding sensitive information directly in the script.

This practice ensures that when the script is shared or uploaded to platforms like GitHub, it does not expose real, sensitive information. Users who wish to run the script in their environments are expected to replace these placeholders with their actual configuration details.

## PowerShell Script: `ADUserManagementAutomation.ps1`

The PowerShell script named `ADUserManagementAutomation.ps1` automates the following tasks in the home lab Active Directory environment:

1. **Ensuring Organizational Units Exist**: The script verifies the existence of the specified Organizational Units (OUs) and creates them if they do not exist.
2. **User Creation**: The script creates new users in the specified OUs, setting attributes such as name, username, department, title, and office location.
3. **Group Membership Assignment**: The script adds users to the specified Active Directory groups and checks the existence of these groups before adding users.
4. **Logging**: The script logs each action taken, providing a detailed record of the process.
5. **Email Notification**: Upon completion, the script sends an email summary, including the log file, to a designated email account.

# Log summary
Log-Message "User creation process completed successfully."

# Send an email notification with the log attached
Send-MailMessage -From "no-reply@Greerlab.local" -To $emailRecipient -Subject "AD User Creation Report" -Body "The AD user creation script has completed. Please find the attached log for details." -Attachments $logPath -SmtpServer "smtp.gmail.com" -Port 587 -UseSsl -Credential (Get-Credential)

# Output the log summary
Get-Content -Path $logPath
```

### CSV File: `random_users_20240903_013724.csv`

The CSV file contains user data in the following format:

| FirstName | LastName | Username | Password    | OrganizationalUnit | Groups                  | Department | Title             | Office    |
|-----------|----------|----------|-------------|--------------------|-------------------------|------------|-------------------|-----------|
| John      | Doe      | jdoe      | P@ssword123 | IT_OU               | ITGroup1;ITGroup2       | IT         | Developer         | New York  |
| Jane      | Smith    | jsmith    | P@ssword123 | HR_OU               | HRGroup1                | HR         | HR Manager        | Chicago   |
| Bob       | Johnson  | bjohnson  | P@ssword123 | SalesOU             | SalesGroup1;SalesGroup2 | Sales      | Sales Executive   | Los Angeles |
| Alice     | Williams | awilliams | P@ssword123 | FinanceOU           | FinanceGroup1           | Finance    | Accountant        | Miami     |

### Project Execution and Testing

#### 1. **Preparation**

- **Active Directory Setup**:
  - Verified that the Organizational Units (OUs) listed in the CSV file (`IT_OU`, `HR_OU`, `SalesOU`, `FinanceOU`, etc.) existed or were created by the script.
  - Ensured that the groups listed under each OU were created in AD.

- **CSV File Location**:
  - The CSV file `random_users_20240903_013724.csv` was placed in the `C:\Scripts\` directory on the server.



#### 2. **Execution**

- **Running the Script**:
  - The script was executed from PowerShell with administrative privileges using the following command:
    ```powershell
    .\ADUserManagementAutomation.ps1
    ```
  - The script automatically handled the creation of Organizational Units (OUs) and user accounts, as well as the assignment of users to specific groups based on the information provided in the CSV file.

- **Logging**:
  - A log file named `ADUserCreationLog.txt` was generated in the `C:\Scripts\` directory. This log recorded all actions, including the creation of OUs, user accounts, and group assignments. The log also noted any errors encountered during execution, such as missing groups or users that already existed in the system.

#### 3. **Results and Verification**

- **Organizational Units**:
  - The script successfully created the necessary OUs (`IT_OU`, `HR_OU`, `SalesOU`, `FinanceOU`) as specified in the CSV file. The OUs were verified to be correctly structured within the Active Directory tree under the domain `Greerlab.local`.

- **User Accounts**:
  - Verified that all users listed in the CSV file were successfully created in the specified OUs within Active Directory. User attributes such as `FirstName`, `LastName`, `Username`, `Department`, `Title`, and `Office` were confirmed to match the CSV file data.

- **Group Membership**:
  - Checked that each user was correctly added to the specified groups. For example, users in the `SalesOU` were successfully added to `SalesGroup1` and `SalesGroup2`. If a group did not exist, the script logged this and continued with other assignments.

- **Attributes**:
  - Confirmed that additional user attributes such as `Department`, `Title`, and `Office` were correctly assigned as per the CSV file. This ensured that the user information in Active Directory was consistent with the organizational structure and roles defined in the home lab environment.

#### 4. **Email Notification**

- **Summary Report**:
  - An email was sent to `admin.greerlab@gmail.com` upon completion of the script. The email contained a summary of the actions taken and the log file as an attachment. This provided a clear overview of the user creation process and any issues encountered, making it easy to review the script's performance.

#### 5. **Final Remarks**

- **Success Rate**: The script successfully automated the entire user creation process in the "Greerlab" Active Directory domain with no manual intervention required. All users were created with the specified attributes, and group memberships were assigned as per the CSV data.
- **Error Handling**: The script effectively handled potential errors, such as missing groups or OUs, and logged all relevant information for review. This ensured that the process could be easily audited and any issues quickly addressed.

- **Security Considerations**:
  - Placeholders were used for sensitive information such as email addresses and SMTP server details to maintain security and privacy when sharing the script publicly or in collaborative environments. Users who wish to run the script in their environments should replace these placeholders with their actual configuration details.