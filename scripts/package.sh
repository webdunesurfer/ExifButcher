#!/usr/bin/env bash
# Builds ExifButcher.app and packages it as a .dmg and .pkg in dist/.
#
# Usage: scripts/package.sh <version> [build-number]
#   version       Marketing version, e.g. 1.2.0 (CFBundleShortVersionString)
#   build-number  Monotonic build number (CFBundleVersion), defaults to 1
#
# The app is ad-hoc signed (no Apple Developer ID), so Gatekeeper will still
# ask users to confirm the first launch, but it will no longer report the app
# as "damaged".
set -euo pipefail

VERSION="${1:?usage: $0 <version> [build-number]}"
BUILD_NUMBER="${2:-1}"
BUNDLE_ID="info.in4net.ExifButcher"
APP_NAME="ExifButcher"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$ROOT/build"
DIST_DIR="$ROOT/dist"
STAGE_DIR="$BUILD_DIR/stage"
APP="$BUILD_DIR/Release/$APP_NAME.app"

cd "$ROOT"
rm -rf "$BUILD_DIR" "$DIST_DIR"
mkdir -p "$DIST_DIR"

echo "==> Generating Xcode project"
xcodegen generate

echo "==> Building $APP_NAME $VERSION ($BUILD_NUMBER)"
xcodebuild \
  -project "$APP_NAME.xcodeproj" \
  -scheme "$APP_NAME" \
  -configuration Release \
  build \
  SYMROOT="$BUILD_DIR" \
  ARCHS="arm64 x86_64" \
  ONLY_ACTIVE_ARCH=NO \
  MARKETING_VERSION="$VERSION" \
  CURRENT_PROJECT_VERSION="$BUILD_NUMBER" \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

echo "==> Ad-hoc signing"
codesign --force --deep --sign - "$APP"
codesign --verify --deep --strict --verbose=2 "$APP"

echo "==> Creating disk image"
DMG_STAGE="$STAGE_DIR/dmg"
mkdir -p "$DMG_STAGE"
ditto "$APP" "$DMG_STAGE/$APP_NAME.app"
ln -s /Applications "$DMG_STAGE/Applications"
hdiutil create \
  -volname "$APP_NAME $VERSION" \
  -srcfolder "$DMG_STAGE" \
  -ov -format UDZO \
  "$DIST_DIR/$APP_NAME-$VERSION.dmg"

echo "==> Creating installer package"
PKG_STAGE="$STAGE_DIR/pkg"
COMPONENT_PLIST="$STAGE_DIR/component.plist"
mkdir -p "$PKG_STAGE"
ditto "$APP" "$PKG_STAGE/$APP_NAME.app"
pkgbuild --analyze --root "$PKG_STAGE" "$COMPONENT_PLIST"
# The Finder Service only registers from /Applications, so never let
# Installer "upgrade" a copy of the app that lives somewhere else.
plutil -replace 0.BundleIsRelocatable -bool NO "$COMPONENT_PLIST"
pkgbuild \
  --root "$PKG_STAGE" \
  --component-plist "$COMPONENT_PLIST" \
  --identifier "$BUNDLE_ID" \
  --version "$VERSION" \
  --install-location /Applications \
  "$DIST_DIR/$APP_NAME-$VERSION.pkg"

echo "==> Writing checksums"
(cd "$DIST_DIR" && shasum -a 256 "$APP_NAME-$VERSION".* > SHA256SUMS.txt)

echo "==> Done"
ls -lh "$DIST_DIR"
