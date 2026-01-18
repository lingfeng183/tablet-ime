#!/bin/bash

echo "========================================="
echo "  Tablet IME - 一键安装和构建"
echo "========================================="
echo ""

# 检测操作系统
OS="$(uname -s)"
case "$OS" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:$OS"
esac

echo "检测到系统: $MACHINE"
echo ""

# 检查 Flutter
if ! command -v flutter &> /dev/null; then
    echo "========================================="
    echo "  第一步: 安装 Flutter SDK"
    echo "========================================="
    echo ""
    
    if [ "$MACHINE" = "Linux" ]; then
        echo "Linux 系统安装 Flutter:"
        echo ""
        echo "  方法1: 下载官方包"
        echo "    wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz"
        echo "    tar xf flutter_linux_3.24.5-stable.tar.xz"
        echo "    export PATH=\"\$PATH:\$PWD/flutter/bin\""
        echo ""
        echo "  方法2: 使用 Snap"
        echo "    sudo snap install flutter --classic"
        echo ""
        echo "  方法3: 从 APT 安装 (Debian/Ubuntu)"
        echo "    sudo apt-get install flutter"
        echo ""
        
        # 尝试安装
        if command -v snap &> /dev/null; then
            read -p "是否使用 Snap 安装 Flutter? (y/n): " install_snap
            if [ "$install_snap" = "y" ] || [ "$install_snap" = "Y" ]; then
                echo "正在安装 Flutter (可能需要几分钟)..."
                sudo snap install flutter --classic
                export PATH="$PATH:/snap/bin"
            fi
        fi
    elif [ "$MACHINE" = "Mac" ]; then
        echo "Mac 系统安装 Flutter:"
        echo "  brew install flutter"
        echo ""
    fi
    
    echo ""
    echo "安装完成后，请重新运行此脚本"
    echo ""
    exit 1
fi

echo "Flutter 版本:"
flutter --version
echo ""

# 检查 Android SDK
echo "========================================="
echo "  第二步: 检查 Android SDK"
echo "========================================="
echo ""

if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    echo "警告: 未设置 Android SDK 环境变量"
    echo ""
    echo "请安装 Android SDK:"
    echo "  1. 安装 Android Studio"
    echo "  2. 或使用命令行工具 (Linux):"
    echo "     sudo apt-get install android-sdk"
    echo "  3. 设置环境变量:"
    echo "     export ANDROID_HOME=/path/to/Android/Sdk"
    echo ""
    echo "继续尝试构建..."
    echo ""
fi

# 运行 Flutter doctor
echo "运行 Flutter 检查..."
flutter doctor -v || true
echo ""

# 配置 local.properties
echo "========================================="
echo "  第三步: 配置项目"
echo "========================================="
echo ""

if [ ! -f "local.properties" ]; then
    echo "创建 local.properties..."
    
    # 尝试自动检测路径
    SDK_PATH=""
    FLUTTER_PATH=$(which flutter | sed 's/\/bin\/flutter//')
    
    if [ -d "$HOME/Android/Sdk" ]; then
        SDK_PATH="$HOME/Android/Sdk"
    elif [ -d "/opt/android-sdk" ]; then
        SDK_PATH="/opt/android-sdk"
    fi
    
    cat > local.properties << PROPS
sdk.dir=$SDK_PATH
flutter.sdk=$FLUTTER_PATH
PROPS
    
    echo "已创建 local.properties"
    echo "  Android SDK: $SDK_PATH"
    echo "  Flutter SDK: $FLUTTER_PATH"
    echo ""
fi

# 获取依赖
echo "========================================="
echo "  第四步: 获取依赖"
echo "========================================="
echo ""

flutter pub get

if [ $? -ne 0 ]; then
    echo "错误: 依赖安装失败"
    echo "请检查网络连接和 Flutter 配置"
    exit 1
fi

# 构建 APK
echo ""
echo "========================================="
echo "  第五步: 构建 APK"
echo "========================================="
echo ""
echo "这可能需要 5-15 分钟，请耐心等待..."
echo ""

flutter build apk --release

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================="
    echo "  构建成功!"
    echo "========================================="
    echo ""
    echo "APK 文件位置:"
    echo "  build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "文件大小:"
    ls -lh build/app/outputs/flutter-apk/app-release.apk 2>/dev/null || echo "  (文件信息不可用)"
    echo ""
    echo "安装到 Android 设备:"
    echo "  1. 启用 USB 调试"
    echo "  2. 连接设备"
    echo "  3. 运行: adb install -r build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "或通过文件管理器安装:"
    echo "  将 APK 传输到设备，点击安装"
    echo ""
    echo "启用输入法:"
    echo "  1. 设置 > 语言和输入法"
    echo "  2. 找到 'Tablet IME' 并启用"
    echo "  3. 选择 'Tablet IME' 作为当前输入法"
    echo ""
    echo "功能说明:"
    echo "  - 中英文输入: 点击 🇨🇳/🇺🇸 切换"
    echo "  - 拼音输入: 中文模式下输入拼音"
    echo "  - 功能键: F1-F12, 方向键, Ctrl, Shift, Alt 等"
    echo "  - 数字键: 0-9, Back 删除, Enter 确认"
    echo ""
else
    echo ""
    echo "========================================="
    echo "  构建失败"
    echo "========================================="
    echo ""
    echo "请检查错误信息，常见问题:"
    echo "  1. Android SDK 未正确安装"
    echo "  2. Java JDK 未安装或版本过低"
    echo "  3. 网络连接问题"
    echo "  4. 磁盘空间不足"
    echo ""
    echo "运行 'flutter doctor' 查看详细信息"
    echo ""
    exit 1
fi
