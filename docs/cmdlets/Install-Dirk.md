---
external help file: Dirk-help.xml
Module Name: Dirk
online version:
schema: 2.0.0
---

# Install-Dirk

## SYNOPSIS
Downloads Dirk scripts repo (Todd) and sets env:DirkRoot

## SYNTAX

```
Install-Dirk [[-Path] <String>] [-GithubCredential <PSCredential>] [-Force] [-Branch <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Downloads Dirk scripts repo (Todd) and sets $env:DirkRoot in $profile.AllUsersAllHosts so other Dirk commands can operate.

## EXAMPLES

### Example 1
```powershell
> Install-Dirk -Path /path/to/Dirk -Credential (Get-Credential)
```

Prompts for Github Credentials, downloads Todd Repo to '/path/to/Dirk', sets $env:DirkRoot to '/path/to/Dirk'.

### Example 2
```powershell
> Install-Dirk -Path /path/to/Dirk
```

Uses $global:GithubCredential, downloads Todd Repo to '/path/to/Dirk', sets $env:DirkRoot to '/path/to/Dirk'.

### Example 3
```powershell
> Install-Dirk
```

Uses $global:GithubCredential, downloads Todd Repo to 'c:\lockstep', sets $env:DirkRoot to 'c:\lockstep'.

## PARAMETERS

### -Path
Desired local path for Dirk script repository (Todd)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
{{Fill Force Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GithubCredential
{{Fill GithubCredential Description}}

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Branch
{{Fill Branch Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
