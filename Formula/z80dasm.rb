class Z80dasm < Formula
  desc "Disassembler for the Zilog Z80 microprocessor and compatibles"
  homepage "https://www.tablix.org/~avian/blog/articles/z80dasm/"
  url "https://www.tablix.org/~avian/z80dasm/z80dasm-1.1.6.tar.gz"
  sha256 "76d3967bb028f380a0c4db704a894c2aa939951faa5c5630b3355c327c0bd360"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.tablix.org/~avian/z80dasm/"
    regex(/href=.*?z80dasm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dab82764d4e4e0129f4b06e42c2482a319f4c4611c6ce2863d1ba9d98f958647"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c9fc06c9472c51edb63417a1a810c7a2a640b3d1382e3d22e2eb54e37ae7ef0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ff2f756e6717012ce138b0ec39d30a71080443aa34858f2e96cb86df773d82a"
    sha256 cellar: :any_skip_relocation, ventura:        "3b6769cacc57e6de09e2ab213c1166ef8609f6ed0f4247b6b6b42db34ce04d07"
    sha256 cellar: :any_skip_relocation, monterey:       "9902b06046cfa5e04e06b1ef126c20dfa345432b9c7c0b2ee19f1db0ef9d2aa5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b14f8e49b2e1a7e3ea40bf6f0143b75d4aea3561d9beaccc9526f576893e5a3"
    sha256 cellar: :any_skip_relocation, catalina:       "5012e33c0fc342ec32a22462f9a75897fd69d44cf2918c64a593d268fa365c86"
    sha256 cellar: :any_skip_relocation, mojave:         "0650fc5eadf8ee791201886bd39356af1365f9258c2222e27824fe63500b6eac"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a6d8e1d4caa612567de07580a353c82040e5c8005a08117386633e9a11f0df2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fe1126137b9a2626bb459fd6d67936ba11eacc8428f044f26c5b9cd1af1dd4f"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"a.bin"
    path.binwrite [0xcd, 0x34, 0x12].pack("c*")
    assert_match "call 01234h", shell_output("#{bin}/z80dasm #{path}")
  end
end
