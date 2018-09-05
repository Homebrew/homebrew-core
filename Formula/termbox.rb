class Termbox < Formula
  desc "Library for writing text-based user interfaces"
  homepage "https://code.google.com/p/termbox/"
  url "https://github.com/nsf/termbox/archive/v1.1.2.tar.gz"
  sha256 "61c9940b42b3ac44bf0cba67eacba75e3c02088b8c695149528c77def04d69b1"
  head "https://github.com/nsf/termbox.git"

  bottle do
    cellar :any
    sha256 "a2d151f7fd74514d23a009b498c5fde9db4a781cd0052386e39a50b054b4cc49" => :mojave
    sha256 "338467da37e0f1a93eda52353d50805b84be1a63135e3979120fe660422a9dd8" => :high_sierra
    sha256 "503690d456e5625825b38dc7513ed8c806e4031de7b22fd66eebe0c66145ec41" => :sierra
    sha256 "84820bcc0a8af2ff453330e8155ca467e2794de179fed4b0238b05635e1fe35a" => :el_capitan
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <termbox.h>
      int main() {
        // we can't test other functions because the CI test runs in a
        // non-interactive shell
        tb_set_clear_attributes(42, 42);
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-ltermbox", "-o", "test"
    system "./test"
  end
end
