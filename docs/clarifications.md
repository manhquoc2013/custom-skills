# Clarifications — Skill Pack `custom-skills`

Các điểm cần làm rõ khi dùng skill trong pack này.

## SLUG: `work/{slug}/` là gì?

Nhiều skill (c-flow, c-implement, c-agents) dùng `work/{slug}/` làm thư mục lưu artifact.
Nhưng không có hướng dẫn slug này được đặt như thế nào — từ tên feature? Tên issue? Tên gì đó khác?

> **Câu hỏi:** Slug được đặt theo quy tắc nào? Có phải là kebab-case của tên feature/ticket?

## SLUG fallback khi không có

- `c-agents` ghi fallback: "otherwise `work/roster.md`"
- Nhưng các file khác như `work/{slug}/plan/PLAN.md`, `work/{slug}/agents/{id}.md` không có fallback tương tự

> **Câu hỏi:** Khi không có slug, thư mục gốc `work/` dùng cho những file nào? Hay tất cả đều bắt buộc có slug?

## External skill dependency

Nhiều skill gọi các skill KHÔNG nằm trong pack này:

| Skill gọi | External skill |
|-----------|----------------|
| c-flow | `writing-plans`, `systematic-debugging` |
| c-implement | `test-driven-development`, `c-debug`, `systematic-debugging`, `diagnosing-bugs` |
| c-agents | `brainstorming`, `writing-plans`, `using-git-worktrees`, `test-driven-development`, `systematic-debugging`, `diagnosing-bugs`, `requesting-code-review`, `c-review`, `c-lint`, `c-refactor`, `c-perf`, `verification-before-completion`, `finishing-a-development-branch`, `dispatching-parallel-agents` |

> **Câu hỏi:** Các skill external này có bắt buộc phải được cài sẵn không? Nếu không, skill fallback là gì?

## `codegraph_explore` MCP tool

c-flow yêu cầu gọi MCP tool `codegraph_explore` ở đầu mỗi luồng.
Nếu không có tool này, phải đọc file trong `c-agents/references/`.

> **Câu hỏi:** Nếu cả MCP và file references đều không có, hành vi default là gì?

## `npx @cobusgreyling/loop` CLI

c-loop dùng CLI bên ngoài để init và doctor. Không có fallback khi CLI không tồn tại.

> **Câu hỏi:** Nếu CLI không có, có thể bỏ qua bước init/doctor hay không?

---

## Ghi chú

File này được tạo từ việc scan các `SKILL.md` trong pack. Chỉ ghi các điểm mà người dùng hoặc người phát triển cần quyết định, không ghi những điểm mà tài liệu đã rõ ràng.
