class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.0.0/qalculate-gtk-3.0.0.tar.gz"
  sha256 "7d18d99c566b44ba88a99daefb1974c244aa33960bd3d80f0e2afa225858553d"

  bottle do
    cellar :any
    sha256 "71df7b69b903eafab4900c08a52e0cd2ad990fc5ebeec64275a6bb90ec8706c3" => :mojave
    sha256 "8847c2018581f8625294d32632732d1f3de80fba59cfe5aac51fd876ffeecbe4" => :high_sierra
    sha256 "b91c5d9d0662c784d3c8db9af35a0551ed57ff127b420c06e95e4f78ccc0e5a8" => :sierra
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
