---
layout: post
title: "Autohotkey v2 DllCall 对应 win32 API 的参数类型对照表"
date: 2025-09-25 08:24:52 +0800
tags: ["Autohotkey", "Autohotkey v2", "DllCall"]
---

Win32 API 里的类型本质上是 C typedef，一层套一层，最终都落在基本的 `int/long/short/char/void*` 上。

Win32 → AutoHotkey v2 DllCall 类型对照表

---

## 📌 基本整数类型

| Win32 类型         | 位数 (Win64/Win32) | AHK v2 类型  |
| ---------------- | ---------------- | ---------- |
| `BYTE`           | 8-bit 无符号        | `"UChar"`  |
| `unsigned char`  | 8-bit 无符号        | `"UChar"`  |
| `CHAR`           | 8-bit 有符号        | `"Char"`   |
| `WORD`           | 16-bit 无符号       | `"UShort"` |
| `SHORT`          | 16-bit 有符号       | `"Short"`  |
| `INT` / `LONG`   | 32-bit 有符号       | `"Int"`    |
| `UINT` / `ULONG` | 32-bit 无符号       | `"UInt"`   |
| `__int64`        | 64-bit 有符号       | `"UInt"`   |
| `long long`      | 64-bit 有符号       | `"Int64"`  |
| `unsigned __int64`| 64-bit 无符号      | `"UInt64"`  |
| `unsigned long long`| 64-bit 无符号    | `"UInt64"`  |
| `DWORD`          | 32-bit 无符号       | `"UInt"`   |
| `BOOL`           | 32-bit (0/非0)     | `"Int"`    |
| `FLOAT`          | 32-bit 浮点        | `"Float"`  |
| `DOUBLE`         | 64-bit 浮点        | `"Double"` |

---

## 📌 指针 / 句柄类型

在 Win64 下，所有指针和句柄都是 64 位，Win32 下是 32 位。
所以在 AHK v2 一律用 `"Ptr"` / `"UPtr"`。
`Handle` 实际上是 `Ptr` 的别名，AHK 内部处理方式相同，但使用 `Handle` 可以使代码更具可读性。

| Win32 类型    | AHK v2 类型 | 说明            |
| ----------- | --------- | ------------- |
| `HANDLE`    | `"Handle"`   | 泛型句柄          |
| `HDC`       | `"Handle"`   | 设备上下文         |
| `HBITMAP`   | `"Handle"`   | 位图句柄          |
| `HWND`      | `"Handle"`   | 窗口句柄          |
| `HMODULE`   | `"Handle"`   | 模块句柄          |
| `HINSTANCE` | `"Handle"`   | 实际上等于 HMODULE |
| `LPVOID`    | `"Ptr"`   | void\*        |
| `PVOID`     | `"Ptr"`   | void\*        |

---

## 📌 Windows 专用整型别名

| Win32 类型    | AHK v2 类型 | 说明             |
| ----------- | --------- | -------------- |
| `DWORD_PTR` | `"UPtr"`  | 无符号指针大小整数      |
| `LONG_PTR`  | `"Ptr"`   | 有符号指针大小整数      |
| `INT_PTR`   | `"Ptr"`   | 有符号指针大小整数      |
| `UINT_PTR`  | `"UPtr"`  | 无符号指针大小整数      |
| `SIZE_T`    | `"UPtr"`  | 通常用于内存大小       |
| `SSIZE_T`   | `"Ptr"`   | 符号型内存大小        |
| `WPARAM`    | `"UPtr"`  | 消息参数 (无符号指针大小) |
| `LPARAM`    | `"Ptr"`   | 消息参数 (有符号指针大小) |
| `LRESULT`   | `"Ptr"`   | 消息返回值          |

---

## 📌 字符串相关

| Win32 类型             | AHK v2 类型 | 说明                               |
| -------------------- | --------- | -------------------------------- |
| `LPCSTR` / `LPSTR`   | `"AStr"`  | ANSI 字符串                         |
| `LPCWSTR` / `LPWSTR` | `"WStr"`  | 宽字符（UTF-16 LE），Win32 API 常用      |
| `TCHAR*`             | `"WStr"`  | 在 Unicode 版本 Windows 上等价于 `WStr` |

---

## 📌 结构体指针

如果 API 要传结构体指针，一般写成 `"Ptr", &buffer`，
然后用 `Buffer()` 或 `VarSetCapacity()` 来分配内存。

例子：

```ahk
rect := Buffer(16, 0) ; RECT 结构体 4 个 int
DllCall("GetWindowRect", "Ptr", hWnd, "Ptr", rect, "Int")
left   := NumGet(rect, 0, "Int")
top    := NumGet(rect, 4, "Int")
right  := NumGet(rect, 8, "Int")
bottom := NumGet(rect, 12, "Int")
```

---

## 📌 返回值类型

最后一个参数是返回值类型，不写的话默认是 `"Int"`。
常见返回值类型：

* `"Int"` / `"UInt"` → 整数
* `"Ptr"` / `"UPtr"` → 句柄、指针
* `"Float"` / `"Double"` → 浮点数
* `"Int64"` / `"UInt64"` → 64 位整数

---

## 特殊类型和后缀

除了上述基本类型，AHK v2 DllCall 还支持一些特殊的类型标识或后缀，它们提供了更灵活的参数处理能力：

* **`*` (星号)**：在类型标识符后加上星号，表示该参数是一个**输出参数**，即函数会修改此参数所指向的内存。例如，`"Int*"` 表示一个指向整数的指针，函数会把结果写入该地址。
* **`&` (取地址符)**：用于传递变量的地址。虽然 DllCall 的参数本身就是值传递，但有时需要显式地传递变量的地址，例如当函数需要一个指向变量的指针时。
* **`Str`, `WStr`, `AStr` 作为输出参数**：当 `Str*` 或 `WStr*` 用于输出参数时，AHK 会自动分配一个缓冲区并将其地址传递给 DLL 函数。函数执行后，AHK 会将该缓冲区的内容自动读回为一个 AHK 字符串。

---

## 使用示例

下面是一个简单的示例，展示如何使用 `DllCall` 调用 Win32 API `MessageBoxA`：

```ahk
; 调用 MessageBoxA，显示一个消息框
; 参数类型：
; 1. HWND hWnd：句柄，对应 AHK 的 "Ptr"
; 2. LPCSTR lpText：文本，对应 AHK 的 "Str" 或 "AStr"
; 3. LPCSTR lpCaption：标题，对应 AHK 的 "Str" 或 "AStr"
; 4. UINT uType：类型，对应 AHK 的 "UInt"

DllCall("MessageBoxA", "Ptr", 0, "AStr", "这是一个消息", "AStr", "AHK 示例", "UInt", 0)
```

在上面的例子中，我们使用了 `Ptr` 来表示 `HWND`，以及 `AStr` 来表示两个 ANSI 字符串。**AStr** 比 **Str** 更能明确地表明我们传入的是 ANSI 字符串，这在处理 Win32 API 时很有用。

**提示**：

* 对于不确定是 ANSI 还是 Unicode 版本的函数，优先使用 **WStr**，因为它更符合现代 Windows 系统的编码标准。如果函数名以 **W** 结尾（如 `MessageBoxW`），则必须使用 `WStr`。如果以 **A** 结尾（如 `MessageBoxA`），则使用 `Str` 或 `AStr`。
* 对于指针类型，如 `HANDLE`, `HWND`, `LPVOID` 等，通常使用 **Ptr** 类型即可。
* 在调用前，查阅 MSDN 文档以确认函数的参数和返回值的确切类型，这是正确使用 DllCall 的关键。
