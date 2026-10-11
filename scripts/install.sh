#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
version="$(tr -d '[:space:]' < "$root/VERSION")"
linker="$root/scripts/link-skills.sh"
manifest="$root/recommended-skills.tsv"
cache_root="${HOME}/.cache/engineering-skills"

ids=(cursor claude antigravity codex agents)
labels=("Cursor" "Claude Code" "Antigravity" "Codex" "Agents")
rels=(".cursor/skills" ".claude/skills" ".gemini/antigravity/skills" ".codex/skills" ".agents/skills")

mode=""
with_recommended=0
no_recommended=0
only_names=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list|--all|--update) mode="$1" ;;
    --with-recommended) with_recommended=1 ;;
    --no-recommended) no_recommended=1 ;;
    --only)
      mode="--only"
      shift
      only_names=("$@")
      break
      ;;
    *)
      echo "usage: scripts/install.sh [--list | --all | --update | --only cursor claude ...] [--with-recommended | --no-recommended]" >&2
      exit 1
      ;;
  esac
  shift
done

present() {
  case "$1" in
    cursor)
      [[ -d "$HOME/.cursor" || -d "/Applications/Cursor.app" ]] || command -v cursor >/dev/null 2>&1
      ;;
    claude)
      [[ -d "$HOME/.claude" ]] || command -v claude >/dev/null 2>&1
      ;;
    antigravity)
      [[ -d "$HOME/.gemini/antigravity" || -d "$HOME/.antigravity" ]] || command -v agy >/dev/null 2>&1
      ;;
    codex)
      [[ -d "$HOME/.codex" ]] || command -v codex >/dev/null 2>&1
      ;;
    agents)
      [[ -d "$HOME/.agents" ]]
      ;;
    *)
      return 1
      ;;
  esac
}

installed_version() {
  local marker="$1/.engineering-skills-version"
  if [[ -f "$marker" ]]; then
    tr -d '[:space:]' < "$marker"
  fi
}

status_of() {
  local dest="$HOME/$1"
  local current
  current="$(installed_version "$dest")"
  if [[ -z "$current" ]]; then
    if [[ -L "$dest/processing-the-flow" || -d "$dest/processing-the-flow" ]]; then
      echo "đã gắn, chưa ghi phiên bản"
    else
      echo "chưa cài"
    fi
  elif [[ "$current" == "$version" ]]; then
    echo "đã cài $current"
  else
    echo "đã cài $current, repo là $version"
  fi
}

install_one() {
  local dest="$HOME/$1"
  "$linker" "$dest"
  printf '%s\n' "$version" > "$dest/.engineering-skills-version"
}

skill_present() {
  local name="$1" rel hit
  local IFS=$' \t\n'
  for rel in "${rels[@]}"; do
    [[ -f "$HOME/$rel/$name/SKILL.md" ]] && return 0
  done
  if [[ -d "$HOME/.cursor/plugins" ]]; then
    hit="$(find "$HOME/.cursor/plugins" -path "*/${name}/SKILL.md" -print 2>/dev/null | head -n 1 || true)"
    [[ -n "$hit" ]] && return 0
  fi
  return 1
}

