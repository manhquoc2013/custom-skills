$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$version = (Get-Content (Join-Path $root "VERSION") -Raw).Trim()
$manifest = Join-Path $root "recommended-skills.tsv"
$cacheRoot = Join-Path $env:USERPROFILE ".cache\engineering-skills"

$withRecommended = $args -contains "--with-recommended"
$noRecommended = $args -contains "--no-recommended"
$mode = ""
foreach ($arg in $args) {
  if ($arg -in @("--list", "--all", "--update")) { $mode = $arg }
}

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

function Read-Bundles {
  $bundles = @()
  foreach ($line in Get-Content $manifest) {
    if ($line -match '^\s*#' -or [string]::IsNullOrWhiteSpace($line)) { continue }
    $parts = $line -split '\|', 5
    $bundles += @{ Id = $parts[0]; Title = $parts[1]; Repo = $parts[2]; Branch = $parts[3]; Paths = $parts[4] }
  }
  return $bundles
}

function Test-SkillPresent($name) {
  foreach ($target in $targets) {
    $skill = Join-Path (Join-Path $env:USERPROFILE $target.Dest) "$name\SKILL.md"
    if (Test-Path $skill) { return $true }
  }
  $plugins = Join-Path $env:USERPROFILE ".cursor\plugins"
  if (Test-Path $plugins) {
    $hit = Get-ChildItem -Path $plugins -Recurse -Filter SKILL.md -ErrorAction SilentlyContinue |
      Where-Object { $_.Directory.Name -eq $name } |
      Select-Object -First 1
    if ($hit) { return $true }
  }
  return $false
}

function Get-MissingNames($paths) {
  $missing = @()
  foreach ($relPath in ($paths -split ',')) {
    $name = Split-Path $relPath -Leaf
    if (-not (Test-SkillPresent $name)) { $missing += $name }
  }
  return $missing
}

function Install-Recommended($rels) {
  $rels = @($rels)
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Cần git để cài skill bổ sung."
  }
  $bundles = Read-Bundles
  New-Item -ItemType Directory -Force -Path $cacheRoot | Out-Null
  foreach ($bundle in $bundles) {
    if (@(Get-MissingNames $bundle.Paths).Count -eq 0) {
      Write-Output "Đã có $($bundle.Title), không cài lại."
      continue
    }
    $cache = Join-Path $cacheRoot $bundle.Id
    if (-not (Test-Path (Join-Path $cache ".git"))) {
      git clone --depth 1 --branch $bundle.Branch $bundle.Repo $cache
    } else {
      git -C $cache fetch --depth 1 origin $bundle.Branch
      git -C $cache reset --hard FETCH_HEAD
    }
    foreach ($relPath in ($bundle.Paths -split ',')) {
      $name = Split-Path $relPath -Leaf
      if (Test-SkillPresent $name) {
        Write-Output "Đã có $name, không cài lại."
        continue
      }
      $src = Join-Path $cache ($relPath -replace '/', '\')
      if (-not (Test-Path $src)) {
        Write-Output "Thiếu $src"
        continue
      }
      foreach ($rel in $rels) {
        $dest = Join-Path $env:USERPROFILE $rel
        $target = Join-Path $dest $name
        if ((Test-Path $target) -and -not ((Get-Item $target -Force).Attributes -band [IO.FileAttributes]::ReparsePoint)) {
          Write-Output "Giữ $target vì thư mục này không phải junction."
          continue
        }
        if (Test-Path $target) { Remove-Item $target -Force }
        New-Item -ItemType Junction -Path $target -Target $src | Out-Null
        Write-Output "linked $name into $dest"
      }
    }
  }
  $ids = ($bundles | ForEach-Object { $_.Id }) -join "`n"
  foreach ($rel in $rels) {
    Set-Content -Path (Join-Path (Join-Path $env:USERPROFILE $rel) ".engineering-skills-extras") -Value $ids
  }
}

function Offer-Recommended($rels) {
  $rels = @($rels)
  if ($rels.Count -eq 0 -or $noRecommended) { return }
  if ($withRecommended) {
    Install-Recommended $rels
    return
  }
  if ([Console]::IsInputRedirected) {
    Write-Output "Thêm --with-recommended để cài skill bổ sung vào các IDE vừa chọn."
    return
  }
  $pending = @((Read-Bundles) | Where-Object { @(Get-MissingNames $_.Paths).Count -gt 0 })
  if ($pending.Count -eq 0) {
    Write-Output "Skill bổ sung đã có trên máy, không cài lại."
    return
  }
  Write-Output "Nên cài thêm. Pack này đọc chúng khi có trên máy:"
  foreach ($bundle in $pending) { Write-Output "  - $($bundle.Title)" }
  $answer = Read-Host "Tự động cài vào các IDE vừa chọn? Enter = có, n = không"
  if ([string]::IsNullOrWhiteSpace($answer) -or $answer -match '^(y|yes|có)$') {
    Install-Recommended $rels
  } else {
    Write-Output "Bỏ qua skill bổ sung."
  }
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

if ($mode -eq "--list") { exit 0 }

$chosen = @()
if ($mode -eq "--all") {
  foreach ($target in $found) {
    Install-One $target.Dest
    $chosen += $target.Dest
  }
  Offer-Recommended $chosen
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
  $rels = @($found | ForEach-Object { $_.Dest })
  if ($withRecommended) {
    Install-Recommended $rels
  } else {
    $marked = @($rels | Where-Object { Test-Path (Join-Path (Join-Path $env:USERPROFILE $_) ".engineering-skills-extras") })
    if ($marked.Count -gt 0) { Install-Recommended $marked }
  }
  exit 0
}

$answer = Read-Host "Nhập số, cách nhau bằng dấu phẩy, hoặc all. Enter = tất cả"
if ([string]::IsNullOrWhiteSpace($answer) -or $answer -eq "all") {
  foreach ($target in $found) { $chosen += $target.Dest }
} else {
  foreach ($token in ($answer -split ",")) {
    $token = $token.Trim()
    $index = 0
    if (-not [int]::TryParse($token, [ref]$index) -or $index -lt 1 -or $index -gt $found.Count) {
      Write-Error "Số không hợp lệ: $token"
    }
    $chosen += $found[$index - 1].Dest
  }
}
foreach ($rel in $chosen) { Install-One $rel }
Offer-Recommended $chosen
