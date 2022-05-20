class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom.html"
  url "https://download.drobilla.net/sratom-0.6.8.tar.bz2"
  sha256 "3acb32b1adc5a2b7facdade2e0818bcd6c71f23f84a1ebc17815bb7a0d2d02df"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sratom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c94f569e3354515ad380e13a97ad21f9a5ab4cefb3050830393e7637d5d72768"
    sha256 cellar: :any,                 arm64_big_sur:  "922ad15a5f15bf4c54ef685106b70658dce53581ae0ce680e13bc870fc1eab85"
    sha256 cellar: :any,                 monterey:       "64c4dbc36211a45b6d7231ae40ff6c079af3600f15b7527345e09e5062bc363e"
    sha256 cellar: :any,                 big_sur:        "8f20c286f07c722945a6bd3afd0b44ce62dbd0bb39777d90cbeea43b8e65df4d"
    sha256 cellar: :any,                 catalina:       "1ef0da557a528c1b979b78624de2bd6ff6b23beca8918ca94dadc4e5faa7783f"
    sha256 cellar: :any,                 mojave:         "881192ccb8c3553de14975ab6175614170c3cba891760e82d58a1ad194b70269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b85f0783a9f6f3ec8f89962ba0361f83afda28a80c197eabade557684e4a3a69"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sratom/sratom.h>

      int main()
      {
        return 0;
      }
    EOS
    lv2 = Formula["lv2"].opt_include
    serd = Formula["serd"].opt_include
    sord = Formula["sord"].opt_include
    system ENV.cc, "-I#{lv2}", "-I#{serd}/serd-0", "-I#{sord}/sord-0", "-I#{include}/sratom-0",
                   "-L#{lib}", "-lsratom-0", "test.c", "-o", "test"
    system "./test"
  end
end
