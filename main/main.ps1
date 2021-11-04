. "$PSScriptRoot\classes\mojeGPO.ps1"

$sXML1 = "$PSScriptRoot\testGPOreps\gpo1.xml"
$oXML1 = [xml]$(Get-Content -Path $sXML1)

$oGPO1 = [mojeGPO]::new($oXML1)
$oGPO1.Details

New-HTML -TitleText "$oGPO1.Name" {
    New-HTMLTab -Name "General" {
        New-HTMLSection -Title "Details" {
            New-HTMLTable -DataTable $oGPO1.Details -Simplify {
                New-HTMLTableHeader -Title "$($oGPO1.Name) - Data collected on: $([datetime]$oGPO1.ReadTime)" -FontSize 14 -FontWeight bold
            }
        }-CanCollapse
        
    }

    New-HTMLTab -Name "Computer Configuration ($($oGPO1.Details.GPOStatusComputer))"{}
    New-HTMLTab -Name "User Configuration ($($oGPO1.Details.GPOStatusUser))"{}

} -ShowHTML