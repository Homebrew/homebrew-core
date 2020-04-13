class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.9.0/qalculate-gtk-3.9.0.tar.gz"
  sha256 "b5431d3f61ba7f37dae91b2071ee4dcc7616b1c93583b6efd5591394cd911833"

  bottle do
    cellar :any
    sha256 "07f2cb48108fb02647c986c6222bc4e1feceb9cf4866dbf274eeaaed87b60aa2" => :catalina
    sha256 "4e9b218aa06fa8bd7f779c67b4987dc5005c2efb5cd1c9b02164ce9574f65f41" => :mojave
    sha256 "e389af36255b8fdd7f9f4f66f3bc433c45c495405234378339977915d996f8a0" => :high_sierra
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
