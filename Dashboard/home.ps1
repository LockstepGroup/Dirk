New-UDPage -Name "Home" -Icon home -Content {
    New-UDRow {
        New-UDColumn -Size 12 {
            New-UDHtml -Markup "<div class='center-align white-text'><h3>Dirk</h3></h3><h5>Dirk is a PowerShell framework for collecting data from various sources with PowerShell Endpoints and posting that data to other PowerShell Endpoints.</h5></div>"
        }
    }
    New-UDRow {
        New-UDColumn -Size 12 {
            New-UDCard @Colors -Title "Global Config" -Content {$DirkRoot} <# -Endpoint {
                $DirkGlobalConfigPath = Join-Path -Path $DirkRoot -ChildPath 'config.json'
                Get-Content -Path $DirkGlobalConfigPath -Raw | ConvertFrom-Json
            } #>
        }
    }
}