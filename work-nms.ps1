# Load the csv
$csvFile = "C:\Users\dcasey\Documents\ipaddrs.csv"
# Ping interval in minutes
$pingInterval = 60
# Initalize a new snyth voice
Add-Type -AssemblyName System.Speech
$voice = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$voice.SelectVoice("Microsoft Zira Desktop")
$voice.Rate = 2
# This write host is here so that when the program initally starts it has cohesive formatting throughout
Write-Host "================================================"

# Function to ping files from the csv columns Name and IP. Uses the Test-Connection cmdlet to ping the specified IP addresses. $pingResult returns True or False
# depending if the cmdlet returned a true or a false it will speak the name of the ping that failed to the user.
function Ping-IP {
    Param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$IP
    )
    # Returns a boolean value 
    $pingResult = Test-Connection -ComputerName $IP -Count 1 -Quiet -ErrorAction SilentlyContinue
    if ($pingResult) {
        Write-Host "$Name on $IP is OK!" -ForegroundColor Green
    }
    else { 
        Write-Host "$Name on $IP is DOWN!" -ForegroundColor Red
        $voice.speak("$Name is down!")
    }
}

# Run the Ping-IP function every minute, forever (or until program is stopped).
while ($true) {
    $ipList = Import-Csv -Path $csvFile
    $dateTime = Get-Date
    $date, $time = $dateTime.ToString("MM/dd/yy"), $dateTime.ToString("hh:mm:ss tt")
    Write-Host "Pinging services on $date @ $time..."
    Write-Host "================================================"
    foreach ($entry in $ipList) {
        # Gets the time whenever the function is called 
        $appName = $entry.Name
        $appIP = $entry.IP
        Ping-IP -Name $appName -IP $appIP
    }
    Write-Host "================================================"
    Start-Sleep -Seconds $pingInterval
}