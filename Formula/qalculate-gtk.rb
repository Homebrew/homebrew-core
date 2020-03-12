class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.8.0/qalculate-gtk-3.8.0.tar.gz"
  sha256 "9a2abf5f5c06f6a3a58d41844de7a666d0304c0c261bc2acd1f64ed105a0cd5c"

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
