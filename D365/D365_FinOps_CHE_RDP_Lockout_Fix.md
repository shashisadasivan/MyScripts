# Standard Operating Procedure: Unlocking D365 FinOps CHE Admin Accounts

**Issue:** Standard RDP WarningMsg - Account locked due to excessive log-on or password change attempts. Access is denied when trying to clear via standard local account tools.

---

## Overview
In a Dynamics 365 Finance & Operations Cloud-Hosted Environment (CHE), the `builtin\User` credentials provided via Lifecycle Services (LCS) have hidden elevated infrastructure rights. They can call an administrative command window by passing the `builtin\Admin` password stored in the LCS portal, effectively bypassing standard local OS locking mechanisms.

## Recovery Procedure

1. **Log In via Alternative Account:** Connect to the VM via RDP using the `builtin\User` account credentials provided on your LCS Environment Details page.
2. **Launch Command Prompt:** Open the Windows Start menu, type **cmd**, right-click *Command Prompt*, and select **Run as administrator**.
3. **Authenticate with LCS Credentials:** When prompted by Windows User Account Control (UAC) for administrator credentials, paste the password explicitly assigned to the **builtin\Admin** account from your LCS environment portal.
4. **Disable the Lockout Threshold globally by executing:**
   ```cmd
   net accounts /lockoutthreshold:0
   ```
5. **Force Immediate Policy Evaluation by running:**
   ```cmd
   gpupdate /force
   ```
6. **Verify Access:** Disconnect your active RDP session and reconnect using the primary `builtin\Admin` account profile.

---

## Permanent Resolution & Cleanup
Once successfully back inside the `builtin\Admin` account profile:
* Open the Local Computer Management console (`compmgmt.msc`).
* Navigate to **Local Users and Groups > Users**.
* Right-click the `builtin\Admin` profile and open **Properties**.
* Uncheck the **Account is locked out** box to completely clear its flagged state, then click **Apply**.
