# 快速开始

## 方法1: 一键安装和构建 (推荐)

```bash
cd tablet_ime
./install_and_build.sh
```

这个脚本会自动:
- 检查和安装 Flutter SDK
- 检查和配置 Android SDK
- 获取项目依赖
- 构建 APK

## 方法2: 手动构建

### 1. 安装 Flutter SDK

**Linux:**
```bash
# 使用 Snap
sudo snap install flutter --classic

# 或下载
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
tar xf flutter_linux_3.24.5-stable.tar.xz
export PATH="$PATH:$PWD/flutter/bin"
```

**Mac:**
```bash
brew install flutter
```

### 2. 安装 Android SDK

- 下载 Android Studio: https://developer.android.com/studio
- 或使用命令行: `sudo apt-get install android-sdk`

### 3. 配置环境变量

```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

### 4. 构建 APK

```bash
cd tablet_ime
flutter pub get
flutter build apk
```

## 安装 APK

### 通过 ADB
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 通过文件管理器
1. 将 APK 传输到 Android 设备
2. 在文件管理器中点击 APK 文件安装

## 启用输入法

1. 打开设置 > 语言和输入法
2. 找到 "Tablet IME" 并启用
3. 选择 "Tablet IME" 作为当前输入法

## 功能说明

### 中文输入
- 点击 🇨🇳 图标切换到中文模式
- 输入拼音字母
- 从候选词列表选择汉字
- 按空格键选择第一个候选词

### 英文输入
- 点击 🇨🇳/🇺🇸 切换到 🇺🇸 图标
- 直接输入字母

### 功能键
- **F1-F12**: 直接点击对应功能键
- **方向键**: ↑↓←→ 导航光标
- **Ctrl/Shift/Alt**: 组合其他键使用
- **数字键**: 0-9
- **Back**: 删除字符
- **Enter**: 确认输入或换行
- **Tab**: 切换焦点
- **Esc**: 取消/退出
- **Home/End**: 跳转行首/行尾
- **Del**: 删除字符

## 常见问题

### 构建失败
运行 `flutter doctor` 检查配置

### 输入法未显示
确保已在系统设置中启用

### 无法输入
检查是否选择了正确的输入法

## 项目结构

```
tablet_ime/
├── lib/                      # Flutter 代码
│   ├── main.dart            # 主入口
│   ├── keyboard_layout.dart # 键盘布局
│   ├── keyboard_state.dart  # 状态管理
│   ├── keyboard_service.dart # 输入服务
│   └── key_button.dart      # 按键组件
├── android/                 # Android 配置
│   ├── app/build.gradle     # 应用构建配置
│   └── src/main/            # 源码
│       ├── AndroidManifest.xml
│       └── java/.../TabletInputMethodService.java
├── pubspec.yaml             # 依赖配置
├── install_and_build.sh     # 一键安装脚本
└── build.sh                 # 构建脚本
```
