# Engineering skills

Bộ skill cho Cursor. Agent hỏi đủ context, lập danh sách yêu cầu bạn xác nhận, rồi tự làm đến khi mỗi yêu cầu có kết quả lệnh khớp kết quả mong đợi.

Skill nằm ở thư mục gốc của repo này. Mỗi skill là một thư mục chứa `SKILL.md`.

## Cài đặt

Chạy trong thư mục repo này. Script tìm IDE đang có trên máy, hiện phiên bản đã gắn, rồi hỏi cài vào IDE nào. Symlink trỏ về repo này, nên sửa skill trong repo là bản mọi IDE đang đọc. Mở phiên chat mới rồi gõ `/processing-the-flow`.

```bash
chmod +x scripts/install.sh
./scripts/install.sh --list
./scripts/install.sh
```

Enter cài mọi IDE tìm thấy. Hoặc nhập số, ví dụ `1,3`.

```bash
./scripts/install.sh --all
./scripts/install.sh --update
./scripts/install.sh --only cursor claude
```

`--update` gắn lại chỗ nào đang cài phiên bản khác với file `VERSION`. Phiên bản mới là đổi số trong `VERSION`, rồi chạy `--update`.

| Công cụ | Thư mục global | Thư mục trong một project |
|---------|----------------|---------------------------|
| Cursor | `~/.cursor/skills` | `.cursor/skills` |
| Claude Code | `~/.claude/skills` | `.claude/skills` |
| Antigravity | `~/.gemini/antigravity/skills` | cùng thư mục global ở trên |
| Codex | `~/.codex/skills` | `.agents/skills` |
| Agent đọc `~/.agents/skills` | `~/.agents/skills` | `.agents/skills` |

```bash
./scripts/link-skills.sh ~/.claude/skills
./scripts/link-skills.sh ~/.gemini/antigravity/skills
./scripts/link-skills.sh ~/.codex/skills
./scripts/link-skills.sh ~/.agents/skills
```

Một project thì đổi đích, ví dụ `./scripts/link-skills.sh .claude/skills`.

### Windows

`%USERPROFILE%` là `C:\Users\<tên>`. Trong PowerShell, chạy ở thư mục repo này. Junction không cần quyền Administrator. Cùng cách chọn IDE như trên macOS.

```powershell
./scripts/install.ps1 --list
./scripts/install.ps1
./scripts/install.ps1 --update
```

| Công cụ | Thư mục global |
|---------|----------------|
| Cursor | `%USERPROFILE%\.cursor\skills` |
| Claude Code | `%USERPROFILE%\.claude\skills` |
| Antigravity | `%USERPROFILE%\.gemini\antigravity\skills` |
| Codex | `%USERPROFILE%\.codex\skills` |
| Agent đọc `.agents\skills` | `%USERPROFILE%\.agents\skills` |

Git Bash trên Windows chạy `./scripts/install.sh` như macOS. Muốn gắn một thư mục tay thì `./scripts/link-skills.sh ~/.cursor/skills`.

### Agent tùy chỉnh

Agent không tự quét thư mục skill thì thêm một dòng vào file hướng dẫn của nó (`AGENTS.md`, system prompt, hoặc file rules):

```markdown
Khi người dùng muốn dựng dự án, thêm chức năng, hoặc tự xử lý luồng, đọc và làm theo `processing-the-flow/SKILL.md` trong `/Users/tranquoc/Developer/mcp/skills`. Các skill cùng thư mục được file đó nêu tên thì đọc tiếp.
```

Đổi đường dẫn nếu repo nằm chỗ khác. Định dạng thư mục vẫn là `<tên>/SKILL.md` với `name` và `description` ở đầu file.

### Gỡ

Xóa symlink trong đúng thư mục đã cài. Không xóa thư mục trong repo này.

```bash
rm ~/.cursor/skills/{installing-skills,coordinating-agents,routing-engineering-work,scaffolding-project,specifying-a-feature,implementing-from-spec,prompting-the-loop,running-the-loop,processing-the-flow,designing-interface,.engineering-skills-version}
```

Đổi `~/.cursor/skills` thành thư mục của Claude, Antigravity, hoặc Codex nếu gỡ ở đó.

## Cách gọi

Hai cách:

- Gõ `/tên-skill` khi muốn ép đúng nhánh.
- Nói việc cần làm. Agent tự mở skill có mô tả khớp. `/routing-engineering-work` là cửa vào khi câu nói chưa chỉ rõ nhánh.

Chat đang mở từ trước lúc cài không thấy skill mới. Mở chat khác.

## Làm một việc cho xong

Gọi `/processing-the-flow`, rồi dán yêu cầu.

Một lệnh là đủ. Agent tự tra fact trong repo. Việc cần bạn quyết thì nó hỏi theo vòng: cả nhóm câu đang hỏi được, mỗi câu có một đáp án đề xuất, `yes` là nhận đáp án đó. Câu phụ thuộc câu chưa trả lời thì để vòng sau. Thuật ngữ vừa chốt được ghi vào `GLOSSARY.md`. ADR chỉ khi quyết định khó đảo, người sau sẽ ngạc nhiên, và có đánh đổi thật.

Nó hỏi đến khi không còn giả định im lặng. Rồi đưa danh sách và chờ bạn nói đã đủ và đã hiểu giống nhau:

```text
REQ-1 | admin xuất CSV | file có mã đơn và tổng tiền
REQ-2 | người không phải admin bấm xuất | bị từ chối, không có file
```

Bạn thêm hành vi thì nó đánh số lại và hỏi lần nữa. Bạn xác nhận đủ thì nó ghi `CONTEXT.md` và tự đi tiếp, không hỏi "làm tiếp không?".

