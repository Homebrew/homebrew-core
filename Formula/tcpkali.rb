class Tcpkali < Formula
  desc "High performance TCP and WebSocket load generator and sink"
  homepage "https://github.com/machinezone/tcpkali"
  url "https://github.com/machinezone/tcpkali/releases/download/v1.1.1/tcpkali-1.1.1.tar.gz"
  sha256 "a9a15a1703fc4960360a414ee282d821a7b42d4bbba89f9e72a796164ff69598"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cc36bcbb2120334c5d0f0623ae1f81deaf5b43338ce60cde82f271d0adb8732" => :sierra
    sha256 "eb8df1e10fdb4f4f608eb53626ed3cac4fe6960888bf89cccffc85449988a7ab" => :el_capitan
    sha256 "358ce45dd065b2f92e4de1430343d9339d09e21a052d7593d9c308963f36d7d1" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tcpkali", "-l1237", "-T0.5", "127.1:1237"
  end
end
