class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.9.3.tar.gz"
  sha256 "2cd47cb3d460b6ff75f4a9940f594317ad456cfbf2bd2c8e5151e16559db6410"
  head "https://github.com/the-tcpdump-group/tcpdump.git"

  bottle do
    cellar :any
    sha256 "25b9dd6c81432d2713c8a8642e1d4ac869b7b549b6cc9d435f82693d2d26a58c" => :catalina
    sha256 "3c598caf02f9ca31d2892d9586a35c70400ca2a7895758b72e4672e83b646457" => :mojave
    sha256 "2fc5873438a618ba6140b37ba4e41f7f318b95e0608f17620104146843d99fbf" => :high_sierra
    sha256 "7b57d5f603ed82fb98c58198660596c7418af6b567c964d6873d23eb6629140b" => :sierra
  end

  depends_on "libpcap"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-ipv6",
                          "--disable-smb",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    system sbin/"tcpdump", "--help"
  end
end
