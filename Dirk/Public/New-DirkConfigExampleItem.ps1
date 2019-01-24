function New-DirkConfigExampleItem {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$RequiredType,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Prompt,

        [Parameter(Mandatory = $true, Position = 2)]
        [string]$Example,

        [Parameter(Mandatory = $false)]
        [switch]$Required
    )

    BEGIN {
        $VerbosePrefix = "New-DirkConfigExampleItem:"
    }

    PROCESS {
        $ReturnObject = @{}
        $ReturnObject.RequiredType = $RequiredType
        $ReturnObject.Prompt = $Prompt
        $ReturnObject.Example = $Example
        $ReturnObject.Required = $Required
    }

    END {
        $ReturnObject
    }
}