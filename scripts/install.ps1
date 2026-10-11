$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$version = (Get-Content (Join-Path $root "VERSION") -Raw).Trim()

$targets = @(
  @{ Id = "cursor"; Label = "Cursor"; Dest = ".cursor\skills"; Seen = { Test-Path "$env:USERPROFILE\.cursor" -or (Get-Command cursor -ErrorAction SilentlyContinue) } }
  @{ Id = "claude"; Label = "Claude Code"; Dest = ".claude\skills"; Seen = { Test-Path "$env:USERPROFILE\.claude" -or (Get-Command claude -ErrorAction SilentlyContinue) } }
  @{ Id = "antigravity"; Label = "Antigravity"; Dest = ".gemini\antigravity\skills"; Seen = { Test-Path "$env:USERPROFILE\.gemini\antigravity" -or Test-Path "$env:USERPROFILE\.antigravity" -or (Get-Command agy -ErrorAction SilentlyContinue) } }
  @{ Id = "codex"; Label = "Codex"; Dest = ".codex\skills"; Seen = { Test-Path "$env:USERPROFILE\.codex" -or (Get-Command codex -ErrorAction SilentlyContinue) } }
  @{ Id = "agents"; Label = "Agents"; Dest = ".agents\skills"; Seen = { Test-Path "$env:USERPROFILE\.agents" } }
)

$names = @(
  "installing-skills",
  "coordinating-agents",
  "routing-engineering-work",
  "scaffolding-project",
  "specifying-a-feature",
  "implementing-from-spec",
  "prompting-the-loop",
  "running-the-loop",
  "processing-the-flow",
  "designing-interface"
)

function Install-One($rel) {
  $dest = Join-Path $env:USERPROFILE $rel
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  foreach ($name in $names) {
    $link = Join-Path $dest $name
    if (Test-Path $link) { Remove-Item $link -Force }
    New-Item -ItemType Junction -Path $link -Target (Join-Path $root $name) | Out-Null
  }
  Set-Content -Path (Join-Path $dest ".engineering-skills-version") -Value $version
  Write-Output "linked $($names.Count) skills into $dest ($version)"
}

$found = @()
foreach ($target in $targets) {
  if (& $target.Seen) { $found += $target }
}

if ($found.Count -eq 0) {
  Write-Output "Không thấy Cursor, Claude Code, Antigravity, Codex, hay .agents."
  exit 1
}

Write-Output "Repo $version. IDE tìm thấy:"
for ($n = 0; $n -lt $found.Count; $n++) {
  $dest = Join-Path $env:USERPROFILE $found[$n].Dest
  $marker = Join-Path $dest ".engineering-skills-version"
  $state = "chưa cài"
  if (Test-Path $marker) {
    $current = (Get-Content $marker -Raw).Trim()
    if ($current -eq $version) { $state = "đã cài $current" } else { $state = "đã cài $current, repo là $version" }
  } elseif (Test-Path (Join-Path $dest "processing-the-flow")) {
    $state = "đã gắn, chưa ghi phiên bản"
  }
  Write-Output ("  [{0}] {1,-14} {2}  {3}" -f ($n + 1), $found[$n].Label, $dest, $state)
}

$mode = if ($args.Count -gt 0) { $args[0] } else { "" }
if ($mode -eq "--list") { exit 0 }
if ($mode -eq "--all") {
  foreach ($target in $found) { Install-One $target.Dest }
  exit 0
}
if ($mode -eq "--update") {
  foreach ($target in $found) {
    $dest = Join-Path $env:USERPROFILE $target.Dest
    $marker = Join-Path $dest ".engineering-skills-version"
    $current = if (Test-Path $marker) { (Get-Content $marker -Raw).Trim() } else { "" }
    if ($current -eq $version) {
      Write-Output "Giữ $($target.Label) ở $version"
    } elseif ($current -or (Test-Path (Join-Path $dest "processing-the-flow"))) {
      Install-One $target.Dest
    }
  }
  exit 0
}

$answer = Read-Host "Nhập số, cách nhau bằng dấu phẩy, hoặc all. Enter = tất cả"
if ([string]::IsNullOrWhiteSpace($answer) -or $answer -eq "all") {
  foreach ($target in $found) { Install-One $target.Dest }
  exit 0
}
foreach ($token in ($answer -split ",")) {
  $token = $token.Trim()
  $index = 0
  if (-not [int]::TryParse($token, [ref]$index) -or $index -lt 1 -or $index -gt $found.Count) {
    Write-Error "Số không hợp lệ: $token"
  }
  Install-One $found[$index - 1].Dest
}
