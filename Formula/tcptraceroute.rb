class Tcptraceroute < Formula
  desc "Traceroute implementation using TCP packets"
  homepage "https://github.com/mct/tcptraceroute"
  revision 1
  head "https://github.com/mct/tcptraceroute.git"

  stable do
    url "https://github.com/mct/tcptraceroute/archive/tcptraceroute-1.5beta7.tar.gz"
    sha256 "57fd2e444935bc5be8682c302994ba218a7c738c3a6cae00593a866cd85be8e7"

    # Call `pcap_lib_version()` rather than access `pcap_version` directly
    # upstream issue: https://github.com/mct/tcptraceroute/issues/5
    patch do
      url "https://github.com/mct/tcptraceroute/commit/3772409867b3c5591c50d69f0abacf780c3a555f.patch?full_index=1"
      sha256 "c08e013eb01375e5ebf891773648a0893ccba32932a667eed00a6cee2ccf182e"
    end
  end

  bottle do
    cellar :any
    sha256 "9cfef78a5c463879ead4822dd364d65edf1161f2d09722954c69ae2a427167d7" => :catalina
    sha256 "27fb840b747841e42dddb71edf57b29a3bae93380bc9f53c19b07fb9307e603b" => :mojave
    sha256 "d8093c6d5e3cc0738753df38332f303704de764942000130be13ee351a32255a" => :high_sierra
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

  def caveats; <<~EOS
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
