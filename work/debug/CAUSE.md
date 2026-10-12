## Mode
fix

## Symptom
Expected: `./scripts/install.sh --all` cài đặt thành công 16 kỹ năng vào các IDE/CLI và cài các kỹ năng bổ sung (superpowers, diagnosing-bugs, ui-ux-pro-max) vào các thư mục kỹ năng mà không báo thiếu thư mục.
Actual: Cài đặt vào các thư mục bị lỗi tên có ký tự Carriage Return (`\r`), và khi cài recommended skills báo lỗi `Thiếu ...` cho phần tử cuối cùng của mỗi dòng:
`Thiếu /c/Users/quoctm/.cache/engineering-skills/superpowers/skills/finishing-a-development-branch`
`Thiếu /c/Users/quoctm/.cache/engineering-skills/diagnosing-bugs/skills/engineering/diagnosing-bugs`
`Thiếu /c/Users/quoctm/.cache/engineering-skills/ui-ux-pro-max/.claude/skills/ui-ux-pro-max`

## Red command
Command:
`./scripts/install.sh --all --with-recommended`
Output:
```
Thiếu /c/Users/quoctm/.cache/engineering-skills/superpowers/skills/finishing-a-development-branch
Thiếu /c/Users/quoctm/.cache/engineering-skills/diagnosing-bugs/skills/engineering/diagnosing-bugs
Thiếu /c/Users/quoctm/.cache/engineering-skills/ui-ux-pro-max/.claude/skills/ui-ux-pro-max
```

## Working
Các kỹ năng nằm ở vị trí đầu/giữa danh sách phân cách bởi dấu phẩy (như `skills/using-superpowers`, `skills/brainstorming`,...) không nằm ở cuối dòng nên không dính `\r` và được cài thành công. Chỉ phần tử cuối cùng của mỗi dòng trong tệp TSV có CRLF mới dính ký tự `\r`.

## Cause
Tệp `scripts/agents.tsv` và `recommended-skills.tsv` trên Windows (do checkout Git với core.autocrlf hoặc mặc định Windows) có ký tự kết thúc dòng là CRLF (`\r\n`). Trong `scripts/install.sh`, các vòng lặp `while IFS='|' read -r ...` đọc tệp không loại bỏ ký tự `\r` khỏi biến cuối cùng trên dòng (`$dests` ở dòng 50 và `$paths` ở các dòng 154, 222). Do đó, giá trị của `$dests` và `$paths` (hoặc phần tử cuối của mảng tách từ nó) chứa ký tự `\r`, khiến đường dẫn `$src="$cache/$rel"` và `$dest="$HOME/$rel"` trở thành đường dẫn không tồn tại hoặc tạo thư mục có ký tự `\r` ẩn ở cuối. Đồng thời, cấu hình Git repo (`.gitattributes`) dùng `* text=auto` khiến các tệp `.tsv` và `.sh` bị chuyển thành CRLF trên Windows checkout.

## Discarded
### hypothesis 1: Thư mục nguồn trong cache git clone không tồn tại
Command:
`[ -d "$cache/superpowers/skills/finishing-a-development-branch" ]`
Output:
Thư mục thực tế có tồn tại trên đĩa (`SKILL.md` đầy đủ). Giả thuyết bị bác bỏ.

### hypothesis 2: Lỗi quyền truy cập file hệ thống
Command:
`[ -r "$cache/superpowers/skills/finishing-a-development-branch/SKILL.md" ]`
Output:
Tệp đọc được bình thường. Giả thuyết bị bác bỏ.

## Seam
`scripts/install.sh` tại các vị trí đọc tệp TSV:
1. Dòng 50: `while IFS='|' read -r id label detect dests; do` -> loại bỏ `\r` từ `$dests` (hoặc làm sạch dòng `tr -d '\r'`).
2. Dòng 154 và 222: `while IFS='|' read -r id title repo branch paths; do` -> loại bỏ `\r` từ `$paths` (hoặc làm sạch dòng `tr -d '\r'`).
3. `.gitattributes`: đảm bảo các tệp `.tsv` và `.sh` luôn dùng `eol=lf`.

## Next
Sửa lỗi hoàn tất và đã được kiểm chứng (Verified):
1. Đã tạo regression test `tests/test_install_crlf.sh`.
2. Đã sửa `scripts/install.sh` và `scripts/link-skills.sh` để loại bỏ toàn bộ `\r` khi đọc và xử lý đường dẫn.
3. Đã thêm quy tắc `eol=lf` cho `*.tsv` và `*.sh` trong `.gitattributes`.
4. Đã dọn dẹp sạch 12 thư mục bị dính `\r` trong `$HOME`.
5. Đã chạy lại cả `tests/test_install_crlf.sh` (PASS) và `./scripts/install.sh --all` (PASS, cài đặt sạch sẽ vào toàn bộ IDE tìm thấy và nhận diện các skill bổ sung đã tồn tại đầy đủ).
