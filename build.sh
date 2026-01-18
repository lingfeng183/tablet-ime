#!/bin/bash

echo "========================================="
echo "  Tablet IME 构建说明"
echo "========================================="
echo ""

# 检查 Flutter
if ! command -v flutter &> /dev/null; then
    echo "错误: 未找到 Flutter SDK"
    echo ""
    echo "请先安装 Flutter SDK:"
    echo "  方法1: 官方安装"
    echo "    https://flutter.dev/docs/get-started/install"
    echo ""
    echo "  方法2: 使用 Git 克隆"
    echo "    git clone https://github.com/flutter/flutter.git -b stable"
    echo "    export PATH=\"$PATH:\$PWD/flutter/bin\""
    echo ""
    echo "  方法3: 使用 FVM (Flutter Version Management)"
    echo "    npm install -g fvm"
    echo "    fvm install stable"
    echo "    fvm use stable"
    echo ""
    exit 1
fi

echo "Flutter 版本:"
flutter --version
echo ""

# 检查 Android SDK
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    echo "警告: 未设置 Android SDK 环境变量"
    echo "请设置 ANDROID_HOME 或 ANDROID_SDK_ROOT"
    echo ""
fi

# 配置 local.properties
if [ ! -f "local.properties" ]; then
    echo "配置 local.properties..."
    cat > local.properties << 'PROPS'
sdk.dir=$HOME/Android/Sdk
flutter.sdk=/opt/flutter
PROPS
    echo "已创建 local.properties，请根据实际路径修改"
fi

# 获取依赖
echo "获取依赖..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "错误: 依赖安装失败"
    exit 1
fi

echo ""
echo "构建 APK (这可能需要几分钟)..."
flutter build apk --release

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================="
    echo "  构建成功!"
    echo "========================================="
    echo "APK 文件: build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "安装到设备:"
    echo "  adb install -r build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "启用输入法:"
    echo "  1. 设置 > 语言和输入法"
    echo "  2. 启用 'Tablet IME'"
    echo "  3. 选择 'Tablet IME' 作为当前输入法"
    echo ""
else
    echo ""
    echo "========================================="
    echo "  构建失败"
    echo "========================================="
    echo "请检查错误信息并解决问题"
    exit 1
fi
