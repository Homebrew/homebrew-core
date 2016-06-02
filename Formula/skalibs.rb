class Skalibs < Formula
  desc "Small and secure general-purpose library for systems programming"
  homepage "http://skarnet.org/software/skalibs/"
  url "http://skarnet.org/software/skalibs/skalibs-2.3.10.0.tar.gz"
  sha256 "e4d5147941055b2a367794666f773a4b216c3ae83c015a5fcf2cd0498470ea44"
  head "git://git.skarnet.org/skalibs"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc4f891c577321667b9fa4d82752988f015f32b37ae7b41e4bde8c5d2a85c6c2" => :el_capitan
    sha256 "32700c7d0d9ed0e0cf46da3bc53427870721943ac2ed4f19e82bc75e4a49352e" => :yosemite
    sha256 "ae99d4adc208fd8df8fd00c21e6d27713686cf954934d7508c56c2bc5b926aee" => :mavericks
  end

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
