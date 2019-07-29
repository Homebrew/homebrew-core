class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.2.0/qalculate-gtk-3.2.0.tar.gz"
  sha256 "b9374d6c253418c8666db29102ff7525b9785a123318702a55c422b70c1b36b5"
  revision 1

  bottle do
    cellar :any
    sha256 "3104ddb1b29fc2d9c39e43e559362ef1b8fdb77973690c53410bd16659114709" => :mojave
    sha256 "64361989afde43f6117ab4f0bed220fb367c7cc5258af6217face7c35c52c60b" => :high_sierra
    sha256 "f64686ea0ecc8a266905ed73def45e1b533f0bb53919e744e2740b6a4477c940" => :sierra
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
