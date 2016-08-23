class Termbox < Formula
  desc "Library for writing text-based user interfaces"
  homepage "https://code.google.com/p/termbox/"
  url "https://github.com/nsf/termbox/archive/v1.1.0.tar.gz"
  sha256 "2743ee4aeb0ff39fadbaf945b76c43e6f6bba544156f2576282b775a3067d748"

  head "https://github.com/nsf/termbox.git"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
