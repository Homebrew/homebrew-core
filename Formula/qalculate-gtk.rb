class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.7.0/qalculate-gtk-3.7.0.tar.gz"
  sha256 "3d83c2abf3d32ef334f7d290b178757b281407aa4f93c9a0131f4b70cfa0dfa7"

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
