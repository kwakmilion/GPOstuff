. "$PSScriptRoot\classes\mojeGPO.ps1"

$sXML1 = "$PSScriptRoot\testGPOreps\gpo2.xml"
$oXML1 = [xml]$(Get-Content -Path $sXML1)

$oGPO1 = [mojeGPO]::new($oXML1)


New-HTML -TitleText "$oGPO1.Name" {
    New-HTMLTab -Name "General" {
        New-HTMLSection -Title "Details" {
            New-HTMLTable -DataTable $oGPO1.Details -Simplify -HideFooter{
                New-HTMLTableHeader -Title "$($oGPO1.Name) - Data collected on: $([datetime]$oGPO1.ReadTime)" -FontSize 14 -FontWeight bold
            }
        } -CanCollapse
    }

    New-HTMLTab -Name "Computer Configuration ($($oGPO1.Details.GPOStatusComputer))"{
    New-HTMLSection -Title "Registry" {   

        foreach ($i in $($oGPO1.RegItemsC|Sort-Object -Property GPOSettingOrder)) {
            New-HTMLSection -Title "$($i.Name) (Order: $($i.GPOSettingOrder))" -Direction column -HeaderBackGroundColor Arsenic -HeaderTextAlignment left -HeaderTextSize 14 {
                New-HTMLSection -Title "General" -HeaderBackGroundColor Astral {
                    New-HTMLTable -DataTable $i.Properties -DisableAutoWidthOptimization -Simplify -HideFooter -ExcludeProperty @("default","DisplayDecimal")
                } -CanCollapse

                $commonData = $i | Select-Object -Property @{n="Stop processing items on this extension if an error occurs on this item";e={$_.bypassErrorsText}},@{n="Remove this item when it is no longer applied";e={$_.removePolicyText}}

                New-HTMLSection -Title "Common" -HeaderBackGroundColor Astral {
                    New-HTMLTable -DataTable $commonData -DisableAutoWidthOptimization -Simplify -HideFooter
                } -CanCollapse
            } -CanCollapse
        } 
    } -CanCollapse -Direction column -HeaderTextSize 16 -HeaderTextAlignment left -HeaderBackGroundColor AmethystSmoke
    }
    New-HTMLTab -Name "User Configuration ($($oGPO1.Details.GPOStatusUser))"{
            
    }
    
} -ShowHTML