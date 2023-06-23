# Powershell-Enrollment

# Deployment


💡 **This project aims to automate the process of deploying Windows to various devices using PowerShell scripts and other tools. The project consists of the following components:**


## WinPE

- [WinPE stands for Windows Preinstallation Environment, which is a lightweight version of Windows that can be used to install, troubleshoot, or recover Windows on a device**1**](https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/vscode/using-vscode?view=powershell-7.3).
- [WinPE can be booted from a USB drive, a CD/DVD, or over the network using PXE**1**](https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/vscode/using-vscode?view=powershell-7.3).
- [WinPE can run PowerShell scripts and commands to perform various tasks, such as partitioning disks, applying images, configuring settings, and installing drivers**2**](https://adamtheautomator.com/powershell-script-examples/).

## Windows ADK

- [Windows ADK stands for Windows Assessment and Deployment Kit, which is a collection of tools and documentation that help you customize, assess, and deploy Windows operating systems to new devices**3**](https://superuser.com/questions/1766329/how-to-create-a-new-powershell-project-from-visual-studio).
- [Windows ADK includes tools such as Windows System Image Manager (Windows SIM), Deployment Image Servicing and Management (DISM), User State Migration Tool (USMT), and Windows Performance Toolkit (WPT)**3**](https://superuser.com/questions/1766329/how-to-create-a-new-powershell-project-from-visual-studio).
- [Windows ADK also includes the Windows PE add-on, which provides the files and tools to build custom WinPE images**4**](https://www.guru99.com/powershell-tutorial.html).

## Windows SIM

- Windows SIM stands for Windows System Image Manager, which is a tool that helps you create answer files that automate Windows installations.
- An answer file is an XML file that contains the settings and configuration options that you want to apply to a Windows image during installation.
- You can use Windows SIM to create answer files for different types of installations, such as clean install, upgrade, or sysprep.

## PowerShell Scripts

- PowerShell scripts are files that contain PowerShell commands and expressions that can be executed as a single unit.
- PowerShell scripts have the .ps1 file extension and can be run from the PowerShell console or from other scripts or programs.
- PowerShell scripts can perform various tasks, such as debloating Windows, installing applications, updating Windows, doing company-specific assignments, cleaning up and deleting files.

# Project Workflow

The project workflow consists of the following steps:

1. Create a custom WinPE image using the Windows PE add-on from the Windows ADK.
2. Create an answer file using Windows SIM that specifies the settings and configuration options for the Windows installation.
3. Copy the WinPE image, the answer file, and the PowerShell scripts to a bootable USB drive or a network share.
4. Boot the target device from the USB drive or the network using WinPE.
5. Run the PowerShell scripts from WinPE to perform various tasks, such as partitioning disks, applying images, configuring settings, and installing drivers.
6. Restart the device and complete the Windows installation using the answer file.
7. Run additional PowerShell scripts from Windows to perform more tasks, such as debloating Windows, installing applications, updating Windows, doing company-specific assignments, cleaning up and deleting files.

# Project Benefits

The project benefits include:

- Saving time and effort by automating repetitive and tedious tasks.
- Reducing human errors and inconsistencies by using standardized and tested scripts and tools.
- Improving security and performance by removing unwanted features and applications from Windows.
- Enhancing customization and flexibility by using answer files and PowerShell scripts to configure Windows according to specific needs and preferences.


## Instructions
Download Enrollment als .zip.
Creeer een folder op C:/ genaamd files.
Zet "Admin, Drivers, Scripts, WinForm" in C:/files.
Onder C:/files/scripts staat een bestand genaamd "Click Me.bat", rechter muisklik en selecteer run as admin.

Het process zal meerdere keren opnieuw opstarten. na elke keer opnieuw opstarten todat C:/files niet meer bestaat.


