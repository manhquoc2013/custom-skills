#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
linker="$root/scripts/link-skills.sh"
manifest="$root/recommended-skills.tsv"
agents_file="$root/scripts/agents.tsv"
cache_root="${HOME}/.cache/engineering-skills"

mode=""
with_recommended=0
no_recommended=0
do_pull=0
only_names=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list|--all|--update) mode="$1" ;;
    --with-recommended) with_recommended=1 ;;
    --no-recommended) no_recommended=1 ;;
    --pull) do_pull=1 ;;
    --only)
      mode="--only"
      shift
      only_names=("$@")
      break
      ;;
    *)
      echo "usage: scripts/install.sh [--pull] [--list | --all | --update | --only cursor claude-code ...] [--with-recommended | --no-recommended]" >&2
      exit 1
      ;;
  esac
  shift
done

if [[ "$do_pull" -eq 1 ]]; then
  if [[ -d "$root/.git" ]]; then
    git -C "$root" pull --ff-only
  else
    echo "Không phải git repo, bỏ qua pull." >&2
  fi
fi

version="$(tr -d '[:space:]' < "$root/VERSION")"

ids=()
labels=()
detects=()
rels=()
while IFS='|' read -r id label detect dests; do
  [[ -z "${id:-}" || "$id" == \#* ]] && continue
  id="${id%$'\r'}"
  label="${label%$'\r'}"
  detect="${detect%$'\r'}"
  dests="${dests%$'\r'}"
  ids+=("$id")
  labels+=("$label")
  detects+=("$detect")
  rels+=("$dests")
done < <(tr -d '\r' < "$agents_file")


agent_present() {
  local spec="$1" token
  local IFS=','
  local -a tokens=()
  read -r -a tokens <<< "$spec"
  for token in "${tokens[@]}"; do
    case "$token" in
      bin:*) command -v "${token#bin:}" >/dev/null 2>&1 && return 0 ;;
      app:*) [[ -e "${token#app:}" ]] && return 0 ;;
      *) [[ -d "$HOME/$token" ]] && return 0 ;;
    esac
  done
  return 1
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
    if [[ -d "$dest/c-flow" || -L "$dest/c-flow" || -d "$dest/flow" || -L "$dest/flow" || -d "$dest/processing-the-flow" || -L "$dest/processing-the-flow" ]]; then
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
  local dest="$HOME/${1%$'\r'}"
  "$linker" "$dest"
  printf '%s\n' "$version" > "$dest/.engineering-skills-version"
}

install_agent() {
  local idx="$1" dest
  local IFS=','
  local -a dests=()
  read -r -a dests <<< "${rels[$idx]}"
  for dest in "${dests[@]}"; do
    install_one "$dest"
  done
}

agent_dests() {
  local idx="$1"
  local IFS=','
  local -a dests=()
  read -r -a dests <<< "${rels[$idx]}"
  for d in "${dests[@]}"; do
    printf '%s\n' "${d%$'\r'}"
  done
}

