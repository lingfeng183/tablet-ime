#!/bin/bash

echo "========================================"
echo "  Tablet IME - 一键构建 APK"
echo "========================================"
echo ""

# 检查 Flutter
if ! command -v flutter &> /dev/null; then
    echo "[错误] 未找到 Flutter"
    echo ""
    echo "请先安装 Flutter:"
    echo ""
    echo "Mac:"
    echo "  brew install flutter"
    echo ""
    echo "Linux:"
    echo "  wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz"
    echo "  tar xf flutter_linux_3.24.5-stable.tar.xz"
    echo "  export PATH=\"\$PATH:\$PWD/flutter/bin\""
    echo ""
    exit 1
fi

echo "[1/4] 检查 Flutter 版本..."
flutter --version
echo ""

echo "[2/4] 获取依赖..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "[错误] 依赖获取失败"
    exit 1
fi
echo ""

echo "[3/4] 构建 APK..."
echo "这可能需要 5-10 分钟，请耐心等待..."
echo ""
flutter build apk --release
if [ $? -ne 0 ]; then
    echo ""
    echo "[错误] APK 构建失败"
    echo ""
    echo "请检查:"
    echo "1. 是否安装了 Android SDK"
    echo "2. 是否配置了 ANDROID_HOME 环境变量"
    echo "3. 运行 'flutter doctor' 查看详细诊断"
    exit 1
fi

echo ""
echo "[4/4] 检查构建结果..."
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "========================================"
    echo "  构建成功！"
    echo "========================================"
    echo ""
    echo "APK 文件位置:"
    ls -lh build/app/outputs/flutter-apk/app-release.apk
    echo ""
    echo "安装到设备:"
    echo "  adb install -r build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "或通过文件管理器直接安装 APK 文件"
    echo ""
else
    echo "[错误] 未找到 APK 文件"
    exit 1
fi
