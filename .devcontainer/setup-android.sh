#!/bin/bash
set -e

echo "📦 Setting up Android SDK..."

# ── Directories ──────────────────────────────────────────────────────────────
ANDROID_HOME="$HOME/android-sdk"
TOOLS_DIR="$ANDROID_HOME/cmdline-tools/latest"
mkdir -p "$TOOLS_DIR"

# ── Download Android command-line tools ──────────────────────────────────────
CMDTOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
wget -q --show-progress "$CMDTOOLS_URL" -O /tmp/cmdtools.zip
unzip -q /tmp/cmdtools.zip -d /tmp/cmdtools-extract
mv /tmp/cmdtools-extract/cmdline-tools/* "$TOOLS_DIR/"
rm -rf /tmp/cmdtools.zip /tmp/cmdtools-extract

# ── Environment variables ─────────────────────────────────────────────────────
{
  echo ""
  echo "# Android SDK"
  echo "export ANDROID_HOME=$ANDROID_HOME"
  echo "export ANDROID_SDK_ROOT=$ANDROID_HOME"
  echo "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin"
  echo "export PATH=\$PATH:\$ANDROID_HOME/platform-tools"
  echo "export PATH=\$PATH:\$ANDROID_HOME/build-tools/35.0.0"
} >> "$HOME/.bashrc"

export ANDROID_HOME="$ANDROID_HOME"
export PATH="$PATH:$TOOLS_DIR/bin"

# ── Accept licenses ───────────────────────────────────────────────────────────
yes | sdkmanager --sdk_root="$ANDROID_HOME" --licenses > /dev/null 2>&1 || true

# ── Install SDK components ────────────────────────────────────────────────────
sdkmanager --sdk_root="$ANDROID_HOME" \
  "platform-tools" \
  "platforms;android-35" \
  "build-tools;35.0.0" \
  "extras;android;m2repository" \
  "extras;google;m2repository"

# ── Make gradlew executable (if present) ─────────────────────────────────────
[ -f "$GITHUB_WORKSPACE/gradlew" ] && chmod +x "$GITHUB_WORKSPACE/gradlew"
find /workspaces -name "gradlew" -exec chmod +x {} \; 2>/dev/null || true

echo ""
echo "✅ Android SDK installed at $ANDROID_HOME"
echo "✅ Platform: android-35"
echo "✅ Build tools: 35.0.0"
echo ""
echo "👉 Next steps:"
echo "   cd /workspaces/FinanceApp"
echo "   ./gradlew assembleDebug"
