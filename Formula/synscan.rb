class Synscan < Formula
  desc "Asynchronous half-open TCP portscanner"
  homepage "http://digit-labs.org/files/tools/synscan/"
  url "http://digit-labs.org/files/tools/synscan/releases/synscan-5.02.tar.gz"
  sha256 "c4e6bbcc6a7a9f1ea66f6d3540e605a79e38080530886a50186eaa848c26591e"
  revision 1

  bottle do
    cellar :any
    sha256 "df49f836a6552dfba8d127e53d4a87cf50030c63ab906dd1f5c40f549d32bf86" => :big_sur
    sha256 "86677760d68a0a9efc11560003b4291ff8510b55a03f76a06916c989ec1aa428" => :arm64_big_sur
    sha256 "0e99e8f964f270377bd7dc6c0ecfae64682f3b2831776d7723f200c159623ac6" => :catalina
    sha256 "aba139d4f46b1248a796f26dccb6399fd6f6eadd94b7777f5218d3a0599f0bad" => :mojave
    sha256 "4364e517dd2b231cd711be4ccebdfe802e1ef6f7cacfaff46e987790c90c21f8" => :high_sierra
  end

  depends_on "libpcap"

  def install
    # Ideally we pass the prefix into --with-libpcap, but that option only checks "flat"
    # i.e. it only works if the headers and libraries are in the same directory.
    ENV.append_to_cflags "-I#{Formula["libpcap"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libpcap"].opt_lib} -lpcap"
    system "./configure", "--prefix=#{prefix}",
                          "--with-libpcap=yes"
    system "make", "macos"
    system "make", "install"
  end

  test do
    system "#{bin}/synscan", "-V"
  end
end
