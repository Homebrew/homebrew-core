class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.22/zenity-3.22.0.tar.xz"
  sha256 "1ecdfa1071d383b373b8135954b3ec38d402d671dcd528e69d144aff36a0e466"

  bottle do
    sha256 "3445ccc2cc8a7060c28dcf6ebf6b4d077060ed082717620e475d797de01bb349" => :sierra
    sha256 "f8b5923b5824d68b812cc6411b1e64959b29497df2785b5b1167dcc8041999c4" => :el_capitan
    sha256 "e6346233e5fe85fad02919b1571ceef5b94374f0f9f550b638eb35c9b0fc37a9" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2"
  depends_on "gtk+3"
  depends_on "gnome-doc-utils"
  depends_on "scrollkeeper"
  depends_on "webkitgtk" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"zenity", "--help"
  end
end
