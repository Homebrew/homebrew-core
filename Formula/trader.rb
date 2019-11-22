class Trader < Formula
  desc "Star Traders"
  homepage "https://www.zap.org.au/projects/trader/"
  url "https://ftp.zap.org.au/pub/trader/unix/trader-7.13.tar.xz"
  sha256 "0d2b51134166b0f436dc6423e2ce378b1df929a9de141c002f3da86af18bb262"

  bottle do
    sha256 "f0265ff875601e4d5f9ecc1a4a8bdb903f7399b8cd93a137a17b0f9c78f052ec" => :catalina
    sha256 "656ff27724a844d0059f37977628b5828768ad86a557ae7442365005cbaf535f" => :mojave
    sha256 "6312d15659ff81b39cc0c03a3aff850ea94e112086d6b39a02287f1bf49ad46b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses" # The system version does not work correctly

  def install
    ENV.prepend_path "PKG_CONFIG_PATH",
        Formula["ncurses"].opt_libexec/"lib/pkgconfig"
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-libintl-prefix=#{Formula["gettext"].opt_prefix}
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    # Star Traders is an interactive game, so the only option for testing
    # is to run something like "trader --version"
    system "#{bin}/trader", "--version"
  end
end
