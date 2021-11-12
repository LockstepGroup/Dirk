---
external help file: Dirk-help.xml
Module Name: Dirk
online version:
schema: 2.0.0
---

# Register-DirkScheduledTask

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

### daily
```
Register-DirkScheduledTask -ScheduledTaskCredential <PSCredential> [-JobName <String>] [-Daily]
 [<CommonParameters>]
```

### hourly
```
Register-DirkScheduledTask -ScheduledTaskCredential <PSCredential> [-JobName <String>] [-Hourly]
 [<CommonParameters>]
```

### 5min
```
Register-DirkScheduledTask -ScheduledTaskCredential <PSCredential> [-JobName <String>] [-Every5Minutes]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Daily
{{Fill Daily Description}}

```yaml
Type: SwitchParameter
Parameter Sets: daily
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Every5Minutes
{{Fill Every5Minutes Description}}

```yaml
Type: SwitchParameter
Parameter Sets: 5min
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hourly
{{Fill Hourly Description}}

```yaml
Type: SwitchParameter
Parameter Sets: hourly
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JobName
{{Fill JobName Description}}

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

### -ScheduledTaskCredential
{{Fill ScheduledTaskCredential Description}}

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
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
