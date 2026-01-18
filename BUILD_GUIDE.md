# Tablet IME - APK 构建完整指南

## 当前环境状态

由于当前环境未安装 Flutter SDK，无法直接生成 APK 文件。请选择以下任一方法进行构建。

---

## 方法1: 在本地机器构建 (推荐)

### 前置要求

- 一台 Linux/Mac/Windows 电脑
- 至少 5GB 可用磁盘空间
- 稳定的网络连接

### 构建步骤

#### Windows 系统

1. **下载 Flutter SDK**
   - 访问: https://flutter.dev/docs/get-started/install/windows
   - 下载 flutter_windows_3.24.5-stable.zip
   - 解压到 `C:\flutter`

2. **配置环境变量**
   ```
   将 C:\flutter\bin 添加到 PATH 环境变量
   ```

3. **安装 Android Studio**
   - 下载: https://developer.android.com/studio
   - 安装时勾选 "Android SDK", "Android SDK Platform-Tools", "Android SDK Build-Tools"

4. **构建 APK**
   ```cmd
   cd tablet_ime
   flutter pub get
   flutter build apk
   ```

#### macOS 系统

1. **安装 Flutter**
   ```bash
   brew install flutter
   export PATH="$PATH:$HOME/flutter/bin"
   ```

2. **安装 Android Studio**
   - 下载: https://developer.android.com/studio
   - 安装 Android SDK 和相关工具

3. **构建 APK**
   ```bash
   cd tablet_ime
   flutter pub get
   flutter build apk
   ```

#### Linux 系统 (Ubuntu/Debian)

1. **安装依赖**
   ```bash
   sudo apt-get update
   sudo apt-get install curl git unzip xz-utils zip libglu1-mesa
   ```

2. **安装 Flutter**
   ```bash
   cd ~
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
   tar xf flutter_linux_3.24.5-stable.tar.xz
   export PATH="$PATH:$PWD/flutter/bin"
   ```

3. **安装 Android SDK**
   ```bash
   sudo apt-get install android-sdk
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
   ```

4. **接受 Android 许可**
   ```bash
   flutter doctor --android-licenses
   ```

5. **构建 APK**
   ```bash
   cd tablet_ime
   flutter pub get
   flutter build apk
   ```

---

## 方法2: 使用 GitHub Actions 自动构建

### 在 GitHub 上创建仓库

1. 创建 GitHub 仓库
2. 将代码推送到仓库

### 创建工作流文件

在项目根目录创建 `.github/workflows/build.yml`:

```yaml
name: Build APK

on:
  push:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        channel: 'stable'
        cache: true
    
    - name: Get dependencies
      run: flutter pub get
    
    - name: Build APK
      run: flutter build apk --release
    
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: app-release
        path: build/app/outputs/flutter-apk/app-release.apk
```

### 触发构建

推送代码后，GitHub Actions 会自动构建 APK。
下载位置: Actions 标签页 -> 构建任务 -> Artifacts

---

## 方法3: 使用 Cloud Build 服务

### Codemagic (免费额度)

1. 访问: https://codemagic.io
2. 连接 GitHub 仓库
3. 配置构建设置:
   - Project: Flutter
   - Platform: Android
   - Build Configuration: Flutter build apk --release
4. 点击构建，完成后下载 APK

### Bitrise (免费额度)

1. 访问: https://www.bitrise.io
2. 连接 GitHub 仓库
3. 选择 Flutter 模板
4. 配置构建命令: flutter build apk --release
5. 开始构建

---

## 方法4: 使用 Docker 构建

### 安装 Docker

```bash
# Ubuntu/Debian
sudo apt-get install docker.io

# macOS
brew install docker

# Windows
# 下载 Docker Desktop
```

### 构建镜像

```bash
cd tablet_ime
docker build -t tablet-ime-builder .
docker run --rm -v "$PWD":/app tablet-ime-builder
```

APK 文件会生成在 `build/app/outputs/flutter-apk/` 目录。

---

## APK 文件位置

构建成功后，APK 文件位于:

```
tablet_ime/build/app/outputs/flutter-apk/app-release.apk
```

---

## 安装到设备

### 方法1: ADB 安装

```bash
adb devices
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### 方法2: 文件管理器

1. 将 APK 传输到 Android 设备
2. 打开文件管理器
3. 找到 APK 文件
4. 点击安装

### 方法3: 网页下载

1. 将 APK 上传到云存储 (Google Drive, Dropbox, 等)
2. 在设备上打开链接下载
3. 点击安装

---

## 启用输入法

1. 打开 **设置**
2. 进入 **语言和输入法**
3. 找到 **Tablet IME** 并启用
4. 点击 **当前输入法**，选择 **Tablet IME**

---

## 验证构建

构建完成后，检查以下内容:

```bash
# 检查 APK 文件
ls -lh build/app/outputs/flutter-apk/app-release.apk

# 应该看到类似输出:
# -rwxr-xr-x 1 user user 28M Jan 17 22:00 app-release.apk

# 使用 aapt 检查 (需要 Android SDK)
aapt dump badging build/app/outputs/flutter-apk/app-release.apk

# 或使用 apksigner (需要 Android SDK)
apksigner verify build/app/outputs/flutter-apk/app-release.apk
```

---

## 常见问题

### 构建时提示缺少 Android SDK

```bash
# 解决方法
flutter doctor --android-licenses
```

### 构建失败提示网络错误

```bash
# 使用国内镜像 (如果在中国)
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
flutter build apk
```

### Java 版本过低

```bash
# 安装 Java 11 或更高版本
sudo apt-get install openjdk-11-jdk  # Linux
brew install openjdk@11              # Mac
```

---

## 优化 APK 大小

如果需要减小 APK 体积，可以构建分架构的 APK:

```bash
# 构建 ARM64 APK (适合大多数现代设备)
flutter build apk --release --target-platform android-arm64

# 构建 ARM32 APK (适合旧设备)
flutter build apk --release --target-platform android-arm

# 构建 x86_64 APK (适合模拟器)
flutter build apk --release --target-platform android-x64
```

---

## 联系支持

如果遇到问题:
1. 运行 `flutter doctor -v` 查看详细诊断
2. 检查 Flutter 文档: https://flutter.dev/docs
3. 查看 GitHub Issues: https://github.com/flutter/flutter/issues
