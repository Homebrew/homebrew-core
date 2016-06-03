class Skalibs < Formula
  desc "Small and secure general-purpose library for systems programming"
  homepage "http://skarnet.org/software/skalibs/"
  url "http://skarnet.org/software/skalibs/skalibs-2.3.10.0.tar.gz"
  sha256 "e4d5147941055b2a367794666f773a4b216c3ae83c015a5fcf2cd0498470ea44"
  head "git://git.skarnet.org/skalibs"

  def install
    system "./configure", "--disable-shared", "--prefix=#{prefix}", "--libdir=#{lib}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <skalibs/skalibs.h>
      int main() {
        goodrandom_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "#{lib}/libskarnet.a", "-o", "test"
    system "./test"
  end
end
