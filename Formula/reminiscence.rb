class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  url "http://cyxdown.free.fr/reminiscence/REminiscence-0.3.2.tar.bz2"
  sha256 "063a1d9bb61a91ffe7de69516e48164a1d4d5d240747968bed4fd292d5df546f"

  bottle do
    cellar :any
    sha256 "062ba9c02ce35d463119df045dda6484dbfb09f853dcebef6cc5bed42991f1d2" => :sierra
    sha256 "83ceaab9230a493bd1c86d1db0c9b4fa77070c0cc495339006852781d69aac9d" => :el_capitan
    sha256 "ca207b017eebbf2b7e9aca765f2c73aadef3a1f66b602e67189f1b8534e91c11" => :yosemite
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
