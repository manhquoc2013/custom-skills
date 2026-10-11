$ErrorActionPreference = "Stop"
$branch = if ($env:CUSTOM_SKILLS_REF) { $env:CUSTOM_SKILLS_REF } else { "main" }
$url = if ($env:CUSTOM_SKILLS_URL) { $env:CUSTOM_SKILLS_URL } else { "https://github.com/manhquoc2013/custom-skills/archive/refs/heads/$branch.tar.gz" }
$work = Join-Path ([System.IO.Path]::GetTempPath()) ("custom-skills-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $work | Out-Null

try {
  $archive = Join-Path $work "src.tar.gz"
  if ($env:CUSTOM_SKILLS_TARBALL) {
    Copy-Item $env:CUSTOM_SKILLS_TARBALL $archive
  } else {
    Invoke-WebRequest -Uri $url -OutFile $archive
  }
  tar -xzf $archive -C $work
  Remove-Item $archive

  $root = $work
  if (-not (Test-Path (Join-Path $root "scripts\install.ps1"))) {
    $nested = Get-ChildItem $work -Directory | Where-Object { Test-Path (Join-Path $_.FullName "scripts\install.ps1") } | Select-Object -First 1
    if (-not $nested) { throw "Không thấy scripts/install.ps1 trong bản tải về." }
    $root = $nested.FullName
  }
  & (Join-Path $root "scripts\install.ps1") @args
} finally {
  if (Test-Path $work) { Remove-Item $work -Recurse -Force }
}
