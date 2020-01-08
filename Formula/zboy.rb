class Zboy < Formula
  desc "GameBoy emulator"
  homepage "https://zboy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/zboy/zBoy%20v0.70/zboy-0.70.tar.gz"
  sha256 "55cd235fba759eb888e508f463e12bfa7ffc0336bd93c581477463612d6ef4ba"
  head "https://svn.code.sf.net/p/zboy/code/trunk"

  bottle do
    cellar :any
    sha256 "2ad945f7d40d2ff506741229fa63c28aeedea3724e81e9ddcb7c28d649a77929" => :catalina
    sha256 "c813bac5cabe3cfc5b716a871586e757b64b47a8c74849a39a3640d975a3ac0b" => :mojave
    sha256 "90bea3958e333bee7386f18aa1c356b2085c35497f6f2ea13f52177d3c98c160" => :high_sierra
    sha256 "32e11823c3994c8e5e3643cb3a55195cda48a9c744e4c50d88d7a70988c28829" => :sierra
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
