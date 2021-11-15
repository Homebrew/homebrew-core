class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.6.1.tgz"
  sha256 "8d7089979db79a531a0ecc507b113ac6f2cf5f19305571eff1d3413e0ab33713"

  livecheck do
    url :homepage
    regex(/href=.*?spiped[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "27a4be44c3532d6c5fd3c35ad01b6d7b8aeba9430e97cd684f51b386843dd7e4"
    sha256 cellar: :any, arm64_big_sur:  "74e0d5955ee9754f9a88798d8d0c5a2b425756d3359378c312874ccb3959421d"
    sha256 cellar: :any, monterey:       "6bf6ffda856ddf718d621df5810af8b7c7cb2afc7f6d4df8f7b35d5c3a746b6c"
    sha256 cellar: :any, big_sur:        "c245e8cf440207b8a2d229b8f8644ebe25da6999b52f2b8b16835c55b7f04b6e"
    sha256 cellar: :any, catalina:       "efe2a93770708c9a8c1474651b7b0b221d263b7fbb7dc75e014ff21caf084510"
    sha256 cellar: :any, mojave:         "44c1509c5faf96f0be69fd905525e2070cf25445afddfaf45584bd9c4a1d702c"
    sha256 cellar: :any, high_sierra:    "b5615b6afbc743c7b8b2776c3537ec42a4f1519f1f2f3e12bd06ae4e96ce5f14"
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
