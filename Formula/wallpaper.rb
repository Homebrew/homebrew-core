class Wallpaper < Formula
  desc "Get or set the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/1.2.0.tar.gz"
  sha256 "d57ab0cafb9c11cdee8dba9a3a0b9dc5bc0e27cc64bad65529cc1e979a510620"
  head "https://github.com/sindresorhus/macos-wallpaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "152f1f07305a06dd48445ed3f2c76ea5200cffc474ee02e2aad5141d59979f84" => :el_capitan
    sha256 "6f838047f55e449e44ee3d46ac7d4911dfbc8f5c7d38210f623ddaceaf4d9abe" => :yosemite
    sha256 "e0bef9ac123afc7b6deecc01680fd03787431a5c7d034082ce9bf3b54a884a92" => :mavericks
  end

  def install
    system "./build"
    bin.install "wallpaper"
  end

  test do
    system "#{bin}/wallpaper"
  end
end
