# Local-Server-Check-Utility-Script
Batch script for testing connectivity and basic services of servers within a local network.

## Features

- **Ping check**  
  Verifies basic network connectivity to the target server.

- **DNS lookup**  
  Resolves hostname to IP address.

- **Reverse DNS lookup**  
  Resolves IP address back to hostname.

- **Trace route**  
  Shows the network path to the server.

- **SMB port 445 check**  
  Tests file sharing (SMB) connectivity.

- **RDP port 3389 check**  
  Checks if Remote Desktop is reachable.

- **WinRM port 5985 check**  
  Verifies Windows Remote Management access.

- **HTTP port 80 check**  
  Tests basic web service connectivity.

- **HTTPS port 443 check**  
  Tests secure web service connectivity.

- **SQL port 1433 check**  
  Checks SQL Server connectivity.

- **Net view check**  
  Attempts to list shared resources on the server.

- **Full check**  
  Runs all available checks in sequence.

- **Custom target input**  
  Allows checking any server by hostname or IP.

- **Report generation**  
  Saves results to: Desktop\ServerReports

  - **Simple menu interface**  
Easy selection of checks via menu options.

## Usage

Run: Local_Server_Check_Utility.bat

Enter a server name or IP address and select the desired checks.
