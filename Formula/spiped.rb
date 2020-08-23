class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.6.1.tgz"
  sha256 "8d7089979db79a531a0ecc507b113ac6f2cf5f19305571eff1d3413e0ab33713"

  bottle do
    cellar :any
    sha256 "efe2a93770708c9a8c1474651b7b0b221d263b7fbb7dc75e014ff21caf084510" => :catalina
    sha256 "44c1509c5faf96f0be69fd905525e2070cf25445afddfaf45584bd9c4a1d702c" => :mojave
    sha256 "b5615b6afbc743c7b8b2776c3537ec42a4f1519f1f2f3e12bd06ae4e96ce5f14" => :high_sierra
  end

  depends_on "bsdmake" => :build
  depends_on "openssl@1.1"

  def install
    man1.mkpath
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spipe -v 2>&1")
  end
end
