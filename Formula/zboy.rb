class Zboy < Formula
  desc "GameBoy emulator"
  homepage "https://zboy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/zboy/zBoy%20v0.60/zboy-0.60.tar.gz"
  sha256 "f81e61433a5b74c61ab84cac33da598deb03e49699f3d65dcb983151a6f1c749"
  head "http://svn.code.sf.net/p/zboy/code/trunk"

  bottle do
    cellar :any
    sha256 "591314e1270d822230b89e64e7d6b4ca5602e77c10c13ae034e7eed347fb2bb0" => :mojave
    sha256 "5eb884e02583dd9b50e554a6dfae805849dbd620bb90d10b721937cb4f35fa50" => :high_sierra
    sha256 "85d55fa04126008eb3a72d8cba9afa52b64231807306340c70414649ec56aca1" => :sierra
    sha256 "3eada5e4cb665257ea7f4dc244e8fe4dac54f279cc9ab2bd4ccfce486b010356" => :el_capitan
    sha256 "ea5ce73b9e6dccb7e96e7a9eb8e7f7c75c54b89d00bded0a0f13bccbc22a7808" => :yosemite
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
