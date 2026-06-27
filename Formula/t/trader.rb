class Trader < Formula
  desc "Star Traders"
  homepage "https://www.zap.org.au/projects/trader/"
  url "https://ftp.zap.org.au/pub/trader/unix/trader-7.21.tar.xz"
  sha256 "541d1180dde04173c071d5c59eaf72a6572f8dfc8065e184eaf7d14bccd0257d"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?trader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "513d2d7550f77217676f2fd6f5514cad6662438f366345104ece54d02ddfcdb1"
    sha256 arm64_sequoia: "614e2e693386cee1c199613821ea87403750a36f5e47074188688a25fcfa4761"
    sha256 arm64_sonoma:  "e60620ded40e5c906306b9a9735a20889ba0b5840852eba97fc87ed9337a464c"
    sha256 sonoma:        "34b3c53eded536df91831ae98f1d9bbdff88f39ada08fd5e65b19be1c33468c3"
    sha256 arm64_linux:   "0a1a6eff6a87ef20356a17073e7b542a498449c4600af0085d0cda06095adc5a"
    sha256 x86_64_linux:  "c8944fa86f8d0758ae1bd4aee2490cb00ead898c5c7afa81cee85013324268fe"
  end

  depends_on "pkgconf" => :build
  depends_on "ncurses" # The system version does not work correctly

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    # Star Traders is an interactive game, so the only option for testing
    # is to run something like "trader --version"
    system bin/"trader", "--version"
  end
end
