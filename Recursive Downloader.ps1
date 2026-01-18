# Base URL (replace with your encoded URL)
$baseUrl = "YOUR URL"

# Local folder to save files
$downloadPath = "C:\Downloads"
New-Item -ItemType Directory -Force -Path $downloadPath | Out-Null

function Get-Links($url) {
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        return $response.Links | ForEach-Object { $_.href } | Where-Object {
            $_ -and $_ -ne "../" -and -not ($_.Contains("?"))
        }
    }
    catch {
        Write-Host "Failed to access $url"
        return @()
    }
}

function Download-FilesRecursively($url, $localPath) {
    Write-Host "Scanning $url"
    $links = Get-Links $url

    $jobs = @()

    foreach ($href in $links) {
        $fileUrl = $url + $href
        $localFile = Join-Path $localPath $href

        if ($href.EndsWith("/")) {
            # It's a folder → recurse
            New-Item -ItemType Directory -Force -Path $localFile | Out-Null
            Download-FilesRecursively $fileUrl $localFile
        }
        else {
            # Queue file download as a background job
            Write-Host "Queueing $fileUrl"
            $jobs += Start-Job -ScriptBlock {
                param($u, $f)
                try {
                    Invoke-WebRequest -Uri $u -OutFile $f
                }
                catch {
                    Write-Host "Failed to download $u"
                }
            } -ArgumentList $fileUrl, $localFile
        }
    }

    # Wait for all jobs in this folder to finish
    if ($jobs.Count -gt 0) {
        $jobs | Wait-Job | Receive-Job
        $jobs | Remove-Job
    }
}

# Start recursive download
Download-FilesRecursively $baseUrl $downloadPath
