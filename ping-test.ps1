# Load the csv
$csvFile = "C:\Users\dcasey\Documents\ipaddrs.csv"
# Ping interval in minutes
$pingInterval = 5 * 60
# Initalize a new snyth voice
# $voice = New-Object -ComObject Sapi.spvoice
# # Make it speak faster

Add-Type -AssemblyName System.Speech
$voice = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$voice.SelectVoice("Microsoft Zira Desktop")
$voice.Rate = 2


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
        continue
    }
    else {
        Write-Host "$Name on $IP is down @ $currentTime."
        $voice.speak("$Name is down!")
    }
}

# Run the Ping-IP function every minute, forever (or until program is stopped).
while ($true) {
    $ipList = Import-Csv -Path $csvFile

    foreach ($entry in $ipList) {
        # Gets the time whenever the function is called 
        $currentTime = Get-Date
        $name = $entry.Name
        $ip = $entry.IP
        Ping-IP -Name $name -IP $ip
    }
    Write-Host "All is well @ $currentTime..."
    Start-Sleep -Seconds $pingInterval
}