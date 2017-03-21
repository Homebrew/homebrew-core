class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.24/zenity-3.24.0.tar.xz"
  sha256 "6ff0a026ec94e5bc1b30f78df91e54f4f82fd982f4c29b52fe5dacc886a9f7f7"

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
  depends_on "rarian"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"zenity", "--help"
  end
end
