class Tcpkali < Formula
  desc "High performance TCP and WebSocket load generator and sink"
  homepage "https://github.com/machinezone/tcpkali"
  url "https://github.com/machinezone/tcpkali/releases/download/v1.0/tcpkali-1.0.tar.gz"
  sha256 "ac0a7fe686824a8296494d7f7d4bf0dda5e4b6f9320d7ec7f3398e631bd325ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "b18665fbfe27ebb7d9613753c63ca7aedc0a51ed9e6409111ffd332ed11bc25d" => :sierra
    sha256 "2ebc6fd13a75a2b95bde049906d1cd3af1b406f256ad7490a113538d5228892d" => :el_capitan
    sha256 "d37c5e39ec28c5f9a73e3ae023418f0009e9a4c59a82dffc4fd936259db75853" => :yosemite
    sha256 "7dbf2ecc4c3b259693ff338cb6f8db6f4025afde3cc93bcf36ad8419c5ade959" => :mavericks
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
