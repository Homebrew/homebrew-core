class Tcpkali < Formula
  desc "High performance TCP and WebSocket load generator and sink"
  homepage "https://github.com/machinezone/tcpkali"
  url "https://github.com/machinezone/tcpkali/releases/download/v1.1.1/tcpkali-1.1.1.tar.gz"
  sha256 "a9a15a1703fc4960360a414ee282d821a7b42d4bbba89f9e72a796164ff69598"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e9bbcb12b289d1dff3c2355664208ee0a65cea032ebe1dc0d6d1346f67c1a2f" => :mojave
    sha256 "b82b2ea3a3d17d3fd464a5e887c9cce14dce8a82bbcb350df5f7bd321893bfdb" => :high_sierra
    sha256 "f73513ed96b6436085e0941865f0cc4fd2ce1009a1d8770c740e8e97d5173cf1" => :sierra
    sha256 "2d0075b2fca885fb694660a3914362030be255c8e3dfed407bb8ca96c996bbf7" => :el_capitan
    sha256 "71573c4926d086721c028e73d9812475fe3a58bd8313a43ef9c6a54918334760" => :yosemite
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
