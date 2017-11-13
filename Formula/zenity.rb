class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.26/zenity-3.26.0.tar.xz"
  sha256 "6a7f34626dd62b751fe22bcdb32f3558f8a8fdddcc9406893dd264f0ac18e830"

  bottle do
    sha256 "8d21567ffffb86f7345993dcc93a865ded92d2df181dfa8c65f9e35fd7beaf00" => :high_sierra
    sha256 "618ff56a163ed4094c60339853ab76492e8bfec46250a41a94258c13a09b38ed" => :sierra
    sha256 "07292dedf997e00cf082909b10ba11d1aabf6ca82b1c1832808f31d34377781b" => :el_capitan
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
