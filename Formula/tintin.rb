class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.05/tintin-2.02.05.tar.gz"
  sha256 "63a70052122d24d69d7bc012395745f1a0412dffd456a8e8aab85704d44bd5a1"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7a78cec1a95d75d2c20e6c9933392bdaf08dfa841eafc870f60a61c1108d97bf"
    sha256 cellar: :any, big_sur:       "a69c772325b8928eedd4ff78ec5cb4323f69b4db40fcc359df9c7f17b472d5ca"
    sha256 cellar: :any, catalina:      "4eefe2f0705d71ad16e7b8a9f1e8fd842491802872e922464596397279733cc4"
    sha256 cellar: :any, mojave:        "7c12735502e074ad90cd25dc7baefa6af0a9f2aa5b3d21107710f49f0f8e06fd"
    sha256 cellar: :any, high_sierra:   "c2bb4a0a89b2c1706c5491bf6b62ab14e321822b23bc0c29cc33e6cfd7f1ece4"
  end

  depends_on "gnutls"
  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tt++ -V", 1)
  end
end
