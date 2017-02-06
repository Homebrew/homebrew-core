class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  url "http://cyxdown.free.fr/reminiscence/REminiscence-0.3.2.tar.bz2"
  sha256 "063a1d9bb61a91ffe7de69516e48164a1d4d5d240747968bed4fd292d5df546f"

  bottle do
    cellar :any
    sha256 "a11a7b62cbbcd30e24742dc4d1ef881f2f5cedc5a6f61bb18fe6d5092e7c7986" => :sierra
    sha256 "de842e520b31200e696e0139ccb213e1a5704b65529e53af8ea52a8b0c1fdcd2" => :el_capitan
    sha256 "6f664f7cdcf1d5b90f2c82c30f13cdf6960ebd2e83882d4d05cdac0bac1966b0" => :yosemite
  end

  depends_on "libmodplug"
  depends_on "sdl2"

  def install
    # REminiscence supports both SDL1 and 2
    # Use SDL2 to have better input support
    inreplace "Makefile", "sdl-config", "sdl2-config"
    system "make"
    bin.install "rs" => "reminiscence"
  end

  test do
    system bin/"reminiscence", "--help"
  end
end
