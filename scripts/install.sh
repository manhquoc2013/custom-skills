#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
version="$(tr -d '[:space:]' < "$root/VERSION")"
linker="$root/scripts/link-skills.sh"

ids=(cursor claude antigravity codex agents)
labels=("Cursor" "Claude Code" "Antigravity" "Codex" "Agents")
rels=(".cursor/skills" ".claude/skills" ".gemini/antigravity/skills" ".codex/skills" ".agents/skills")

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
  for idx in "$@"; do
    install_one "${rels[$idx]}"
  done
}

choose_from_input() {
  local raw="$1"
  local -a picks=()
  local token n
  if [[ -z "$raw" || "$raw" == "all" ]]; then
    apply_indexes "${found[@]}"
    return
  fi
  IFS=',' read -r -a tokens <<< "${raw// /}"
  for token in "${tokens[@]}"; do
    if [[ ! "$token" =~ ^[0-9]+$ ]] || (( token < 1 || token > ${#found[@]} )); then
      echo "Số không hợp lệ: $token" >&2
      exit 1
    fi
    picks+=("${found[$((token - 1))]}")
  done
  apply_indexes "${picks[@]}"
}

mode="${1:-}"
case "$mode" in
  --list)
    list_found
    ;;
  --all)
    list_found
    apply_indexes "${found[@]}"
    ;;
  --update)
    list_found
    for i in "${found[@]}"; do
      dest="$HOME/${rels[$i]}"
      current="$(installed_version "$dest")"
      if [[ -n "$current" && "$current" != "$version" ]] || [[ -z "$current" && -e "$dest/processing-the-flow" ]]; then
        install_one "${rels[$i]}"
      elif [[ "$current" == "$version" ]]; then
        echo "Giữ ${labels[$i]} ở $version"
      fi
    done
    ;;
  --only)
    shift
    [[ $# -gt 0 ]] || { echo "usage: install.sh --only cursor claude" >&2; exit 1; }
    for name in "$@"; do
      ok=0
      for i in "${!ids[@]}"; do
        if [[ "${ids[$i]}" == "$name" ]]; then
          present "$name" || { echo "Không thấy $name trên máy này." >&2; exit 1; }
          install_one "${rels[$i]}"
          ok=1
        fi
      done
      [[ $ok -eq 1 ]] || { echo "Không có IDE tên $name" >&2; exit 1; }
    done
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
    ;;
  *)
    echo "usage: scripts/install.sh [--list | --all | --update | --only cursor claude ...]" >&2
    exit 1
    ;;
esac
