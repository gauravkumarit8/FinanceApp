# FinanceApp — Android Kotlin

Personal finance app with UPI SMS auto-detection for Indian users.

## Open in Codespaces (one click)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/YOUR_USERNAME/FinanceApp)

> Replace `YOUR_USERNAME` with your GitHub username after uploading.

## Quick start in Codespaces

```bash
# 1. Build the debug APK
./gradlew assembleDebug

# 2. Find your APK here:
#    app/build/outputs/apk/debug/app-debug.apk

# 3. Download it and install on your Android phone
```

## Install APK on your phone

1. Download `app-debug.apk` from the Codespaces file explorer
2. Transfer to your Android phone (WhatsApp, email, USB, Google Drive)
3. On phone: Settings → Security → Enable "Install unknown apps"
4. Tap the APK file to install

## Tech stack

- Kotlin + Jetpack Compose
- MVVM + Clean Architecture
- Room (local DB) + Firebase (cloud sync)
- Hilt (dependency injection)
- UPI SMS auto-detection via BroadcastReceiver

## Build commands

```bash
./gradlew assembleDebug      # Build debug APK
./gradlew test               # Run unit tests
./gradlew clean build        # Clean + full build
./gradlew lint               # Check code quality
```
