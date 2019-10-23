class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.9.3.tar.gz"
  sha256 "2cd47cb3d460b6ff75f4a9940f594317ad456cfbf2bd2c8e5151e16559db6410"
  head "https://github.com/the-tcpdump-group/tcpdump.git"

  bottle do
    cellar :any
    sha256 "d4a3781175e0ce1d1a1048a3e211b8775dcec91e362fb51b3384e7404be3b4b6" => :catalina
    sha256 "6cd2cafe6229e2ccb97ba0b636e19a89c9e2f0ec85778910ed55498a30c03eb3" => :mojave
    sha256 "22f03cae37a35d6369292efd2c661f781df8dc21184046e768e13c148dbb3f19" => :high_sierra
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
