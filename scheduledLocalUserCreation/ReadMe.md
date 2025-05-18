Run the PowerShell script automatically every day at 06:43 AM using Windows Task Scheduler. Script reads data from csv to create users.

---

## Task Setup Details

- **Trigger:** Daily at 06:43 PM
- **Action:**
  - Program: `powershell.exe`
  - Arguments: `-ExecutionPolicy Bypass -File "C:\Users\Administrator\powershell_scripts\scheduledLocalUserCreation\LocalUserCreation.ps1"`
