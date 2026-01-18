# 如何获取 Tablet IME 的 APK 文件

本项目已配置好 GitHub Actions 自动构建，您可以通过以下方式获取 APK 文件。

## 方法一：从 GitHub Actions 下载（推荐）

这是最简单的方法，无需安装任何开发工具。

### 步骤：

1. **访问 Actions 页面**
   - 打开项目主页：https://github.com/lingfeng183/tablet-ime
   - 点击顶部的 "Actions" 标签

2. **查看构建结果**
   - 在左侧选择 "Build APK" 工作流
   - 查看最近的构建记录（绿色勾表示成功，红色叉表示失败）

3. **下载 APK**
   - 点击任意一个成功的构建（绿色勾）
   - 滚动到页面底部的 "Artifacts" 部分
   - 点击 `app-release` 下载 APK 文件
   - 下载后解压 ZIP 文件，里面就是 APK

4. **安装到设备**
   - 将 APK 文件传输到 Android 设备
   - 在设备上打开文件管理器，找到 APK 文件
   - 点击安装（可能需要允许从未知来源安装应用）

### 触发新构建

如果您想触发新的构建：

1. 进入 Actions 页面
2. 选择 "Build APK" 工作流
3. 点击右侧的 "Run workflow" 按钮
4. 点击绿色的 "Run workflow" 确认
5. 等待约 5-10 分钟，构建完成后下载

## 方法二：本地构建

如果您想在本地构建 APK，需要安装开发环境。

### Windows 系统

```cmd
# 1. 安装 Flutter
# 访问 https://flutter.dev/docs/get-started/install/windows
# 下载并安装 Flutter SDK

# 2. 安装 Android Studio
# 访问 https://developer.android.com/studio
# 下载并安装，确保安装了 Android SDK

# 3. 配置环境变量
# 将 Flutter bin 目录添加到 PATH

# 4. 克隆项目
git clone https://github.com/lingfeng183/tablet-ime.git
cd tablet-ime

# 5. 运行构建脚本
build_apk.bat

# 或手动构建
flutter pub get
flutter build apk --release
```

### Linux/macOS 系统

```bash
# 1. 安装 Flutter
# Linux:
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
tar xf flutter_linux_3.24.5-stable.tar.xz
export PATH="$PATH:$PWD/flutter/bin"

# macOS:
brew install flutter

# 2. 克隆项目
git clone https://github.com/lingfeng183/tablet-ime.git
cd tablet-ime

# 3. 运行构建脚本
./build_apk.sh

# 或手动构建
flutter pub get
flutter build apk --release
```

### 构建结果

成功构建后，APK 文件位于：
```
build/app/outputs/flutter-apk/app-release.apk
```

## 安装和使用

### 安装 APK

1. **传输文件**
   - 通过 USB 连接设备并传输 APK
   - 或通过云存储（如 Google Drive）下载到设备
   - 或使用 ADB 命令：`adb install -r app-release.apk`

2. **安装**
   - 在设备上找到 APK 文件
   - 点击安装
   - 如果提示"不允许安装未知应用"，需要在设置中允许

### 启用输入法

1. 打开 Android 设置
2. 进入 "系统" > "语言和输入法"
3. 点击 "虚拟键盘" 或 "屏幕键盘"
4. 点击 "管理键盘"
5. 找到 "Tablet IME" 并启用
6. 返回，选择 "Tablet IME" 作为默认输入法

### 使用输入法

- **中英文切换**：点击键盘上的 🇨🇳/🇺🇸 按钮
- **拼音输入**：在中文模式下直接输入拼音
- **功能键**：支持 F1-F12、方向键、Ctrl、Shift、Alt 等

## 系统要求

- Android 7.0 (API 24) 或更高版本
- 建议在平板电脑上使用以获得最佳体验

## 常见问题

### Q: APK 文件多大？
A: 约 42 MB

### Q: 构建需要多久？
A: GitHub Actions 约 5-10 分钟，本地构建约 3-5 分钟（首次构建可能需要更长时间）

### Q: 为什么无法安装？
A: 
- 确保 Android 版本 >= 7.0
- 在设置中允许安装未知来源的应用
- 如果之前安装过，可能需要先卸载旧版本

### Q: 如何报告问题？
A: 在 GitHub 上提交 Issue：https://github.com/lingfeng183/tablet-ime/issues

## 更多信息

- 项目主页：https://github.com/lingfeng183/tablet-ime
- 详细构建指南：[BUILD_GUIDE.md](BUILD_GUIDE.md)
- 快速开始：[QUICKSTART.md](QUICKSTART.md)
