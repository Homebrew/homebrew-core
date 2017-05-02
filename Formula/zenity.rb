class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.24/zenity-3.24.0.tar.xz"
  sha256 "6ff0a026ec94e5bc1b30f78df91e54f4f82fd982f4c29b52fe5dacc886a9f7f7"

  bottle do
    sha256 "67b736d9989fe2985ae58ad381259dddca8ed1a60e0f26a3f4f830d932b44f74" => :sierra
    sha256 "97992076a537ea495dc2f17d3f5e6484d4fcdb805f0ce0f8a6e4284b9f11f84c" => :el_capitan
    sha256 "07a58ac59c867e6db9f367ee6d516bde31a1fa78d4861b42b5d2147e870e32cc" => :yosemite
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
