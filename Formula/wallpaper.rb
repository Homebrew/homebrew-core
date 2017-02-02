class Wallpaper < Formula
  desc "Get or set the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/1.3.0.tar.gz"
  sha256 "ef5098c47c84d43969ef82c7c0ce7b53abad4c8648d70589ff9426342ec23985"
  head "https://github.com/sindresorhus/macos-wallpaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23528a4f9b7ac5486b3639ac0a9bf370f550a0c641dd2187947e78002a07896d" => :sierra
    sha256 "c41be619bf8adaf2e3472a2c25d1631afd3fcd70b83794184273fe6f3bdbe77c" => :el_capitan
    sha256 "7a715b58b8f4e654b409347fd8cff2bce6a3dfc83b0d345c3b83fc223eaf952a" => :yosemite
  end

  def install
    system "./build"
    bin.install "wallpaper"
  end

  test do
    system "#{bin}/wallpaper"
  end
end
