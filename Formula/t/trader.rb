class Trader < Formula
  desc "Star Traders"
  homepage "https://www.zap.org.au/projects/trader/"
  url "https://ftp.zap.org.au/pub/trader/unix/trader-7.18.tar.xz"
  sha256 "3730b2fedd339adfc34c1640b309b3413b10b3d78969dcd71f07fd76b4514e85"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?trader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "ab997415eaf9d18690f7b83c02f2a8567a450cbdc0eb39ec00fe2a2450eaf555"
    sha256 arm64_monterey: "05137ae01aad4d3949ccc903bc282242ef680133326b93705c9eed49c3c31f3c"
    sha256 arm64_big_sur:  "c7a264790db14499a985beecad69fb0bdc60ebfdcd7bc37ae89a1e93e7a66991"
    sha256 ventura:        "2b5f6d568082f6ac113b347a89fbfafd3bce16108743a9f869d6bc0bd2e81744"
    sha256 monterey:       "3d7d661e7693997d2dc3bbd201052336877a711f1e1591353e9460ab9e33f689"
    sha256 big_sur:        "e33e7a915a9feb528b009426a38b23b7248af58638bc34c19401b637987d561c"
    sha256 catalina:       "bf1590052d948213cb0c7e5fd9ba2b7a328ce09058709cc164dbc3643be6e1e2"
    sha256 x86_64_linux:   "0d82d195c0da5d6db7eb3a095b6a5b061bdb2aa1a2a6a1b8ddfa785e67bf3bd8"
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
