class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lrde.epita.fr/"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.9.8.tar.gz"
  sha256 "b7f404bb90a335a5914384ecc3fc3a2021ff22c57ee97a40c07bb2ab40e20cf9"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://spot.lrde.epita.fr/install.html"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5dbf5d0dedb42c6b09a17138231dbb85de9af3ac848dd3a61f2aa46ac1e7fbf1"
    sha256 cellar: :any,                 big_sur:       "398a47ee8ccc65155f9ab9074a1b7a8d1c4823c111de6fe0502e5d87f5e30d90"
    sha256 cellar: :any,                 catalina:      "6cbe99616b0bde6a2f13f29b9bee34dc8e38a115a854aa9d73ed13e3c3f3e0d8"
    sha256 cellar: :any,                 mojave:        "d0a079961910d2ed596521f43fbc9e05f881d69ef07ed10ceaa366d6de7d1618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24705073b0eafec8b6d70f979ac4fde1d273e7390f5dbacb7c0b1962fb1b9427"
  end

  depends_on "python@3.9" => :build

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"randltl -n20 a b c d | ltlcross 'ltl2tgba -H -D %f >%O' 'ltl2tgba -s %f >%O' 'ltl2tgba -DP %f >%O'"
  end
end
