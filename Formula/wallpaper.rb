class Wallpaper < Formula
  desc "Get or set the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/1.3.0.tar.gz"
  sha256 "ef5098c47c84d43969ef82c7c0ce7b53abad4c8648d70589ff9426342ec23985"
  head "https://github.com/sindresorhus/macos-wallpaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a4578853631de822d6d09008ac849447c10a22f09a3a88939cdb808f6384744" => :sierra
    sha256 "371927997832b14cfc197aa5be3c5bcc2e3bca84523c8e43340080bf8e81e340" => :el_capitan
    sha256 "5010ad61cc504d0268a7da142d1fea366498675dda2e92a08b93a5f24b28613d" => :yosemite
    sha256 "6f60873e8ac2f4f8a41770496e43e1284534a954134198cee9837cdd8cad7e0f" => :mavericks
  end

  def install
    system "./build"
    bin.install "wallpaper"
  end

  test do
    system "#{bin}/wallpaper"
  end
end