| Cổng | Việc | Sang cổng sau khi |
|------|------|-------------------|
| Plan | Đọc code, ghi `RESEARCH.md` với `GO`, `CONDITIONAL`, hoặc `NO-GO`, rồi `PLAN.md` | Mỗi `REQ-` có đúng một task, task có lệnh kiểm, hai task cùng đợt không sửa một file |
| Execute | Phiên chính ghi `roster.md` rồi giao implementer. Mỗi implementer một `REQ-` và một danh sách file riêng. Xong thì giao verifier (đọc lại, không sửa code) và một watcher cho cả wave | Wave `PASS` khi watcher không thấy trùng file và mọi verifier khớp `REQ-`. Rồi tự giao wave kế |
| Verify | `VERIFICATION.md` | Mọi `REQ-` có output khớp kết quả mong đợi. Test xanh mà thiếu một `REQ-` vẫn là `REJECT` |
| Ship | Link PR, hoặc câu commit trong `IMPLEMENT.md` | Verify là `PASS` |

Ba lần `REJECT` trên cùng một task thì dừng, `Stop: attempt-cap`. Research `NO-GO`, đụng auth, payment, secret, hoặc repo bẩn bởi việc khác thì dừng, `Stop: needs-human`.

Sửa typo, import, hoặc đổi tên chỉ đi tắt khi bạn nói rõ đó là sửa một dòng và nêu đúng chữ cần đổi.

## Làm tiếp ở chat sau

Gọi lại `/processing-the-flow`. Agent đọc `work/{slug}/FLOW.md` và làm từ phase đang dở. File trên đĩa là nguồn đúng, không phải trí nhớ chat cũ.

```text
work/{slug}/
  FLOW.md
  CONTEXT.md
  research/RESEARCH.md
  plan/PLAN.md
  roster.md
  agents/impl-T1.md
  checks/T1.md
  waves/1.md
  waves/1-watch.md
  implement/IMPLEMENT.md
  VERIFICATION.md
```

## Các skill khác

| Việc | Lệnh |
|------|------|
| Repo trống, dựng harness | `/scaffolding-project` |
| Chỉ viết spec, chưa code | `/specifying-a-feature` |
| Đã có plan, làm một task | `/implementing-from-spec` |
| Viết prompt cho agent | `/prompting-the-loop` |
| Vòng bảo trì theo lịch (triage, CI, PR). Tuần đầu chỉ báo cáo | `/running-the-loop` |
| Giao diện | `/designing-interface` |
| Chưa rõ nhánh | `/routing-engineering-work` |
| Giao subagent và theo dõi họ | `/coordinating-agents` |
| Cài hoặc cập nhật skill vào IDE trên máy | `/installing-skills` |

`/running-the-loop` không thay `/processing-the-flow`. Vòng bảo trì liệt kê việc. Vòng feature hoàn thành một yêu cầu.

## Nguồn

Quy trình được rút từ các repo công khai, không sao chép mã nguồn:

- [claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice)
- [loop-engineering](https://github.com/cobusgreyling/loop-engineering)
- [mattpocock/skills](https://github.com/mattpocock/skills)
- [ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)
- [get-shit-done](https://github.com/gsd-build/get-shit-done) đã lưu trữ; bản đang chạy là [GSD Core](https://github.com/open-gsd/gsd-core)
- [superpowers](https://github.com/obra/superpowers)

Database tìm style của ui-ux-pro-max không nằm trong repo này. Khi skill đó được cài riêng, `designing-interface` sẽ gọi script search của nó.

## Superpowers

Plugin Superpowers trong Cursor là phần cách làm bên trong `/processing-the-flow`. Không cần cài app khác. Skill này tự đọc và làm theo skill Superpowers ở từng cổng:

| Cổng | Skill Superpowers |
|------|-------------------|
| Sau khi bạn chốt danh sách `REQ-` | `brainstorming` |
| Plan | `writing-plans` |
| Trước khi sửa code | `using-git-worktrees` |
| Mỗi wave | `dispatching-parallel-agents`: giao hết task trong wave cùng một lượt, rồi phiên chính tổng hợp |
| Trong từng subagent | `test-driven-development` |
| Sau khi implementer trả về | Một verifier cho mỗi task, cộng một watcher cho wave. Verifier không sửa code. Watcher chỉ tìm chỗ đụng file |
| Test đỏ hoặc bug | `systematic-debugging` |
| Trước khi báo đạt | `verification-before-completion` |
| Xong việc | `finishing-a-development-branch` |

File trạng thái vẫn nằm trong `work/{slug}/`. Superpowers không thay câu hỏi context và không được báo xong khi còn `REQ-` chưa khớp.

`coordinating-agents` bảo agent đọc skill Superpowers khi tình huống khớp, kể cả skill không nằm trong bảng cổng của `/processing-the-flow`. Đọc và làm theo. Chỉ nêu tên skill là chưa gọi.

## So với skill của Matt Pocock

[mattpocock/skills](https://github.com/mattpocock/skills) mạnh ở từ vựng miền, ADR, test tại seam công khai, và vòng chẩn đoán bug phải đỏ đúng triệu chứng trước khi đoán nguyên nhân. Pack này giữ điều phối subagent, roster, và đối chiếu từng `REQ-`. Những chỗ kia đã được đưa vào `specifying-a-feature`, `implementing-from-spec`, và đường bug của `processing-the-flow`. Ý tưởng còn sương, chưa ghi được kết quả mong đợi, thì dừng để chốt một quyết định, không bịa `REQ-`.
