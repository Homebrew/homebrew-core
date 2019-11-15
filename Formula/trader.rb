class Trader < Formula
  desc "Star Traders"
  homepage "https://www.zap.org.au/projects/trader/"
  url "https://ftp.zap.org.au/pub/trader/unix/trader-7.13.tar.xz"
  sha256 "0d2b51134166b0f436dc6423e2ce378b1df929a9de141c002f3da86af18bb262"

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
