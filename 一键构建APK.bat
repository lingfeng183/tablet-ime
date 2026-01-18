@echo off
chcp 65001 >nul
echo ========================================
echo   Tablet IME - 一键构建 APK
echo ========================================
echo.

REM 检查 Flutter
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Flutter
    echo.
    echo 请先安装 Flutter:
    echo 1. 访问 https://flutter.dev/docs/get-started/install/windows
    echo 2. 下载并解压到 C:\flutter
    echo 3. 添加 C:\flutter\bin 到系统 PATH 环境变量
    echo 4. 重新打开此脚本
    echo.
    pause
    exit /b 1
)

echo [1/4] 检查 Flutter 版本...
flutter --version
if %errorlevel% neq 0 (
    echo [错误] Flutter 检查失败
    pause
    exit /b 1
)
echo.

echo [2/4] 获取依赖...
flutter pub get
if %errorlevel% neq 0 (
    echo [错误] 依赖获取失败
    pause
    exit /b 1
)
echo.

echo [3/4] 构建 APK...
echo 这可能需要 5-10 分钟，请耐心等待...
echo.
flutter build apk --release
if %errorlevel% neq 0 (
    echo.
    echo [错误] APK 构建失败
    echo.
    echo 请检查:
    echo 1. 是否安装了 Android SDK
    echo 2. 是否配置了 ANDROID_HOME 环境变量
    echo 3. 运行 flutter doctor 查看详细诊断
    pause
    exit /b 1
)

echo.
echo [4/4] 检查构建结果...
if exist build\app\outputs\flutter-apk\app-release.apk (
    echo ========================================
    echo   构建成功！
    echo ========================================
    echo.
    echo APK 文件位置:
    echo   build\app\outputs\flutter-apk\app-release.apk
    echo.
    dir build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo 安装到设备:
    echo   adb install -r build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo 或通过文件管理器直接安装 APK 文件
    echo.
) else (
    echo [错误] 未找到 APK 文件
    pause
    exit /b 1
)

pause
