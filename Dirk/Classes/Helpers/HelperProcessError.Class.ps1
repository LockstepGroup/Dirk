class HelperProcessError {
    static [hashtable] newExceptionDefinition ([string]$exceptionType, $exceptionCategory, [string]$message) {
        $new = @{}
        $new.Exception = New-Object -TypeName $exceptionType -ArgumentList $message
        $new.Category = $exceptionCategory
        return $new
    }

    static [System.Management.Automation.ErrorRecord] throwCustomError ([int]$errorId, [psobject]$object) {
        $ErrorLookup = [HelperProcessError]::ExceptionDefinitions.$errorId
        return [System.Management.Automation.ErrorRecord]::new(
            $ErrorLookup.Exception,
            $errorId,
            $ErrorLookup.Category,
            $object
        )
    }

    # List of Exceptions
    # The Types and Categories here are generic because I have no idea what subset exist in both core and non-core.
    static [hashtable] $ExceptionDefinitions = @{
        1000 = [HelperProcessError]::newExceptionDefinition('System.ArgumentException', [System.Management.Automation.ErrorCategory]::CloseError, '$env:DirkRoot already exists in $profile.AllUsersAllHosts. Use -Force to overwrite.')
        1001 = [HelperProcessError]::newExceptionDefinition('System.ArgumentException', [System.Management.Automation.ErrorCategory]::CloseError, '$env:DirkRoot does not exist, please set to a valid directory.')
        1002 = [HelperProcessError]::newExceptionDefinition('System.ArgumentException', [System.Management.Automation.ErrorCategory]::CloseError, 'GithubCredential is required, either specify explicitly with -GithubCredental, or define $global:GithubCredential.')
    }

    # Constructor
    HelperProcessError () {
    }
}