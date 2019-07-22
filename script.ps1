Start-Sleep(600)

while($true) {

    Start-Sleep(90)

    

    try{
        #$yesterday = (Get-Date).AddDays(-1)

        #$year = $yesterday.Year.ToString()
        #$month = $yesterday.Month.ToString().PadLeft(2,'0')
        #$day = $yesterday.Day.ToString().PadLeft(2,'0')

        $year = "2022"
        $month = "01"
        $day = "01"

        $date = "http://viking-ewm:8080/orders?id=TEST&date=" + $year+"-"+$month+"-"+$day

        $login = Invoke-WebRequest -Uri "http://viking-ewm:8080/authenticate?username=watchdog&password=372347&company=0" -SessionVariable my_session
        $pickuplist = Invoke-WebRequest -Uri $date -WebSession $my_session


        $compeltedinvoices = $pickuplist | ConvertFrom-Json | select results -ExpandProperty results #| ? status -like 2 
       
        $invno = $compeltedinvoices.invno

        $testuri = "http://viking-ewm:8080/detail?id=" + $invno
        $testloadinvoice = Invoke-WebRequest -Uri $testuri -WebSession $my_session | ConvertFrom-Json

        if (($testloadinvoice.message -eq "OK") -and ($testloadinvoice.success) ) {
            #write-host $testloadinvoice | ft -AutoSize
            Write-Host ("invoice loaded sucescfull")

        }else{
            #write-host $testloadinvoice | ft -AutoSize
            Write-Host("error")
            Shutdown /r /f /t 10 /c "EWM ERROR DETECED REBOOTING"
        }
        

    }catch{
        Write-Host ("soemthing failed")
        Shutdown /r /f /t 10 /c "EWM ERROR DETECED REBOOTING"

    }


     Write-Output("Waiting 90 seconds");
     Write-Output((get-date).ToString());
}
