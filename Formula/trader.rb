class Trader < Formula
  desc "Star Traders"
  homepage "https://www.zap.org.au/projects/trader/"
  url "https://ftp.zap.org.au/pub/trader/unix/trader-7.16.tar.xz"
  sha256 "7fced3adfe61099679cec67dd7d7187314b0f6d4378a4aece1a1b5eab9f81ef2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "cacf85ddfc82657267a51c2a6159b0b5f4f5f26029bc32a5cdf895e433578158" => :big_sur
    sha256 "04f065f3b4f8cc435bc4cd005efac64d3c106538b5f3261a70dba73ffb34d57b" => :arm64_big_sur
    sha256 "f88445380e3d80b13e99a9c8c657609941a3f696be2e5039521b1d0a847f03c6" => :catalina
    sha256 "55412b011ce76032c044f0a5839ee05f8b26ecd45471f79b1862a91c2fdc0011" => :mojave
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
