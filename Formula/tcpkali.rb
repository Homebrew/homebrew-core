class Tcpkali < Formula
  desc "High performance TCP and WebSocket load generator and sink"
  homepage "https://github.com/machinezone/tcpkali"
  url "https://github.com/machinezone/tcpkali/releases/download/v1.0/tcpkali-1.0.tar.gz"
  sha256 "ac0a7fe686824a8296494d7f7d4bf0dda5e4b6f9320d7ec7f3398e631bd325ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "d37427e7fff546ae9ffb6bab7c77b275442cf21959ea3111b6eaefa1aef87c93" => :sierra
    sha256 "b1322c09c39a72419660646dd014af6cab694727f382ce784daaed19e6f13322" => :el_capitan
    sha256 "064726e4e45a932793bc61e4cae43b9dfc8631237bd2b6cf713280d3bb66ac5d" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tcpkali", "-l1237", "-T0.5", "127.1:1237"
  end
end
