cask "exifbutcher" do
  version "1.0.0"
  sha256 "9613e27a51879645a7b89540914468d3b14da818d42d4fd290ef2bd5ff5004b8"

  url "https://github.com/webdunesurfer/ExifButcher/releases/download/v#{version}/ExifButcher-#{version}.dmg"
  name "ExifButcher"
  desc "Menu bar utility to change the camera model in RAW files' EXIF data"
  homepage "https://github.com/webdunesurfer/ExifButcher"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "ExifButcher.app"

  # The app is ad-hoc signed but not notarized (no Apple Developer ID), so
  # clear the download quarantine to let it launch without a Gatekeeper prompt.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/ExifButcher.app"]
  end

  uninstall quit: "info.in4net.ExifButcher"

  zap trash: "~/Library/Preferences/info.in4net.ExifButcher.plist"

  caveats <<~EOS
    Open ExifButcher once from /Applications to register the
    "📷 ExifButcher: Adjust RAWs EXIF" Finder action.
  EOS
end
