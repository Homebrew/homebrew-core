class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "http://www.tcpdump.org/"
  url "http://www.tcpdump.org/release/tcpdump-4.9.1.tar.gz"
  sha256 "f9448cf4deb2049acf713655c736342662e652ef40dbe0a8f6f8d5b9ce5bd8f3"

  head "https://github.com/the-tcpdump-group/tcpdump.git"

  bottle do
    cellar :any
    sha256 "3bf64e9ef9b9f1d4ee995bfbb34184d80f0f86f3436393a36ebee5305e892d98" => :sierra
    sha256 "d4aab0fa975e6e7d3f7abfa76debc7983ef2897903edf7242a7fc7dc6a30a497" => :el_capitan
    sha256 "eaf4b9aa86c5c62daddf828ada08b8ce8f059cb42879a60430ad2cb6e7fe21b3" => :yosemite
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
