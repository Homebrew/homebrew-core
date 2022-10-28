class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lrde.epita.fr/"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.11.2.tar.gz"
  sha256 "3e63458f0da4863e1cd0d2cfe851a1015d322205d7e406c6a9d95680b9ea754e"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://spot.lrde.epita.fr/install.html"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ecbe5a528c52ea17b1515a385a3ca9ee9dbcdaff429c2c77f106bd1e21dc72af"
    sha256 cellar: :any,                 arm64_big_sur:  "a1c00fce9f54d4de1daf8c18e33e5f7b55a131511ee3004e654e319b5c535dc3"
    sha256 cellar: :any,                 monterey:       "53992a2350103a44b6d0b9421da6548ab806223345ad75babff2d718fde39139"
    sha256 cellar: :any,                 big_sur:        "c75afe336e8ee43ade8eadb7c6d398e4395ccd705cb47428762a5650c9d40833"
    sha256 cellar: :any,                 catalina:       "f3ac4a91ded54f3c5343e8591cba5ff3aa7e3fa39b8ee4df4bbff71940cf81f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "802afd5354c80e5964aa606e61a54d98785d67177821aa80b98518f32dde42d4"
  end

  depends_on "python@3.10" => :build

  fails_with gcc: "5" # C++17

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"randltl -n20 a b c d | ltlcross 'ltl2tgba -H -D %f >%O' 'ltl2tgba -s %f >%O' 'ltl2tgba -DP %f >%O'"
  end
end
