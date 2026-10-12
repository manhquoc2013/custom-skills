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
if ($args -contains "--pull") {
  git -C $root pull --ff-only
  $version = (Get-Content (Join-Path $root "VERSION") -Raw).Trim()
}

$agentsFile = Join-Path $root "scripts\agents.tsv"
$targets = @()
foreach ($line in Get-Content $agentsFile) {
  if ($line -match '^\s*#' -or [string]::IsNullOrWhiteSpace($line)) { continue }
  $parts = $line -split '\|', 4
  $targets += @{ Id = $parts[0]; Label = $parts[1]; Detect = $parts[2]; Dests = @($parts[3] -split ',') }
}

function Test-AgentPresent($detect) {
  foreach ($token in ($detect -split ',')) {
    if ($token.StartsWith("bin:")) {
      if (Get-Command $token.Substring(4) -ErrorAction SilentlyContinue) { return $true }
    } elseif ($token.StartsWith("app:")) {
      if (Test-Path $token.Substring(4)) { return $true }
    } elseif (Test-Path (Join-Path $env:USERPROFILE ($token -replace '/', '\'))) {
      return $true
    }
  }
  return $false
}

$names = @(
  "c-install",
  "c-agents",
  "c-route",
  "c-scaffold",
  "c-spec",
  "c-implement",
  "c-prompt",
  "c-loop",
  "c-process",
  "c-flow",
  "c-design",
  "c-review",
  "c-refactor",
  "c-lint",
  "c-perf",
  "c-debug"
)

function Remove-SkillPath($path) {
  if (-not (Test-Path $path)) { return }
  $item = Get-Item $path -Force
  if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
    cmd.exe /c "rmdir `"$path`""
  } else {
    Remove-Item $path -Recurse -Force
  }
}

function Copy-Skill($src, $destSkill) {
  Remove-SkillPath $destSkill
  Copy-Item -Path $src -Destination $destSkill -Recurse -Force
}

function Install-One($rel) {
  $dest = Join-Path $env:USERPROFILE $rel
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  foreach ($name in $names) {
    Copy-Skill (Join-Path $root $name) (Join-Path $dest $name)
  }
  $legacy = @(
    "installing-skills", "coordinating-agents", "routing-engineering-work",
    "scaffolding-project", "specifying-a-feature", "implementing-from-spec",
    "prompting-the-loop", "running-the-loop", "processing-the-flow",
    "designing-interface", "reviewing-code", "refactoring-code",
    "checking-lint", "improving-performance", "debugging-a-failure",
    "install", "agents", "route", "scaffold", "spec", "implement",
    "prompt", "loop", "process", "flow", "design", "review",
    "refactor", "lint", "perf", "debug"
  )
  foreach ($name in $legacy) {
    Remove-SkillPath (Join-Path $dest $name)
  }
  Set-Content -Path (Join-Path $dest ".engineering-skills-version") -Value $version
  Write-Output "installed $($names.Count) skills into $dest ($version)"
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
  foreach ($agent in $targets) {
    foreach ($rel in $agent.Dests) {
      $skill = Join-Path (Join-Path $env:USERPROFILE ($rel -replace '/', '\')) "$name\SKILL.md"
      if (Test-Path $skill) { return $true }
    }
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
        Copy-Skill $src $target
        Write-Output "installed $name into $dest"
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
    $ids = (Read-Bundles | ForEach-Object { $_.Id }) -join "`n"
    foreach ($rel in $rels) {
      Set-Content -Path (Join-Path (Join-Path $env:USERPROFILE $rel) ".engineering-skills-extras") -Value $ids
    }
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
  if (Test-AgentPresent $target.Detect) { $found += $target }
}

if ($found.Count -eq 0) {
  Write-Output "Không thấy IDE hoặc CLI nào trong scripts/agents.tsv."
  exit 1
}

Write-Output "Repo $version. IDE và CLI tìm thấy:"
for ($n = 0; $n -lt $found.Count; $n++) {
  $first = $found[$n].Dests[0] -replace '/', '\'
  $dest = Join-Path $env:USERPROFILE $first
  $marker = Join-Path $dest ".engineering-skills-version"
  $state = "chưa cài"
  if (Test-Path $marker) {
    $current = (Get-Content $marker -Raw).Trim()
    if ($current -eq $version) { $state = "đã cài $current" } else { $state = "đã cài $current, repo là $version" }
  } elseif ((Test-Path (Join-Path $dest "c-flow")) -or (Test-Path (Join-Path $dest "flow")) -or (Test-Path (Join-Path $dest "processing-the-flow"))) {
    $state = "đã gắn, chưa ghi phiên bản"
  }
  $where = ($found[$n].Dests -join ",")
  Write-Output ("  [{0}] {1,-16} {2}  {3}" -f ($n + 1), $found[$n].Label, $where, $state)
}

if ($mode -eq "--list") { exit 0 }

$chosen = @()
if ($mode -eq "--all") {
  foreach ($target in $found) {
    foreach ($rel in $target.Dests) {
      $path = $rel -replace '/', '\'
      Install-One $path
      $chosen += $path
    }
  }
  Offer-Recommended $chosen
  exit 0
}
if ($mode -eq "--update") {
  foreach ($target in $found) {
    foreach ($rel in $target.Dests) {
      $path = $rel -replace '/', '\'
      $dest = Join-Path $env:USERPROFILE $path
      $marker = Join-Path $dest ".engineering-skills-version"
      $current = if (Test-Path $marker) { (Get-Content $marker -Raw).Trim() } else { "" }
      if ($current -eq $version) {
        Write-Output "Giữ $($target.Label) $rel ở $version"
      } elseif ($current -or (Test-Path (Join-Path $dest "c-flow")) -or (Test-Path (Join-Path $dest "flow")) -or (Test-Path (Join-Path $dest "processing-the-flow"))) {
        Install-One $path
      }
    }
  }
  $rels = @()
  foreach ($target in $found) { foreach ($rel in $target.Dests) { $rels += ($rel -replace '/', '\') } }
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
  foreach ($target in $found) { foreach ($rel in $target.Dests) { $chosen += ($rel -replace '/', '\') } }
} else {
  foreach ($token in ($answer -split ",")) {
    $token = $token.Trim()
    $index = 0
    if (-not [int]::TryParse($token, [ref]$index) -or $index -lt 1 -or $index -gt $found.Count) {
      Write-Error "Số không hợp lệ: $token"
    }
    foreach ($rel in $found[$index - 1].Dests) { $chosen += ($rel -replace '/', '\') }
  }
}
foreach ($rel in $chosen) { Install-One $rel }
Offer-Recommended $chosen
