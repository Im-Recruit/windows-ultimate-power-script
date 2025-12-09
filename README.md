# ⚡ Windows Ultimate Performance Setup and Cleanup Script

A powerful, administrator-level batch script designed to streamline your power settings, ensuring you are running the fastest available configuration on Windows 10 and 11: **Ultimate Performance**.

## ✨ Features

* **Unlocks Ultimate Performance:** Automatically reveals and activates the hidden Ultimate Performance power plan (usually exclusive to Windows Workstation or Server editions).
* **Sets Active Plan:** Ensures Ultimate Performance is the actively selected scheme.
* **Cleanup:** Deletes all redundant, user-created power plans, leaving only the essential Windows defaults (Balanced, Power Saver) and the Ultimate Performance plan for a clutter-free system.
* **Admin Check:** Includes a failsafe to ensure the script runs with the required elevated permissions.

## ⚠️ Prerequisites

This script is designed for Windows 10 (Version 1709 and newer) and Windows 11.

**Crucially, this script MUST be run with Administrator privileges.**

## 🚀 How to Use

1.  **Download:** Clone the repository or download the `Ultimate_Performance_Setup.bat` file directly.
2.  **Right-Click:** Locate the downloaded batch file.
3.  **Run as Administrator:** Right-click the file and select **"Run as administrator."**

The script will automatically perform the following:

1.  Check for administrator rights and exit if not found.
2.  Duplicate/Activate the Ultimate Performance scheme.
3.  Set the Ultimate Performance scheme as the active plan.
4.  Loop through and delete all non-essential custom power plans.
5.  Display the final clean list of power schemes.

## 🔍 How to Verify

After the script runs, you can check your Power & Sleep settings:

1.  Press `Windows Key` + `R` and type `powercfg.cpl`.
2.  In the Power Options window, only the following plans should remain visible:
    * **Ultimate Performance** (Active)

## 🛑 Important Note on Deletion

The script is safe and designed to only delete **custom-created** power schemes. It will **not** delete the built-in Windows defaults (Balanced, Power Saver, High Performance) or the scheme that is currently active.
