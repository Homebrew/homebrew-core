class Wallpaperutil < Formula
  desc "macOS wallpaper management util."
  homepage "https://github.com/aurimasniekis/wallpaperutil"
  url "https://github.com/aurimasniekis/wallpaperutil/archive/1.0.0.tar.gz"
  sha256 "5c5a8f8dc63665d74106ecb16451202dd4662fdb05f6a9bcaf7ecb6509ba659a"
  head "https://github.com/aurimasniekis/wallpaperutil.git"

  def install
    xcodebuild "-project", "WallpaperUtil.xcodeproj",
                   "-target", "WallpaperUtil",
                   "SYMROOT=build",
                   "-verbose"

    prefix.install Dir["build/Release/*"]

    bin.write_exec_script "#{prefix}/wallpaperutil"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/wallpaperutil -v")
  end
end
