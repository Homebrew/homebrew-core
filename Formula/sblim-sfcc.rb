class SblimSfcc < Formula
  desc "Project to enhance the manageability of GNU/Linux system"
  homepage "https://sourceforge.net/projects/sblim/"
  url "https://downloads.sourceforge.net/project/sblim/sblim-sfcc/sblim-sfcc-2.2.8.tar.bz2"
  sha256 "1b8f187583bc6c6b0a63aae0165ca37892a2a3bd4bb0682cd76b56268b42c3d6"
  revision 1

  bottle do
    cellar :any
    sha256 "ff61a006626a9a36dafb474f352d798805b1a44adba341d8422bd0820eaae1ab" => :mojave
    sha256 "0ee558ce892d6e04acfe7ca2408a96e2837c7c858e71f6047b3a57a15b75ece0" => :high_sierra
    sha256 "2e1eea4bbad906293b2c48a27a09fd76d665ab0c9259ef49fcd81f4783fbb67c" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cimc/cimc.h>
      int main()
      {
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcimcClient", "-o", "test"
    system "./test"
  end
end
