class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/v2.1.0.tar.gz"
  sha256 "4925247524535c0cc128dcc4d87f5538a5ce3b5d3a3c211127fd646ee00252b6"
  head "https://github.com/sindresorhus/macos-wallpaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08a90adb9ccb0c522b09b801f25d018529d0ec1b40dfcd0bf457a4533e9bcf47" => :mojave
    sha256 "bdf9b70a15c4060ba202631c2a3e803ff37369d2d3994d913b67dd840c124f1e" => :high_sierra
  end

  depends_on :xcode => ["11.4", :build]
  depends_on :macos => :sierra

  def install
    system "swift", "build", "-c", "release", "--static-swift-stdlib", "--disable-sandbox"
    bin.install ".build/release/wallpaper"
  end

  test do
    system "#{bin}/wallpaper", "get"
  end
end
