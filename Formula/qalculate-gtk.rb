class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.8.0/qalculate-gtk-3.8.0.tar.gz"
  sha256 "9a2abf5f5c06f6a3a58d41844de7a666d0304c0c261bc2acd1f64ed105a0cd5c"

  bottle do
    cellar :any
    sha256 "bf48deba205450fdfbf1ed37cc592f39d86e312f7b31d48a15c9d895a6dcc818" => :catalina
    sha256 "f98903cc87ff3c4959b05b0f515480f1e04fb161d68c7b7ae9337cf19e177863" => :mojave
    sha256 "84ae3fbe793f117ac47856a0c65fee19ce07981d7ad5592de36a0bd75afb0b5c" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
