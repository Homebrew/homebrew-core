class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lrde.epita.fr/"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.10.1.tar.gz"
  sha256 "38002989fc8e3725841a0537665bb2d5dfc259d2e09358100322c38f4c7481ad"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://spot.lrde.epita.fr/install.html"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "621587ea56bb7ef53caeb19814ef20d183e0ea53eccc2023c6b3ac21f3ebc6f0"
    sha256 cellar: :any,                 arm64_big_sur:  "5dbf5d0dedb42c6b09a17138231dbb85de9af3ac848dd3a61f2aa46ac1e7fbf1"
    sha256 cellar: :any,                 monterey:       "04128282f6ab7bc27a99ca5e075b31d6f4e0e2838e381be02507ddb28962dfdf"
    sha256 cellar: :any,                 big_sur:        "398a47ee8ccc65155f9ab9074a1b7a8d1c4823c111de6fe0502e5d87f5e30d90"
    sha256 cellar: :any,                 catalina:       "6cbe99616b0bde6a2f13f29b9bee34dc8e38a115a854aa9d73ed13e3c3f3e0d8"
    sha256 cellar: :any,                 mojave:         "d0a079961910d2ed596521f43fbc9e05f881d69ef07ed10ceaa366d6de7d1618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24705073b0eafec8b6d70f979ac4fde1d273e7390f5dbacb7c0b1962fb1b9427"
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
