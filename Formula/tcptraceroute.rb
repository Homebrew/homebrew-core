class Tcptraceroute < Formula
  desc "Traceroute implementation using TCP packets"
  homepage "https://github.com/mct/tcptraceroute"
  revision 1
  head "https://github.com/mct/tcptraceroute.git"

  stable do
    url "https://github.com/mct/tcptraceroute/archive/tcptraceroute-1.5beta7.tar.gz"
    version "1.5beta7"
    sha256 "57fd2e444935bc5be8682c302994ba218a7c738c3a6cae00593a866cd85be8e7"

    # Call `pcap_lib_version()` rather than access `pcap_version` directly
    # upstream issue: https://github.com/mct/tcptraceroute/issues/5
    patch do
      url "https://github.com/mct/tcptraceroute/commit/3772409867b3c5591c50d69f0abacf780c3a555f.patch"
      sha256 "e7f118f0da011e1f879b8582d17f6f5515d5db491a61d7c71c6f8f71b3cdea0d"
    end
  end

  bottle do
    cellar :any
    sha256 "dd1916233cb76a06e925884f9a1b8e681a181ae3699e0cd7086c5cd8d0c85f43" => :sierra
    sha256 "823a6a2b058ebd9d9a612079d469cbb4bdcc7f3e438c40758836cf7a2373cd00" => :el_capitan
    sha256 "883c29c6037488f13724adddd84c87c0d13e846aaf3a45b1c60206ac091c37fe" => :yosemite
  end

  depends_on "libnet"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libnet=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    tcptraceroute requires root privileges so you will need to run
    `sudo tcptraceroute`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    output = shell_output("#{bin}/tcptraceroute --help 2>&1", 1)
    assert_match "Usage: tcptraceroute", output
  end
end
