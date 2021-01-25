class Z80dasm < Formula
  desc "Disassembler for the Zilog Z80 microprocessor and compatibles"
  homepage "https://www.tablix.org/~avian/blog/articles/z80dasm/"
  url "https://www.tablix.org/~avian/z80dasm/z80dasm-1.1.6.tar.gz"
  sha256 "76d3967bb028f380a0c4db704a894c2aa939951faa5c5630b3355c327c0bd360"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.tablix.org/~avian/z80dasm"
    regex(/href=.*?z80dasm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7b14f8e49b2e1a7e3ea40bf6f0143b75d4aea3561d9beaccc9526f576893e5a3" => :big_sur
    sha256 "3ff2f756e6717012ce138b0ec39d30a71080443aa34858f2e96cb86df773d82a" => :arm64_big_sur
    sha256 "5012e33c0fc342ec32a22462f9a75897fd69d44cf2918c64a593d268fa365c86" => :catalina
    sha256 "0650fc5eadf8ee791201886bd39356af1365f9258c2222e27824fe63500b6eac" => :mojave
    sha256 "a6d8e1d4caa612567de07580a353c82040e5c8005a08117386633e9a11f0df2e" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"a.bin"
    path.binwrite [0xcd, 0x34, 0x12].pack("c*")
    assert_match /call 01234h/, shell_output("#{bin}/z80dasm #{path}")
  end
end