bundle_missing() {
  local paths="$1" rel name
  local IFS=','
  local -a path_list missing=()
  read -r -a path_list <<< "$paths"
  for rel in "${path_list[@]}"; do
    name="${rel##*/}"
    skill_present "$name" || missing+=("$name")
  done
  [[ ${#missing[@]} -gt 0 ]] || return 1
  printf '%s\n' "${missing[@]}"
}

print_recommended() {
  local id title repo branch paths any=0
  while IFS='|' read -r id title repo branch paths; do
    [[ -z "${id:-}" || "$id" == \#* ]] && continue
    if bundle_missing "$paths" >/dev/null; then
      printf '  - %s\n' "$title"
      any=1
    fi
  done < "$manifest"
  [[ "$any" -eq 1 ]]
}

sync_bundle() {
  local id="$1" repo="$2" branch="$3"
  local cache="$cache_root/$id"
  mkdir -p "$cache_root"
  if [[ ! -d "$cache/.git" ]]; then
    git clone --depth 1 --branch "$branch" "$repo" "$cache"
  else
    git -C "$cache" fetch --depth 1 origin "$branch"
    git -C "$cache" reset --hard FETCH_HEAD
  fi
}

link_bundle_into() {
  local cache="$1" paths="$2"
  shift 2
  local rel name src dest target
  local IFS=','
  read -r -a path_list <<< "$paths"
  for rel in "${path_list[@]}"; do
    name="${rel##*/}"
    if skill_present "$name"; then
      echo "Đã có $name, không cài lại."
      continue
    fi
    src="$cache/$rel"
    if [[ ! -d "$src" ]]; then
      echo "Thiếu $src" >&2
      continue
    fi
    for dest in "$@"; do
      target="$HOME/$dest/$name"
      if [[ -e "$target" && ! -L "$target" ]]; then
        echo "Giữ $target vì thư mục này không phải symlink."
        continue
      fi
      ln -sfn "$src" "$target"
      echo "linked $name into $HOME/$dest"
    done
  done
}

install_recommended() {
  local id title repo branch paths
  command -v git >/dev/null 2>&1 || { echo "Cần git để cài skill bổ sung." >&2; return 1; }
  while IFS='|' read -r id title repo branch paths; do
    [[ -z "${id:-}" || "$id" == \#* ]] && continue
    if ! bundle_missing "$paths" >/dev/null; then
      echo "Đã có $title, không cài lại."
      continue
    fi
    sync_bundle "$id" "$repo" "$branch"
    link_bundle_into "$cache_root/$id" "$paths" "$@"
  done < "$manifest"
  local dest
  for dest in "$@"; do
    awk -F'|' '$1 !~ /^#/ && $1 != "" { print $1 }' "$manifest" > "$HOME/$dest/.engineering-skills-extras"
  done
}

offer_recommended() {
  [[ $# -gt 0 ]] || return 0
  if [[ "$no_recommended" -eq 1 ]]; then
    return 0
  fi
  if [[ "$with_recommended" -eq 1 ]]; then
    install_recommended "$@"
    return 0
  fi
  if ! print_recommended >/dev/null; then
    echo "Skill bổ sung đã có trên máy, không cài lại."
    return 0
  fi
  if [[ ! -t 0 ]]; then
    echo "Thêm --with-recommended để cài skill bổ sung vào các IDE vừa chọn."
    return 0
  fi
  echo "Nên cài thêm. Pack này đọc chúng khi có trên máy:"
  print_recommended
  echo "Tự động cài vào các IDE vừa chọn? Enter = có, n = không"
  local answer
  read -r answer
  if [[ -z "$answer" || "$answer" == "y" || "$answer" == "Y" || "$answer" == "yes" || "$answer" == "có" ]]; then
    install_recommended "$@"
  else
    echo "Bỏ qua skill bổ sung."
  fi
}

refresh_accepted() {
  local -a marked=()
  local rel
  for rel in "$@"; do
    if [[ -f "$HOME/$rel/.engineering-skills-extras" ]]; then
      marked+=("$rel")
    fi
  done
  [[ ${#marked[@]} -gt 0 ]] || return 0
  install_recommended "${marked[@]}"
}

found=()
for i in "${!ids[@]}"; do
  if present "${ids[$i]}"; then
    found+=("$i")
  fi
done

list_found() {
  if [[ ${#found[@]} -eq 0 ]]; then
    echo "Không thấy Cursor, Claude Code, Antigravity, Codex, hay ~/.agents."
    return
  fi
  echo "Repo $version. IDE tìm thấy:"
  local n=1
  for i in "${found[@]}"; do
    printf '  [%s] %-14s %s  %s\n' "$n" "${labels[$i]}" "$HOME/${rels[$i]}" "$(status_of "${rels[$i]}")"
    n=$((n + 1))
  done
}

apply_indexes() {
  local idx
  selected=()
  for idx in "$@"; do
    install_one "${rels[$idx]}"
    selected+=("${rels[$idx]}")
  done
}

choose_from_input() {
  local raw="$1"
  local -a picks=()
  local token
  if [[ -z "$raw" || "$raw" == "all" ]]; then
    apply_indexes "${found[@]}"
    return
  fi
  local IFS=','
  read -r -a tokens <<< "${raw// /}"
  for token in "${tokens[@]}"; do
    if [[ ! "$token" =~ ^[0-9]+$ ]] || (( token < 1 || token > ${#found[@]} )); then
      echo "Số không hợp lệ: $token" >&2
      exit 1
    fi
    picks+=("${found[$((token - 1))]}")
  done
  apply_indexes "${picks[@]}"
}

case "$mode" in
  --list)
    list_found
    ;;
  --all)
    list_found
    [[ ${#found[@]} -gt 0 ]] || exit 1
    apply_indexes "${found[@]}"
    offer_recommended "${selected[@]}"
    ;;
  --update)
    list_found
    [[ ${#found[@]} -gt 0 ]] || exit 1
    for i in "${found[@]}"; do
      dest="${rels[$i]}"
      current="$(installed_version "$HOME/$dest")"
      if [[ -n "$current" && "$current" != "$version" ]] || [[ -z "$current" && -e "$HOME/$dest/processing-the-flow" ]]; then
        install_one "$dest"
      elif [[ "$current" == "$version" ]]; then
        echo "Giữ ${labels[$i]} ở $version"
      fi
    done
    all_rels=()
    for i in "${found[@]}"; do
      all_rels+=("${rels[$i]}")
    done
    if [[ "$with_recommended" -eq 1 ]]; then
      install_recommended "${all_rels[@]}"
    else
      refresh_accepted "${all_rels[@]}"
    fi
    ;;
  --only)
    [[ ${#only_names[@]} -gt 0 ]] || { echo "usage: install.sh --only cursor claude" >&2; exit 1; }
    selected=()
    for name in "${only_names[@]}"; do
      ok=0
      for i in "${!ids[@]}"; do
        if [[ "${ids[$i]}" == "$name" ]]; then
          present "$name" || { echo "Không thấy $name trên máy này." >&2; exit 1; }
          install_one "${rels[$i]}"
          selected+=("${rels[$i]}")
          ok=1
        fi
      done
      [[ $ok -eq 1 ]] || { echo "Không có IDE tên $name" >&2; exit 1; }
    done
    offer_recommended "${selected[@]}"
    ;;
  "")
    list_found
    [[ ${#found[@]} -gt 0 ]] || exit 1
    if [[ ! -t 0 ]]; then
      echo "Thêm --all, --update, hoặc --only cursor claude" >&2
      exit 1
    fi
    echo "Nhập số, cách nhau bằng dấu phẩy, hoặc all. Enter = tất cả:"
    read -r answer
    choose_from_input "$answer"
    offer_recommended "${selected[@]}"
    ;;
esac
