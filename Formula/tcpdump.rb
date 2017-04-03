class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "http://www.tcpdump.org/"
  url "http://www.tcpdump.org/release/tcpdump-4.9.0.tar.gz"
  sha256 "eae98121cbb1c9adbedd9a777bf2eae9fa1c1c676424a54740311c8abcee5a5e"

  head "https://github.com/the-tcpdump-group/tcpdump.git"

  bottle do
    cellar :any
    sha256 "010248c6714481c459105589cefe45df08e429fcded0ca813ac4a39e3d526ba8" => :sierra
    sha256 "b2d53c0107757021c8ceaf1aab61b672dbdda78b8fccd93010cb012b0537f098" => :el_capitan
    sha256 "ff19d8db068534c16bf57b770c392b4c39d8c1a3a7fab48eef751f3413d86f5c" => :yosemite
  end

  depends_on "openssl"
  depends_on "libpcap" => :optional

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
