# PowerShell Recursive Downloader

A PowerShell script to recursively download files and subfolders from web directory listings (e.g., Apache/Nginx autoindex pages).  
Supports:
- Recursive traversal of subfolders
- Skipping query/sorting links (`?C=N&O=A`)
- Resume support for interrupted downloads
- Optional filters for file types (e.g., only `.zip` or `.exe`)

## 🚀 Features
- **Recursive download**: Mirrors entire directory structures locally
- **Resume support**: Continues partial downloads using HTTP Range requests
- **Parallel jobs**: Faster throughput by downloading multiple files at once
- **Filters**: Skip unwanted files or restrict to specific extensions

## 🛠 Usage
1. Clone this repository:
   ```bash
   git clone https://github.com/USERNAME/PowerShell-Recursive-Downloader.git
  ~~~run
   .\d.ps1
