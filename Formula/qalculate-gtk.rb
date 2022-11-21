class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v4.4.0/qalculate-gtk-4.4.0.tar.gz"
  sha256 "a17f0266196851cb4a55a3ae5a84e1942f9116911495ef141135b6853a4d6fbc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "cbbb3c090eb5761b5382404b3c14c59e24f3e8d83e74cf6226daea4e547b2131"
    sha256 arm64_monterey: "8d0f9c627ae7c7a3f542815374bb945d522cf9dda00d36ab49783b09e2da38d6"
    sha256 arm64_big_sur:  "f5aac8975e22939efde810d95cc705674029553aa149ddefe395029fea23bdbb"
    sha256 ventura:        "44ff49d5c751dfa67706868527ee748de2e0dcc052812e2a2f1dd826e3f1a220"
    sha256 monterey:       "ab9820f60cda731b1d5a51dcdc85961e9e7da2cdb9eba9a802841abd69d2ce07"
    sha256 big_sur:        "d1ed335177b288c8616314a1e42979b3f6d7fd2e8d4c8267cd52ec31d1beb24b"
    sha256 catalina:       "4d77819d1b03197d15da4a2aaff2f3b960225cce5465091bbae4ad9f9379366c"
    sha256 x86_64_linux:   "862814b357589941c5888b04e69b80d468055694d08f2c43c931f5f83807905c"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
