class SblimSfcc < Formula
  desc "Project to enhance the manageability of GNU/Linux system"
  homepage "https://sourceforge.net/projects/sblim/"
  url "https://downloads.sourceforge.net/project/sblim/sblim-sfcc/sblim-sfcc-2.2.8.tar.bz2"
  sha256 "1b8f187583bc6c6b0a63aae0165ca37892a2a3bd4bb0682cd76b56268b42c3d6"
  revision 1

  bottle do
    sha256 "e4f4705965c06672a0143381756c57445df47afb3873eafd1669b338796ba118" => :mojave
    sha256 "f13c6b2ff6cd3556066cf8638332b70edb816cde52795d4461ec831d4af42a94" => :high_sierra
    sha256 "38bcd42d05b8c3852bb886a40809fdec6ffd455fcc28673f85558d63d7ef89d7" => :sierra
    sha256 "09bb716962c8e89312fc17448dbe600b27537cfec933e9792b2b988c91a10aed" => :el_capitan
    sha256 "6d2ececce1f13c1b74ee7497f6a2319408fcf14e0c48660056fafc3216f9b23b" => :yosemite
    sha256 "0a121e50395af8c870c05108a67bcc9019c754fe0ca7eb5bd5efd2638fcac416" => :mavericks
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
