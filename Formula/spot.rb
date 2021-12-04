class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lrde.epita.fr/"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.10.2.tar.gz"
  sha256 "c1c4ba4f1c87919b3d2749280c7e9959a7d82a4a43a97a19eca0a3ca22605066"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://spot.lrde.epita.fr/install.html"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e7c158b0ba6b5b4462dcd4b340603b23eb078bab924b452bb50f08b1e9a91291"
    sha256 cellar: :any,                 arm64_big_sur:  "4362a1dd23851be4827437e039e0ddd70f93ac423ac9a0a9cb08221a81726f03"
    sha256 cellar: :any,                 monterey:       "1e8403fd88677c62079417af5b86453160b64b8879f73c3f916d86998ed806c2"
    sha256 cellar: :any,                 big_sur:        "b41a5c9a9d3d43966dd8c6613e557a2bc487c7ae603f8eeacf9aaafc9b440fa2"
    sha256 cellar: :any,                 catalina:       "ba556d5e5db8889281aedf1d97f70b0d8c1fe3f5e4b3b4576c12b0d225b791da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb5c712aed8ea579e258e0dcd964440e61067a6dd063d2ac83a9de8230e77859"
  end

  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # C++17

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"randltl -n20 a b c d | ltlcross 'ltl2tgba -H -D %f >%O' 'ltl2tgba -s %f >%O' 'ltl2tgba -DP %f >%O'"
  end
end
