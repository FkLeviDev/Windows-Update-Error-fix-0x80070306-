# WUFIX - Windows Update Fix Utility (PowerShell)

[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/YOUR_USERNAME/WUFIX?style=social)](https://github.com/YOUR_USERNAME/WUFIX/stargazers)

---

## ✨ Project Overview

**WUFIX** is a PowerShell script designed for the quick and automated repair of common Windows Update errors, such as the **0x80070306** code. The script stops critical Windows Update services, resets the update cache, repairs corrupted system files, and then **automatically triggers a reboot** followed by a **Windows Update scan** upon startup.

This PowerShell version enhances the reliability of previous Batch versions by using native PowerShell commands and automatically handling administrator privilege checks.

---

## 🚀 Features

* **Administrator Check:** Automatically checks for and relaunches the script with administrator privileges (UAC prompt).
* **Reset Update Components:** Stops necessary services (`wuauserv`, `bits`, `cryptSvc`) and renames the `SoftwareDistribution` and `Catroot2` folders.
* **System Image Repair:** Executes the `DISM /RestoreHealth` command to fix corruption in the Windows Image Store.
* **System File Check:** Executes the `SFC /SCANNOW` command to verify and repair critical system files.
* **Automated Completion:** After repair, the computer is **immediately rebooted** (`Restart-Computer -Force`) after a 5-second countdown.
* **Post-Reboot Update:** Creates a scheduled task that executes a Windows Update scan immediately upon the system starting up after the reboot.

---

## 💻 Usage

### Requirements

* Windows 10 / 11
* PowerShell (Default)
* Active internet connection (required for DISM/SFC components).

### How to Run

1. Download the **`WUFIX.ps1`** file.
2. Open a **PowerShell** window.
3. Navigate to the folder containing the script (e.g., `cd C:\Users\YourName\Desktop`).
4. Execute the script using the following command:

    ```powershell
    .\WUFIX.ps1
    ```

    > **Note:** If you receive an `execution policy` error, you might need to temporarily allow scripts to run by executing (as Administrator):
    > `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process`

5. The script will launch, request Administrator rights (UAC), perform the 6 steps, display a final message, and **automatically reboot your computer after 5 seconds**.

---

## ⚠️ Important Safety Notes

* **WARNING:** This script performs a **forced reboot** (`Restart-Computer -Force`) immediately after completion. **Save all your work** before running this script!
* The DISM and SFC processes can take several minutes to complete. Do not close the window until the script displays the final completion message.

---

## 📜 Code Snippets (Key Steps)

| Purpose | Command (PowerShell) |
| :--- | :--- |
| **Stop Service** | `Stop-Service -Name wuauserv` |
| **Rename Folder** | `Rename-Item -Path C:\Windows\SoftwareDistribution -NewName SoftwareDistribution.old` |
| **Image Repair** | `& dism /Online /Cleanup-Image /RestoreHealth` |
| **Schedule Update** | `& schtasks /create /tn WUFIX_PostReboot_Update /tr "..." /sc ONSTART` |
| **Immediate Reboot** | `Restart-Computer -Force` |

---

## 🤝 Contribution

Fixes, suggestions, and bug reports are welcome! Please open an Issue or send a Pull Request.

## ⚖️ License (MIT)

This project is licensed under the MIT License.

**MIT License**

Copyright (c) 2025 Predox | FKLEVI Dev

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## 📧 Contact

Predox | FKLEVI Dev - [Insert your email or GitHub profile link here]

---
*Created by Predox | FKLEVI Dev*
