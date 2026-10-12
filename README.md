# Engineering skills

Bộ skill cho Cursor. Agent hỏi đủ context, lập danh sách yêu cầu bạn xác nhận, rồi tự làm đến khi mỗi yêu cầu có kết quả lệnh khớp kết quả mong đợi.

Skill nằm ở thư mục gốc của repo này. Mỗi skill là một thư mục chứa `SKILL.md`. Hình dạng các file mà skill ghi ra nằm riêng trong thư mục `templates/` của skill, mỗi tài liệu một file, chỉ đọc đúng file sắp ghi nên không nằm trong ngữ cảnh mặc định khi load skill.

## Cài đặt

### Từ GitHub

Repo: [manhquoc2013/custom-skills](https://github.com/manhquoc2013/custom-skills).

Một lệnh. Nó tải bản nén vào thư mục tạm, chép skill vào IDE, rồi xóa thư mục tạm:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/manhquoc2013/custom-skills/main/scripts/bootstrap.sh)"
```

Windows PowerShell:

```powershell
& ([scriptblock]::Create((Invoke-RestMethod https://raw.githubusercontent.com/manhquoc2013/custom-skills/main/scripts/bootstrap.ps1)))
```

Cùng lệnh đó cài lại khi `VERSION` trên GitHub đổi. Thêm cờ bằng cách lưu script ra file rồi chạy, ví dụ `bash /tmp/bootstrap.sh --all`.

### Trong thư mục repo

Mỗi skill được chép thành một thư mục thật với `SKILL.md` là file thường (kèm thư mục `templates/` nếu có). Sửa file trong repo chưa đổi bản đã cài. `--update` chép lại khi file `VERSION` đổi. Mở chat mới sau khi cài.

Enter cài mọi IDE tìm thấy. Hoặc nhập số, ví dụ `1,3`.

```bash
./scripts/install.sh --all
./scripts/install.sh --update
./scripts/install.sh --only cursor claude-code
```

`--update` chép lại skill ở IDE nào đang cài phiên bản khác với file `VERSION`.

Sau khi chép pack, script liệt kê skill bổ sung trong `recommended-skills.tsv` (Superpowers, `diagnosing-bugs`, `ui-ux-pro-max`) mà máy chưa có, rồi hỏi có chép vào đúng các IDE vừa chọn không. Enter là có. `n` là bỏ qua. Skill đã có `SKILL.md` trong thư mục skill hoặc plugin Cursor thì giữ nguyên.

```bash
./scripts/install.sh --all --with-recommended
./scripts/install.sh --all --no-recommended
```

| Công cụ | Thư mục global |
|---------|----------------|
| Cursor | `~/.cursor/skills` |
| Claude Code | `~/.claude/skills` |
| Codex | `~/.agents/skills` và `~/.codex/skills` |
| Gemini CLI | `~/.gemini/skills` và `~/.agents/skills` |
| Antigravity IDE | `~/.gemini/config/skills` và `~/.gemini/antigravity/skills` |
| Antigravity CLI | `~/.gemini/antigravity-cli/skills` và `~/.gemini/config/skills` |

Danh sách đủ IDE và CLI, cùng cách nhận ra chúng trên máy, nằm trong `scripts/agents.tsv`. Script chỉ chép vào công cụ nào thực sự có trên máy. Một project thì `./scripts/link-skills.sh .agents/skills` hoặc `.claude/skills`.

### Windows

`%USERPROFILE%` là `C:\Users\<tên>`. Trong PowerShell, chạy ở thư mục repo này. Cùng cách chọn IDE như trên macOS. File `SKILL.md` là file thường, không phải junction.

```powershell
./scripts/install.ps1 --list
./scripts/install.ps1
./scripts/install.ps1 --update
```

Windows dùng cùng `scripts/agents.tsv`. Đường dẫn nằm dưới `%USERPROFILE%`, ví dụ `%USERPROFILE%\.gemini\config\skills` cho Antigravity và `%USERPROFILE%\.claude\skills` cho Claude Code.

Git Bash trên Windows chạy `./scripts/install.sh` như macOS. Muốn chép vào một thư mục tay thì `./scripts/link-skills.sh ~/.cursor/skills`.

### Agent tùy chỉnh

Agent không tự quét thư mục skill thì thêm một dòng vào file hướng dẫn của nó (`AGENTS.md`, system prompt, hoặc file rules):

```markdown
Khi người dùng muốn dựng dự án, thêm chức năng, hoặc tự xử lý luồng, đọc và làm theo `c-flow/SKILL.md` trong bản clone của https://github.com/manhquoc2013/custom-skills. Các skill cùng thư mục được file đó nêu tên thì đọc tiếp.
```

Đổi đường dẫn nếu repo nằm chỗ khác. Định dạng thư mục vẫn là `<tên>/SKILL.md` với `name` và `description` ở đầu file.

### Gỡ

Xóa đúng thư mục skill đã cài. Không xóa thư mục trong repo này.

```bash
rm -rf ~/.cursor/skills/{c-install,c-agents,c-route,c-scaffold,c-spec,c-implement,c-prompt,c-loop,c-process,c-flow,c-design,c-review,c-refactor,c-lint,c-perf,c-debug} ~/.cursor/skills/.engineering-skills-version
```

Đổi `~/.cursor/skills` thành thư mục của Claude, Antigravity, hoặc Codex nếu gỡ ở đó.

## Cách gọi

Hai cách:

- Gõ `/tên-skill` khi muốn ép đúng nhánh.
- Nói việc cần làm. Agent tự mở skill có mô tả khớp. Câu chưa chỉ nhánh thì `/c-route` chọn một skill rồi làm theo skill đó.

Một yêu cầu đi một nhánh. Nhánh sau chỉ bắt đầu khi nhánh trước xong. Chat đang mở từ trước lúc cài không thấy skill mới. Mở chat khác.

## Khi nào dùng skill nào

| Bạn đang muốn | Gõ | Xong khi |
|---------------|-----|----------|
| Bắt đầu một chức năng, một bug, hoặc một ý. Lượt này chỉ tra code và hỏi, không sửa code sản phẩm | `/c-process` | Đã hỏi những gì còn chưa chốt, rồi đọc `/c-flow` để làm tiếp |
| Làm hết một chức năng đến PR, hoặc làm tiếp từ `FLOW.md` đang dở | `/c-flow` | `VERIFICATION.md` là `PASS` và đã có PR hoặc câu commit |
| Repo chưa có lệnh test, file harness, chỗ ghi việc | `/c-scaffold` | Session mới build và test được mà không hỏi lại |
| Chỉ viết spec và plan, chưa đụng code | `/c-spec` | Có `GO` hoặc `NO-GO`. Plan chỉ xuất hiện sau `GO` |
| Plan đã có và đã `GO`, làm đúng một task | `/c-implement` | Lệnh kiểm của task đó qua một lượt verifier riêng |
| Viết prompt, agent brief, hoặc lệnh slash cho session khác chạy | `/c-prompt` | File prompt đủ mục, mức mặc định là báo cáo |
| Nghĩ ra một vòng sẽ chạy lặp lại (triage, CI, PR, changelog) | `/c-prompt`, rồi `/c-loop` | Prompt có trước. Vòng tuần đầu chỉ ghi báo cáo |
| Vòng đã có, chạy một lượt: triage sáng, CI đỏ, PR kẹt, dependency, changelog, dọn sau merge | `/c-loop` | `STATE.md` đúng khuôn và code sản phẩm không bị sửa ở mức báo cáo |
| Đổi nhìn, bấm, chữ, màu, chuyển động, hoặc accessibility của một màn | `/c-design` | `MASTER.md` có, và luồng đã bấm thử kể cả trống và lỗi |
| Soi diff, PR, hoặc nhánh, không sửa trong lượt đó | `/c-review` | `REVIEW.md` có hai mục Spec và Standards |
| Cấu trúc lại, hành vi giữ nguyên | `/c-refactor` | Cùng lệnh test, output sau khớp output trước |
| Chạy lint hoặc typecheck của repo, sửa đúng dòng công cụ báo | `/c-lint` | Lệnh đó sạch theo luật fail của chính nó |
| Làm một đường chạy nhanh hơn | `/c-perf` | Có số đo trước và sau trên cùng một lệnh |
| Tìm lỗi. `--find` chỉ ra nguyên nhân. `--fix` sửa sau khi nguyên nhân đã được quote | `/c-debug` | `--find` có `CAUSE.md` và không sửa code sản phẩm. `--fix` có lệnh đỏ gốc chạy lại sau sửa |
| Chưa rõ câu nói thuộc nhánh nào | `/c-route` | Đã chọn một hàng ở trên và làm theo skill đó |
| Cài pack này vào IDE trên máy, hoặc kéo bản `VERSION` mới | `/c-install` | IDE bạn chọn có bản copy của skill |

`/c-agents` là luật nội bộ. Skill đang làm việc tự đọc nó khi chia subagent. Bạn không cần gõ, trừ khi muốn xem ai đang giữ file nào.

Màn hình nằm trong một chức năng thì vẫn gọi `/c-flow`. Skill đó gọi `/c-design` lúc chốt thiết kế và lúc kiểm màn hình. Skill giao diện không lấy mất các cổng plan, code, verify.

`/c-flow` chỉ gọi `/c-debug` với `--fix` khi bug khó: lệnh đỏ không chỉ đúng dòng cần sửa, và đó không phải test mới đang chờ code. Sai cú pháp, lint, type, import thiếu, và test đỏ vì chưa viết behavior thì sửa tại chỗ. `--find` chỉ khi bạn gọi `/c-debug` để dừng ở nguyên nhân. Vòng bảo trì không sửa bug feature đó.

Sửa một chữ, một import, hoặc một tên chỉ đi tắt trong `/c-flow` khi bạn nói đó là sửa một dòng và nêu đúng chữ cần đổi.

Ý còn sương, chưa nói được kết quả mong đợi, thì `/c-spec` ghi bản đồ và dừng sau một quyết định. Chưa có plan thì không gọi `/c-implement`.

## Làm một việc cho xong

Gõ `/c-process` rồi viết yêu cầu ngay trong cùng một tin nhắn. Lệnh đó tra code và hỏi. Nó không sửa code sản phẩm. Hết phần hỏi, agent đọc `/c-flow` và tự đi tiếp: plan, sửa code, verify, ship.

`/c-flow` là cả đường đó. Gõ `/c-flow` khi muốn vào thẳng, hoặc khi chat sau cần làm tiếp từ `work/{slug}/FLOW.md`. Không gõ `/c-process` để làm tiếp một việc đã có file trạng thái.

Một lệnh là đủ. Agent tự tra fact trong repo. Việc cần bạn quyết thì nó đưa hết câu đang hỏi được vào một phiếu. Mỗi đề xuất là một lựa chọn A, B, C, D… Đề xuất đầu ghi `(Recommended)`. Lựa chọn cuối luôn là `Người dùng quyết định`. Bạn trả lời hết rồi bấm gửi một lần. Câu phụ thuộc câu trong phiếu đó thì hỏi sau khi đã gửi. Thuật ngữ vừa chốt được ghi vào `GLOSSARY.md`. ADR chỉ khi quyết định khó đảo, người sau sẽ ngạc nhiên, và có đánh đổi thật.

Nó hỏi đến khi không còn giả định im lặng. Rồi đưa danh sách và chờ bạn nói đã đủ và đã hiểu giống nhau:

```text
REQ-1 | admin xuất CSV | file có mã đơn và tổng tiền
REQ-2 | người không phải admin bấm xuất | bị từ chối, không có file
```

Bạn thêm hành vi thì nó đánh số lại và hỏi lần nữa. Bạn xác nhận đủ thì nó đưa 2–3 hướng, một hướng đề xuất, và chờ bạn chọn. Rồi ghi `CONTEXT.md` và tự đi tiếp, không hỏi "làm tiếp không?".

| Cổng | Việc | Sang cổng sau khi |
|------|------|-------------------|
| Plan | Đọc code, ghi `RESEARCH.md` với `GO`, `CONDITIONAL`, hoặc `NO-GO`, rồi `PLAN.md` | Mỗi `REQ-` có đúng một task, task có lệnh kiểm, hai task cùng đợt không sửa một file |
| Execute | Phiên chính ghi `roster.md` rồi giao implementer. Mỗi prompt một `REQ-`, file riêng, lệnh Kept, và chữ ký produces. Xong thì giao verifier và một watcher cho cả wave | Wave `PASS` khi không trùng file, output khớp `REQ-`, và output Kept khớp kết quả trước đó |
| Verify | `VERIFICATION.md` | Mọi `REQ-` khớp kết quả mong đợi, mọi hành vi cũ mà diff chạm tới vẫn khớp kết quả trước đó. Test xanh không thay cho hàng đó. Hành vi không có trong spec là `REJECT` |
| Ship | Link PR, hoặc câu commit trong `IMPLEMENT.md` | Verify là `PASS` |

Ba lần `REJECT` trên cùng một task thì dừng, `Stop: attempt-cap`. Research `NO-GO`, đụng auth, payment, secret, hoặc repo bẩn bởi việc khác thì dừng, `Stop: needs-human`.

Sửa typo, import, hoặc đổi tên chỉ đi tắt khi bạn nói rõ đó là sửa một dòng và nêu đúng chữ cần đổi.

## Làm tiếp ở chat sau

Gọi lại `/c-flow`, không gọi `/c-process`. Agent đọc `work/{slug}/FLOW.md` và làm từ phase đang dở. File trên đĩa là nguồn đúng, không phải trí nhớ chat cũ.

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

## Nguồn

Quy trình được rút từ các repo công khai, không sao chép mã nguồn:

- [claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice)
- [loop-engineering](https://github.com/cobusgreyling/loop-engineering)
- [mattpocock/skills](https://github.com/mattpocock/skills)
- [ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)
- [get-shit-done](https://github.com/gsd-build/get-shit-done) đã lưu trữ; bản đang chạy là [GSD Core](https://github.com/open-gsd/gsd-core)
- [superpowers](https://github.com/obra/superpowers)

Database tìm style của ui-ux-pro-max không nằm trong repo này. Khi skill đó được cài riêng, `c-design` sẽ gọi script search của nó.

## Superpowers

Luật cốt lõi nằm trong `c-agents`. Pack vẫn chạy khi Superpowers chưa cài. Khi plugin có trên máy, agent đọc thêm skill đó ở cổng tương ứng:

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

`c-agents` bảo agent đọc skill Superpowers khi tình huống khớp, kể cả skill không nằm trong bảng cổng của `/c-flow`. Đọc và làm theo. Chỉ nêu tên skill là chưa gọi.

## So với skill của Matt Pocock

[mattpocock/skills](https://github.com/mattpocock/skills) mạnh ở từ vựng miền, ADR, test tại seam công khai, hai trục Spec và Standards, và vòng chẩn đoán bug phải đỏ đúng triệu chứng trước khi đoán nguyên nhân. Review trong pack này giữ hai trục đó và không gộp một bảng xếp hạng. Refactor chỉ đào sâu một chỗ sau khi test đang xanh, không viết báo cáo HTML. Lint dùng lệnh sẵn có của repo, không tự gắn Prettier hay Husky. Perf cần một số đo trước khi sửa. Pack này giữ điều phối subagent và đối chiếu từng `REQ-`. Grill hỏi cả nhóm câu được hỏi ngay, không hỏi từng câu một như bản brainstorming dài. Ý tưởng còn sương thì dừng để chốt một quyết định. Prototype là mã vứt đi. Database style của ui-ux-pro-max vẫn là phần cài thêm; checklist ưu tiên của nó nằm trong `c-design`.
