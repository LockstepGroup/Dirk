$Colors = @{
    BackgroundColor = "#252525"
    FontColor = "#FFFFFF"
}

$AlternateColors = @{
    BackgroundColor = "#4081C9"
    FontColor = "#FFFFFF"
}

$ScriptColors = @{
    BackgroundColor = "#5A5A5A"
    FontColor = "#FFFFFF"
}

$HomePage = . (Join-Path $PSScriptRoot "home.ps1")
$Footer = . (Join-Path $PSScriptRoot "footer.ps1")

$Cache:DirkRoot = Split-Path -Path $PSScriptRoot


$DirkRoot = Split-Path -Path $PSScriptRoot



$GlobalConfigPage = New-UDPage -Url "/dynamic/:text" -Endpoint {
    New-UDCard -Title 'Edit Global Config' -Content {
        New-UDInput -Title "Simple Form" -Id "Form" -FontColor "#000000" -Content {
            $DirkGlobalConfigPath = Join-Path -Path $DirkRoot -ChildPath 'config.json'
            $Cache:GlobalConfig = Get-Content -Path $DirkGlobalConfigPath -Raw | ConvertFrom-Json
            New-UDInputField -Type 'textbox' -Name 'DatabaseName' -Placeholder 'Database Name' -DefaultValue $Cache:GlobalConfig.SqlConnection.Database
        } -Endpoint {
            param($DatabaseName)
            New-UDInputAction -RedirectUrl "/home"
        }
    }
}


Get-UDDashboard | Stop-UDDashboard

function CreateConfigForm {
    [CmdletBinding()]
    Param (
        [Parameter(Position = 1, Mandatory = $true)]
        [String]$ConfigPath,

        [Parameter(Position = 2, Mandatory = $true)]
        [String]$FormTitle
    )
    
    New-UDCard -Title "Edit $FormTitle" -Content {
        Write-Verbose "Creating Card"
        New-UDInput -Id "FormTitle" -Title "test" -FontColor "#000000" -Content {
            Write-Verbose "Creating Input"
            $Config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json
            $Properties = $Config | Get-Member -MemberType NoteProperty
            Write-Verbose "Properties Count: $($Properties.Count)"
            foreach ($section in $Properties) {
                $SectionName = $section.Name
                Write-Verbose "Section: $SectionName"
                $ConfigProperties = $Config.$SectionName | Get-Member -MemberType NoteProperty

                foreach ($configprop in $ConfigProperties) {
                    
                    $ConfigName = $configprop.name
                    Write-Verbose "Name $ConfigName"
                    Write-Verbose "Placeholder $ConfigName"
                    Write-Verbose "DefaultValue $($Config.$SectionName.$ConfigName)"
                    New-UDInputField -Type 'textbox' -Name $ConfigName -Placeholder $ConfigName -DefaultValue $Config.$SectionName.$ConfigName
                }
            }

            #New-UDInputField -Type 'textbox' -Name 'DatabaseName' -Placeholder 'Database Name' -DefaultValue $Cache:GlobalConfig.SqlConnection.Database
        } -Endpoint {
            param($DatabaseName)
            Wait-Debugger
            New-UDInputAction -Toast $DatabaseName
            #New-UDInputAction -RedirectUrl "/home"
            <# New-UDInputAction -Content @(
                New-UDCard -Title $FormTitle -Text "Here's the config!"
            ) #>
        }
    }
}

$EndPointInit = New-UDEndpointInitialization -Variable @("DirkRoot") -Function @("CreateConfigForm")

$DashBoard = New-UDDashboard -Title "Dirk" -NavBarColor '#FF1c1c1c' -NavBarFontColor "#FF55b3ff" -BackgroundColor "#FF333333" -FontColor "#FFFFFFF" -Content {
    New-UDRow {
        New-UDColumn -Size 12 {
            New-UDHtml -Markup "<div class='center-align white-text'><h3>Dirk</h3></h3><h5>Dirk is a PowerShell framework for collecting data from various sources with PowerShell Endpoints and posting that data to other PowerShell Endpoints.</h5></div>"
        }
    }
    New-UDRow {
        New-UDColumn -Size 12 {
            <# New-UDCard -Title 'Global Config' -ID "GlobalConfigCard" -Content {
                New-UDButton -Text "Edit" -OnClick {
                    Set-UDElement -Id "GlobalConfigCard" -Content {
                        New-UDCard -Title 'Edit Global Config' -Content {
                            New-UDInput -Title "Simple Form" -Id "Form" -FontColor "#000000" -Content {
                                $DirkGlobalConfigPath = Join-Path -Path $DirkRoot -ChildPath 'config.json'
                                $Cache:GlobalConfig = Get-Content -Path $DirkGlobalConfigPath -Raw | ConvertFrom-Json
                                New-UDInputField -Type 'textbox' -Name 'DatabaseName' -Placeholder 'Database Name' -DefaultValue $Cache:GlobalConfig.SqlConnection.Database
                            } -Endpoint {
                                param($DatabaseName)
                                #New-UDInputAction -Toast $DatabaseName
                                New-UDInputAction -RedirectUrl "/home"
                            }
                        }
                    }
                }
            } #>
            New-UDCard -Title 'Global Config Function Test' -ID "GlobalConfigCard2" -Content {
                New-UDButton -Text "Edit" -OnClick {
                    Set-UDElement -Id "GlobalConfigCard" -Content {
                        $DirkGlobalConfigPath = Join-Path -Path $DirkRoot -ChildPath 'config.json'
                        CreateConfigForm $DirkGlobalConfigPath "Global Config"
                    }
                }
            }
            New-UDCard -Title 'Global Config Function Test' -ID "GlobalConfigCard2" -Content {
                $DirkGlobalConfigPath = Join-Path -Path $DirkRoot -ChildPath 'config.json'
                CreateConfigForm $DirkGlobalConfigPath "Global Config"
            }<#
            New-UDCard -Title 'Edit Global Config' -Content {
                New-UDInput -Title "Simple Form" -Id "Form" -FontColor "#000000" -Content {
                    $DirkGlobalConfigPath = Join-Path -Path $DirkRoot -ChildPath 'config.json'
                    $Cache:GlobalConfig = Get-Content -Path $DirkGlobalConfigPath -Raw | ConvertFrom-Json
                    New-UDInputField -Type 'textbox' -Name 'DatabaseName' -Placeholder 'Database Name' -DefaultValue $Cache:GlobalConfig.SqlConnection.Database
                } -Endpoint {
                    param($DatabaseName)
                    #New-UDInputAction -Toast $DatabaseName
                }
            }
            New-UDInput -Title "Module Info Locator"  -FontColor "#000000" -Endpoint {
                param($ModuleName) 
            ​
                # Get a module from the gallery
                $Module = Find-Module $ModuleName
            ​
                # Output a new card based on that info
                New-UDInputAction -Content @(
                    New-UDCard -Title "$ModuleName - $($Module.Version)" -Text $Module.Description
                )
            } #>
        }
    }
} -Footer $Footer -EndpointInitialization $EndPointInit

Start-UDDashboard -Dashboard $DashBoard -Port 10001 -AutoReload