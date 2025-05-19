## Description
This PowerShell script interactively prompts for user details (first name, last name, username, password), validates the input, and creates a local Windows user account if valid.

## Features
- Interactive input collection using Read-Host
- Password length validation (min 8 characters)
- Duplicate user check using Get-LocalUser
- Success & error logging with timestamps

## Usage
1. Run the script in PowerShell as Administrator
2. Enter the required user information when prompted
3. Check the log file generated for the result:
   - `InteractiveUserCreationLog_<date>.log`
