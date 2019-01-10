class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.9.2.tar.gz"
  sha256 "798b3536a29832ce0cbb07fafb1ce5097c95e308a6f592d14052e1ef1505fe79"
  revision 1
  head "https://github.com/the-tcpdump-group/tcpdump.git"

  bottle do
    cellar :any
    sha256 "20cff571e2451cfb42455f57bfea31826908b292de526cf81f48186f3a8b61c8" => :mojave
    sha256 "83d5be5d91524f71b9c9c82e38881546397007e6fed48d5524765a59ac91917e" => :high_sierra
    sha256 "5369f6103ea0a3ad291cbc1ee695f0ad0922cf83a709543daad41ef7fda6e01b" => :sierra
  end

  depends_on "libpcap"
  depends_on "openssl"

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
