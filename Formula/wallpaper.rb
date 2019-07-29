class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/v2.0.0.tar.gz"
  sha256 "49ab6121dcc78d17aae3219ceeeb1846792855179f11021192e5c42e500b166c"
  head "https://github.com/sindresorhus/macos-wallpaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08a90adb9ccb0c522b09b801f25d018529d0ec1b40dfcd0bf457a4533e9bcf47" => :mojave
    sha256 "bdf9b70a15c4060ba202631c2a3e803ff37369d2d3994d913b67dd840c124f1e" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :macos => :sierra

  def install
    system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib", "--disable-sandbox"
    bin.install ".build/release/wallpaper"
  end

  test do
    system "#{bin}/wallpaper", "get"
  end
end