skill_present() {
  local name="$1" group rel hit
  local IFS=$' \t\n'
  for group in "${rels[@]}"; do
    local IFS=','
    local -a parts=()
    read -r -a parts <<< "$group"
    for rel in "${parts[@]}"; do
      [[ -f "$HOME/$rel/$name/SKILL.md" ]] && return 0
    done
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
    rel="${rel%$'\r'}"
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
    paths="${paths%$'\r'}"
    if bundle_missing "$paths" >/dev/null; then
      printf '  - %s\n' "$title"
      any=1
    fi
  done < <(tr -d '\r' < "$manifest")
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

copy_tree() {
  local src="$1" target="$2"
  if [[ -L "$target" ]]; then
    rm "$target"
  elif [[ -d "$target" ]]; then
    rm -rf "$target"
  elif [[ -e "$target" ]]; then
    echo "Giữ $target vì không phải thư mục skill."
    return 0
  fi
  mkdir -p "$target"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a "$src/" "$target/"
  else
    cp -R "$src"/. "$target"/
  fi
}

link_bundle_into() {
  local cache="$1" paths="$2"
  shift 2
  local rel name src dest target
  local IFS=','
  read -r -a path_list <<< "$paths"
  for rel in "${path_list[@]}"; do
    rel="${rel%$'\r'}"
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
      dest="${dest%$'\r'}"
      target="$HOME/$dest/$name"
      copy_tree "$src" "$target"
      echo "installed $name into $HOME/$dest"
    done
  done
}

install_recommended() {
  local id title repo branch paths
  command -v git >/dev/null 2>&1 || { echo "Cần git để cài skill bổ sung." >&2; return 1; }
  while IFS='|' read -r id title repo branch paths; do
    [[ -z "${id:-}" || "$id" == \#* ]] && continue
    paths="${paths%$'\r'}"
    if ! bundle_missing "$paths" >/dev/null; then
      echo "Đã có $title, không cài lại."
      continue
    fi
    sync_bundle "$id" "$repo" "$branch"
    link_bundle_into "$cache_root/$id" "$paths" "$@"
  done < <(tr -d '\r' < "$manifest")
  local dest
  for dest in "$@"; do
    dest="${dest%$'\r'}"
    awk -F'|' '$1 !~ /^#/ && $1 != "" { print $1 }' "$manifest" | tr -d '\r' > "$HOME/$dest/.engineering-skills-extras"
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
    local dest
    for dest in "$@"; do
      dest="${dest%$'\r'}"
      awk -F'|' '$1 !~ /^#/ && $1 != "" { print $1 }' "$manifest" | tr -d '\r' > "$HOME/$dest/.engineering-skills-extras"
    done
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
    rel="${rel%$'\r'}"
    if [[ -f "$HOME/$rel/.engineering-skills-extras" ]]; then
      marked+=("$rel")
    fi
  done
  [[ ${#marked[@]} -gt 0 ]] || return 0
  install_recommended "${marked[@]}"
}

found=()
for i in "${!ids[@]}"; do
  if agent_present "${detects[$i]}"; then
    found+=("$i")
  fi
done

list_found() {
  if [[ ${#found[@]} -eq 0 ]]; then
    echo "Không thấy IDE hoặc CLI nào trong scripts/agents.tsv."
    return
  fi
  echo "Repo $version. IDE và CLI tìm thấy:"
  local n=1 i dest
  for i in "${found[@]}"; do
    dest="$(agent_dests "$i" | paste -sd ',' -)"
    printf '  [%s] %-16s %s  %s\n' "$n" "${labels[$i]}" "$dest" "$(status_of "$(agent_dests "$i" | head -n 1)")"
    n=$((n + 1))
  done
}

apply_indexes() {
  local idx dest
  selected=()
  for idx in "$@"; do
    install_agent "$idx"
    while IFS= read -r dest; do
      selected+=("$dest")
    done < <(agent_dests "$idx")
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
      while IFS= read -r dest; do
        current="$(installed_version "$HOME/$dest")"
        if [[ -n "$current" && "$current" != "$version" ]] || [[ -z "$current" && ( -e "$HOME/$dest/c-flow" || -e "$HOME/$dest/flow" || -e "$HOME/$dest/processing-the-flow" ) ]]; then
          install_one "$dest"
        elif [[ "$current" == "$version" ]]; then
          echo "Giữ ${labels[$i]} $dest ở $version"
        fi
      done < <(agent_dests "$i")
    done
    all_rels=()
    for i in "${found[@]}"; do
      while IFS= read -r dest; do
        all_rels+=("$dest")
      done < <(agent_dests "$i")
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
          agent_present "${detects[$i]}" || { echo "Không thấy $name trên máy này." >&2; exit 1; }
          install_agent "$i"
          while IFS= read -r dest; do
            selected+=("$dest")
          done < <(agent_dests "$i")
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
