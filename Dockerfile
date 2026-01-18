FROM ubuntu:22.04

# 安装基础依赖
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# 设置 Java 环境
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# 下载并安装 Flutter
WORKDIR /opt
RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz -o flutter.tar.xz \
    && tar xf flutter.tar.xz \
    && rm flutter.tar.xz \
    && chmod -R 755 flutter

# 设置 Flutter 路径
ENV PATH="/opt/flutter/bin:${PATH}"

# 接受 Android 许可（预先配置）
RUN mkdir -p /root/.android \
    && echo "sdk.dir=/opt/android-sdk" > /root/.android/local.properties

# 下载 Android SDK
RUN mkdir -p /opt/android-sdk/cmdline-tools \
    && cd /opt/android-sdk/cmdline-tools \
    && curl -L https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -o tools.zip \
    && unzip tools.zip \
    && rm tools.zip \
    && mv cmdline-tools latest

# 设置 Android 环境变量
ENV ANDROID_HOME="/opt/android-sdk"
ENV PATH="/opt/android-sdk/cmdline-tools/latest/bin:${PATH}"

# 安装必要组件
RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . /app/

# 预热 Flutter（预构建工具）
RUN flutter doctor -v

# 获取依赖
RUN flutter pub get

# 构建 APK
RUN flutter build apk --release

# 复制 APK 到输出目录
RUN mkdir /output \
    && cp build/app/outputs/flutter-apk/app-release.apk /output/

# 输出 APK 文件
CMD ["bash", "-c", "echo 'APK 文件位置: /output/app-release.apk' && ls -lh /output/"]
