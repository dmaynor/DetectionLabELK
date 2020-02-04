# Purpose: Configure winlogbeat

$service = Get-WmiObject -Class Win32_Service -Filter "Name='winlogbeat'"
If (-not ($service)) {
  choco install winlogbeat -y

  $confFile = @"
  winlogbeat.event_logs:
    - name: ForwardedEvents
      ignore_older: 72h
    
    - name: WEC-Authentication
    - name: WEC-Code-Integrity
    - name: WEC-EMET
    - name: WEC-Powershell
    - name: WEC-Process-Execution
    - name: WEC-Services
    - name: WEC-WMI
    - name: WEC16-Test
    - name: WEC2-Application-Crashes
    - name: WEC2-Applocker
    - name: WEC2-Group-Policy-Errors
    - name: WEC2-Object-Manipulation
    - name: WEC2-Registry
    - name: WEC2-Task-Scheduler
    - name: WEC2-Windows-Defender
    - name: WEC3-Account-Management
    - name: WEC3-Drivers
    - name: WEC3-External-Devices
    - name: WEC3-Firewall
    - name: WEC3-Print
    - name: WEC3-Smart-Card
    - name: WEC3-Windows-Diagnostics
    - name: WEC4-Bits-Client
    - name: WEC4-DNS
    - name: WEC4-Hotpatching-Errors
    - name: WEC4-Shares
    - name: WEC4-System-Time-Change
    - name: WEC4-Windows-Updates
    - name: WEC4-Wireless
    - name: WEC5-Autoruns
    - name: WEC5-Certificate-Authority
    - name: WEC5-Crypto-API
    - name: WEC5-Log-Deletion-Security
    - name: WEC5-Log-Deletion-System
    - name: WEC5-MSI-Packages
    - name: WEC5-Operating-System
    - name: WEC6-ADFS
    - name: WEC6-Device-Guard
    - name: WEC6-Duo-Security
    - name: WEC6-Exploit-Guard
    - name: WEC6-Microsoft-Office
    - name: WEC6-Software-Restriction-Policies
    - name: WEC6-Sysmon
    - name: WEC7-Active-Directory
    - name: WEC7-Privilege-Use
    - name: WEC7-Terminal-Services

  setup.kibana:
    host: "192.168.38.105:5601"

  output.elasticsearch:
    hosts: ["192.168.38.105:9200"]
"@
  $confFile | Out-File -FilePath C:\ProgramData\chocolatey\lib\winlogbeat\tools\winlogbeat.yml -Encoding ascii

  winlogbeat --path.config C:\ProgramData\chocolatey\lib\winlogbeat\tools setup

  Start-Service winlogbeat
}
else {
  Write-Host "winlogbeat is already configured. Moving On."
}
If ((Get-Service -name winlogbeat).Status -ne "Running")
{
  throw "winlogbeat service was not running"
}
