class Xbitmaps < Formula
  desc "Bitmap images used by multiple X11 applications"
  homepage "https://xcb.freedesktop.org"
  url "https://xorg.freedesktop.org/archive/individual/data/xbitmaps-1.1.2.tar.bz2"
  sha256 "b9f0c71563125937776c8f1f25174ae9685314cbd130fb4c2efce811981e07ee"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "956bf2491fe98f2a798c8f871e0db64af5a2b749829798f23de023a09d33e313" => :big_sur
    sha256 "1cc01271ed45504647146e223b2e9311feff791fcc36f3f4fde6823ae0248917" => :arm64_big_sur
    sha256 "1f2ba4ed5d9c1347ae66b5721a0fc91fd63332a1602b6e6fd0899491e5e33bb9" => :catalina
    sha256 "012d091ea559b0d3fae3449d1f18b2ea05beb3ac2363b3bd67d5b27bc3b4567e" => :mojave
    sha256 "2f3a3dbeeca8256a15c7902b5028791706cc999d9d7e1e080a940aa68c0622b9" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <X11/bitmaps/gray>
      #include <stdio.h>
      int main() {
        printf("gray_width = %d\n", gray_width);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}"
    assert_equal "gray_width = 2", shell_output("./test").strip
  end
end
