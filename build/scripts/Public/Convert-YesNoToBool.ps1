function Convert-YesNoToBool
{
    param($value)
    if ($value -eq 'yes')
    {
        return $true
    }
    else
    {
        return $false
    }
}
