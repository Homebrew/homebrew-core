class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "http://www.tcpdump.org/"
  url "http://www.tcpdump.org/release/tcpdump-4.9.0.tar.gz"
  sha256 "eae98121cbb1c9adbedd9a777bf2eae9fa1c1c676424a54740311c8abcee5a5e"

  head "https://github.com/the-tcpdump-group/tcpdump.git"

  bottle do
    cellar :any
    sha256 "18012541c4b00cd8438ee1c2c5a4b465821da228ba8239f28bfbeddbd64d0b30" => :sierra
    sha256 "097e031e8e81fa045a0e30e4566051fb689f6766ab39eb1c39ae124dacebc06b" => :el_capitan
    sha256 "b21c9593fe39fff0e7dd9e057a16eaa9686c13fa8a806ac4e0e5f118aa14881b" => :yosemite
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
