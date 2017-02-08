class Zboy < Formula
  desc "GameBoy emulator"
  homepage "http://zboy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/zboy/zBoy%20v0.60/zboy-0.60.tar.gz"
  sha256 "f81e61433a5b74c61ab84cac33da598deb03e49699f3d65dcb983151a6f1c749"
  head "http://svn.code.sf.net/p/zboy/code/trunk"

  bottle do
    cellar :any
    sha256 "61d8ae1da9d92971799ba73c44bb6e35c4b96a0eb1aa9772938659fcffd23f87" => :yosemite
    sha256 "82a1ea7e02de1a27897198d39fc72731c89ecdc42a9f42f974a035a58eee9a5f" => :mavericks
    sha256 "782dc15709dc6de67f8b301108485d9ac34d4da41fce8e74b2fc0a2856db8103" => :mountain_lion
  end

  depends_on "sdl2"

  def install
    sdl2 = Formula["sdl2"]
    ENV.append_to_cflags "-std=gnu89 -D__zboy4linux__ -DNETPLAY -DLFNAVAIL -I#{sdl2.include} -L#{sdl2.lib}"
    system "make", "-f", "Makefile.linux", "CFLAGS=#{ENV.cflags}"
    bin.install "zboy"
  end

  test do
    system "#{bin}/zboy", "--help"
  end
end
