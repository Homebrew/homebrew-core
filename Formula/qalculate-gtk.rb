class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.14.0/qalculate-gtk-3.14.0.tar.gz"
  sha256 "704dd3a98b47e0a84eb61b80c50cd6c445b37a1d28c1b1c271d7aef3592657e7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "f59d3a509ea6a810c6e3c597ec795605cfb0044739f9b56b9e4ab4481fb8c160" => :catalina
    sha256 "d6794890c548b3242404c13e6aee2cf5b3617ec71217f8c09683d485f476e03f" => :mojave
    sha256 "bf2dcb1ea0f504d564df1cd9469bd6964d690a58bff5466840ba9f9cb32eef62" => :high_sierra
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
