class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.9.2.tar.gz"
  sha256 "798b3536a29832ce0cbb07fafb1ce5097c95e308a6f592d14052e1ef1505fe79"
  revision 1
  head "https://github.com/the-tcpdump-group/tcpdump.git"

  bottle do
    cellar :any
    sha256 "8fdb5a59a18ca1ae658fa29e258f6760343da172c96977a15d13b2309874939c" => :mojave
    sha256 "321254c4ef9c9d005b59bd6ecc2511a6c8444eda92c93f836db4ffecaf4c36c9" => :high_sierra
    sha256 "f383f086f232e06e01c9d206c98f65d9df5109366f13ba684910b8e249e35a6e" => :sierra
    sha256 "10486fd04e4b4df5f7fbd2b9aba3d48c903730c53df3ee9b7f57887db0347df8" => :el_capitan
    sha256 "97fc8337c3808fa208b72f1eea5eea6d53bf67c083ca6b1b3ddf751b8342c574" => :yosemite
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
