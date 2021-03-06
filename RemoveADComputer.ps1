﻿remove-item "c:\Scripts\summary report*"

Import-Module ActiveDirectory 
$File = “c:\Scripts\mycomputers.txt”
$logfile="c:\Scripts\summary report_"+(get-date -format ddMMyyyy)+".txt"
# $logfile1="c:\Scripts\summary report_"+(get-date -format ddMMyyyy)+".txt"

$sum_success=0
$sum_fail=0
ForEach ($Computer in (Get-Content $File))
{
   Try {
        Remove-ADComputer $Computer -ErrorAction Stop
        Add-Content $logfile -Value “$Computer removed”
        $sum_success+=1
    }
    Catch {
        Add-Content $logfile -Value “$Computer delete failed due to $($Error[0])”
        $sum_fail+=1
    }
}
### $sum_success
### $sum_fail

$messageParameters = @{                        
                Subject = "Remove Computer Report  - $((Get-Date).ToShortDateString())"                    
                Body = "Finally $sum_success computers removed and $sum_fail failed, please check attachment for detail"  
                attachment= $logfile                  
                From = "aaa@bbb.com"                        
                To = "aaa@bbb.com"                        
                SmtpServer = "mailrelay.server"                        
            }                        
            Send-MailMessage @messageParameters -BodyAsHtml 
