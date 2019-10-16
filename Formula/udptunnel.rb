class Udptunnel < Formula
  desc "Tunnel UDP packets over a TCP connection"
  homepage "https://web.archive.org/web/20161224191851/www.cs.columbia.edu/~lennox/udptunnel/"
  url "https://web.archive.org/web/20161224191851/www.cs.columbia.edu/~lennox/udptunnel/udptunnel-1.1.tar.gz"
  mirror "https://ftp.nsysu.edu.tw/FreeBSD/ports/local-distfiles/leeym/udptunnel-1.1.tar.gz"
  sha256 "45c0e12045735bc55734076ebbdc7622c746d1fe4e6f7267fa122e2421754670"

  bottle do
    cellar :any_skip_relocation
    sha256 "c015b88af8ac3590aee162c50428bf931a8a15ab006589022bdace7bf665e32a" => :catalina
    sha256 "7923707e0f1851b728643b010aba4b2052e076f935467a1b0ec8ef05d0cbe54b" => :mojave
    sha256 "938663a675b5ef62316fa1f7f4f33895d1b28af656ee722c5f8cf6ba94123f4e" => :high_sierra
    sha256 "c129b87c78c3297365d7e78b77985b69deb4def8d030b029d812bb25610b8bb0" => :sierra
    sha256 "acbc74c384071aa6be92bea754274c5025de0123afd389d1b174e444a7beec42" => :el_capitan
    sha256 "8c4b8fb805fa94098925417a8fa61ced0d546b1b77330fd03cd5a72ee6e43b70" => :yosemite
    sha256 "8f0051f653f62bef0e85f8ced4806a8bae244a911e05129e4fc2bf05912c9412" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install "udptunnel.html"
  end

  test do
    system "#{bin}/udptunnel -h; true"
  end
end
