# 创建 APK 文件 - 最简单的方法

## 方法 1: 使用 GitHub Actions (推荐，完全免费)

这是最简单的方法，不需要安装任何软件。

### 步骤:

1. **注册 GitHub 账号** (如果没有)
   - 访问: https://github.com/signup

2. **创建新仓库**
   - 登录 GitHub
   - 点击右上角 "+" 号
   - 选择 "New repository"
   - 仓库名称填写: `tablet-ime`
   - 选择 "Public"
   - 点击 "Create repository"

3. **上传代码到 GitHub**

   **方法 A: 使用 Git 命令 (推荐)**
   ```bash
   cd tablet_ime
   git init
   git add .
   git commit -m "Initial commit"
   
   # 替换下面的 YOUR_USERNAME 为你的 GitHub 用户名
   git remote add origin https://github.com/YOUR_USERNAME/tablet-ime.git
   git branch -M main
   git push -u origin main
   ```

   **方法 B: 直接上传文件**
   - 在 GitHub 仓库页面
   - 点击 "uploading an existing file"
   - 拖拽 `tablet_ime` 文件夹中的所有文件
   - 点击 "Commit changes"

4. **触发构建**

   构建会自动开始，也可以手动触发:
   - 进入仓库
   - 点击 "Actions" 标签
   - 选择 "Build APK" 工作流
   - 点击 "Run workflow" → "Run workflow"

5. **下载 APK**

   等待构建完成 (约 5-10 分钟):
   - 进入 "Actions" 标签
   - 点击最新的构建任务
   - 滚动到页面底部 "Artifacts" 部分
   - 下载 `app-release-arm64.apk` (推荐，适合大多数设备)
   - 或下载 `app-release-universal.apk` (通用版本，文件较大)

6. **安装到设备**

   - 将 APK 文件传输到手机/平板
   - 打开文件管理器，找到 APK 文件
   - 点击安装
   - 安装后在设置中启用输入法

---

## 方法 2: 使用 Codemagic (免费额度)

### 步骤:

1. **注册 Codemagic**
   - 访问: https://codemagic.io
   - 使用 GitHub 账号登录

2. **添加应用**
   - 点击 "Add application"
   - 选择 GitHub 仓库
   - 选择 `tablet-ime` 仓库
   - 点击 "Next: Build configuration"

3. **配置构建**
   - 选择 "Flutter workflow"
   - 在 "Build steps" 中确认命令:
     ```
     flutter pub get
     flutter build apk --release
     ```

4. **开始构建**
   - 点击 "Start new build"
   - 等待构建完成
   - 下载生成的 APK

---

## 方法 3: 在本地电脑构建

### Windows 电脑

```cmd
# 1. 下载 Flutter
# 访问: https://flutter.dev/docs/get-started/install/windows
# 下载 flutter_windows_3.24.5-stable.zip
# 解压到 C:\flutter

# 2. 添加环境变量
# 右键 "此电脑" -> 属性 -> 高级系统设置 -> 环境变量
# 在系统变量 "Path" 中添加: C:\flutter\bin

# 3. 安装 Android Studio
# 下载: https://developer.android.com/studio
# 安装时勾选: Android SDK, Android SDK Platform-Tools, Android SDK Build-Tools

# 4. 打开命令提示符，运行:
cd tablet_ime
flutter pub get
flutter build apk

# 5. APK 文件位置
# tablet_ime\build\app\outputs\flutter-apk\app-release.apk
```

### Mac 电脑

```bash
# 1. 安装 Flutter
brew install flutter

# 2. 安装 Android Studio
brew install --cask android-studio

# 3. 运行构建
cd tablet_ime
flutter pub get
flutter build apk

# 4. APK 文件位置
# tablet_ime/build/app/outputs/flutter-apk/app-release.apk
```

### Linux 电脑

```bash
# 1. 安装 Flutter
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
tar xf flutter_linux_3.24.5-stable.tar.xz
export PATH="$PATH:$HOME/flutter/bin"

# 2. 安装 Android SDK
sudo apt-get install android-sdk android-sdk-platform-tools

# 3. 运行构建
cd tablet_ime
flutter pub get
flutter build apk

# 4. APK 文件位置
# tablet_ime/build/app/outputs/flutter-apk/app-release.apk
```

---

## 方法 4: 使用在线 IDE

### Repl.it

1. 访问: https://replit.com
2. 点击 "+" 创建新项目
3. 选择 "Flutter" 模板
4. 将代码复制粘贴到项目中
5. 在 Shell 中运行:
   ```bash
   flutter build apk
   ```
6. 下载生成的 APK

---

## 推荐顺序

1. **GitHub Actions** (最简单，免费，无需安装任何东西)
2. **Codemagic** (也很简单，有免费额度)
3. **本地构建** (需要安装软件，但速度快)
4. **在线 IDE** (适合测试)

---

## 快速选择

- **完全不懂技术**: 使用 GitHub Actions (按步骤操作即可)
- **有 GitHub 账号**: 使用 GitHub Actions
- **不想安装软件**: 使用 GitHub Actions 或 Codemagic
- **电脑性能好**: 使用本地构建
- **只是想试试**: 使用在线 IDE

---

## 常见问题

### Q: 构建需要多久？
A: GitHub Actions 约 5-10 分钟，本地构建约 3-5 分钟

### Q: APK 文件多大？
A: 约 25-30 MB

### Q: 可以安装到哪些设备？
A: Android 7.0 及以上系统的设备

### Q: 需要支付费用吗？
A: 不需要，GitHub Actions 和 Codemagic 都有免费额度

---

## 需要帮助？

查看详细文档:
- README.md - 项目说明
- BUILD_GUIDE.md - 详细构建指南
- README_BUILD_STATUS.md - 构建状态说明
