class Trader < Formula
  desc "Star Traders"
  homepage "https://www.zap.org.au/projects/trader/"
  url "https://ftp.zap.org.au/pub/trader/unix/trader-7.14.tar.xz"
  sha256 "ac9b659496facbd8d062afb4149c870e2dfcb22ba219961b724e6aa460611ee9"

  bottle do
    sha256 "661f7dc5534bda2b721f00c12b868343a762d4f4b2cd8f6c869c2681b7a9c091" => :catalina
    sha256 "1e78bde8014188f21cc16fdf99e52128e3e135031d447c71f1c39fa8d1135b70" => :mojave
    sha256 "8175870d189ac87e617dda58fd61d4cd56109876bc5bf7fe55718ac9db137a27" => :high_sierra
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
