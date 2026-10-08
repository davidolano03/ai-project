param(
  [Parameter(Mandatory=$true)][string]$LeanExecutable,
  [Parameter(Mandatory=$true)][string]$PackagesDirectory
)
$ErrorActionPreference = 'Stop'
$packageRoot = (Resolve-Path -LiteralPath $PackagesDirectory).Path
$leanBinary = (Resolve-Path -LiteralPath $LeanExecutable).Path
$libraryPaths = Get-ChildItem -LiteralPath $packageRoot -Directory | ForEach-Object {
  $candidate = Join-Path $_.FullName '.lake\build\lib\lean'
  if (Test-Path -LiteralPath $candidate) { $candidate }
}
if (-not $libraryPaths) { throw 'No compiled Mathlib dependencies found.' }
$env:LEAN_PATH = $libraryPaths -join ';'
$env:LEAN_NUM_THREADS = '1'
Push-Location $PSScriptRoot
try {
  foreach ($entry in @(
    @{ Source='BaselineAudit.lean'; Log='baseline-check.txt' },
    @{ Source='Transparency.lean'; Log='transparency-check.txt' }
  )) {
    $lines = & $leanBinary $entry.Source 2>&1
    $result = $LASTEXITCODE
    $lines | Set-Content -LiteralPath $entry.Log -Encoding UTF8
    if ($result -ne 0) { throw ('Lean failed: ' + $entry.Source) }
    if (($lines -join "\n") -match 'sorryAx|error:') {
      throw ('Unchecked result in ' + $entry.Source)
    }
    Write-Output ('PASS ' + $entry.Source)
  }
}
finally { Pop-Location }
