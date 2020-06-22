class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/v2.1.0.tar.gz"
  revision 1
  sha256 "4925247524535c0cc128dcc4d87f5538a5ce3b5d3a3c211127fd646ee00252b6"
  head "https://github.com/sindresorhus/macos-wallpaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae71c073450b0e48f8213108a763c71e62fa7f7d801499cfe7eae6bc3be3d5c2" => :catalina
  end

  depends_on :xcode => ["11.4", :build]
  depends_on :macos => :sierra

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/wallpaper"
  end

  test do
    system "#{bin}/wallpaper", "get"
  end
end
