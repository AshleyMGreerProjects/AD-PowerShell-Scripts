**`Active Directory User Automation with PowerShell`**


#### Project Overview

**Objective**: This project aims to automate the creation and management of users in Active Directory (AD) using a PowerShell script. The script processes user data from a CSV file, creates users, assigns them to specified groups, and sets additional attributes such as department, title, and office location.

---

### 1. Environment Preparation

**Active Directory Setup**:
- **Organizational Units (OUs)**: The following OUs were created in Active Directory:
  - `TestOU`
  - `SalesOU`
  - `HR_OU`
- **Groups**: Groups were created within each OU to manage permissions and roles:
  - **TestOU**: `TestGroup1`, `TestGroup2`, `TestGroup3`
  - **SalesOU**: `SalesGroup1`, `SalesGroup2`, `SalesGroup3`
  - **HR_OU**: `HRGroup1`, `HRGroup2`, `HRGroup3`

**CSV File Preparation**:
- A CSV file named `ExtendedADUsers.csv` was created to store user data. The CSV file was saved in the `C:\Scripts\` directory.

---

### 2. PowerShell Script Execution

**Script Location**:
- The PowerShell script, `CreateADUsers.ps1`, was saved in the `C:\Scripts\` directory.

**Script Execution**:
- The script was executed from PowerShell with administrative privileges using the following command:

```powershell
.\CreateADUsers.ps1
```

**Logging**:
- The script generated a log file named `ADUserCreationLog.txt` in the `C:\Scripts\` directory. This log file records the execution process, including any users that were skipped or errors that occurred.

---

### 3. Script Functions and Operations

The PowerShell script performs the following operations:

- **User Creation**: Reads user information from the CSV file and creates accounts in the specified OUs.
- **Group Assignment**: Adds users to the groups specified in the CSV file.
- **Attribute Assignment**: Sets additional user attributes, including `Department`, `Title`, and `Office`.
- **Error Handling**: Skips users who already exist and logs any errors encountered during the process.
- **Email Notification**: Sends an email to `admin.corpdept@gmail.com` with a summary of the execution and the log file attached.

---

### 4. Results of Execution

**Active Directory Verification**:
- **User Accounts**: All users listed in the CSV file were successfully created in their respective OUs within Active Directory.
- **Group Memberships**: Users were correctly assigned to the groups specified in the CSV file.
- **Attributes**: The script successfully set the `Department`, `Title`, and `Office` attributes for each user.

**Log File Summary**:
- The log file provided detailed information about each step of the process, including any skipped users and errors encountered.

**Email Notification**:
- An email was sent to `admin.corpdept@gmail.com`, summarizing the execution process and attaching the log file for review.