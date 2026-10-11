# Engineering skills

Bộ skill cho Cursor. Agent hỏi đủ context, lập danh sách yêu cầu bạn xác nhận, rồi tự làm đến khi mỗi yêu cầu có kết quả lệnh khớp kết quả mong đợi.

Skill nằm ở thư mục gốc của repo này. Mỗi skill là một thư mục chứa `SKILL.md`.

## Cài đặt

Cần Cursor và một chat Agent mới sau khi cài. Skill gắn bằng symlink, nên sửa file trong repo này là bản Cursor đang đọc.

### Mọi project

Chạy trong thư mục repo này:

```bash
mkdir -p ~/.cursor/skills
for name in routing-engineering-work scaffolding-project specifying-a-feature implementing-from-spec prompting-the-loop running-the-loop processing-the-flow designing-interface; do
  ln -sfn "$(pwd)/$name" "$HOME/.cursor/skills/$name"
done
ls -l ~/.cursor/skills
```

Mỗi dòng phải là một symlink trỏ về repo này. Mở một chat Agent mới. Gõ `/processing-the-flow` để kiểm tra lệnh đã xuất hiện.

### Một project

Trong project đó:

```bash
mkdir -p .cursor/skills
for name in routing-engineering-work scaffolding-project specifying-a-feature implementing-from-spec prompting-the-loop running-the-loop processing-the-flow designing-interface; do
  ln -sfn "/Users/tranquoc/Developer/mcp/skills/$name" ".cursor/skills/$name"
done
```

Đổi đường dẫn gốc nếu repo skill không nằm ở chỗ đó. Skill trong project được ưu tiên khi bạn đang mở project đó.

### Gỡ

```bash
rm ~/.cursor/skills/{routing-engineering-work,scaffolding-project,specifying-a-feature,implementing-from-spec,prompting-the-loop,running-the-loop,processing-the-flow,designing-interface}
```

Lệnh này chỉ xóa symlink, không xóa file trong repo.

## Cách gọi

Hai cách:

- Gõ `/tên-skill` khi muốn ép đúng nhánh.
- Nói việc cần làm. Agent tự mở skill có mô tả khớp. `/routing-engineering-work` là cửa vào khi câu nói chưa chỉ rõ nhánh.

Chat đang mở từ trước lúc cài không thấy skill mới. Mở chat khác.

## Làm một việc cho xong

Gọi `/processing-the-flow`, rồi dán yêu cầu.

Agent dừng để hỏi trước khi code. Một mục chỉ tính khi bạn viết hoặc xác nhận. Câu đoán của agent không tính.

| Mục | Bạn cần nói |
|-----|-------------|
| Outcome | Xong thì điều gì đúng |
| Actor | Ai thực hiện |
| Behavior | Đường chính, gồm dữ liệu đầu vào |
| Failure | Lỗi, rỗng, hoặc bị cấm thì sao |
| Out of scope | Việc này không làm gì |
| Verify | Lệnh, thao tác trên màn hình, hoặc ví dụ chứng minh đạt |
| Source | Đường dẫn tài liệu hoặc ticket, hoặc prompt này là nguồn duy nhất |

Có màn hình thì hỏi thêm màn hình nào và hệ visual sẵn, hoặc không có. Bug thì hỏi cách tái hiện, kết quả thực tế và kết quả đúng.

Mỗi hành vi là một dòng riêng. Agent đưa danh sách rồi chờ bạn nói danh sách đã đủ:

```text
REQ-1 | admin xuất CSV | file có mã đơn và tổng tiền
REQ-2 | người không phải admin bấm xuất | bị từ chối, không có file
```

Bạn thêm hành vi thì nó đánh số lại và hỏi lần nữa. Bạn xác nhận đủ thì nó ghi `CONTEXT.md` và tự đi tiếp, không hỏi "làm tiếp không?".

| Cổng | Việc | Sang cổng sau khi |
|------|------|-------------------|
| Plan | Đọc code, ghi `RESEARCH.md` với `GO`, `CONDITIONAL`, hoặc `NO-GO`, rồi `PLAN.md` | Mỗi `REQ-` có đúng một task, task có lệnh kiểm, hai task cùng đợt không sửa một file |
| Execute | Một task: test đỏ, code tối thiểu, chạy lệnh kiểm | `checks/{task}.md` là `PASS`. Kết quả mong đợi được trích từ dòng `REQ-`, output lệnh được dán vào. Nhánh trong diff mà không có lệnh là `REJECT` |
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
  checks/T1.md
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
| Mỗi task | `test-driven-development`, rồi `requesting-code-review` |
| Task không đụng cùng file | `subagent-driven-development` |
| Task đụng cùng file | `executing-plans` |
| Test đỏ hoặc bug | `systematic-debugging` |
| Trước khi báo đạt | `verification-before-completion` |
| Xong việc | `finishing-a-development-branch` |

File trạng thái vẫn nằm trong `work/{slug}/`. Superpowers không thay câu hỏi context và không được báo xong khi còn `REQ-` chưa khớp.
