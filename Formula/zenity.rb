class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/3.32/zenity-3.32.0.tar.xz"
  sha256 "e786e733569c97372c3ef1776e71be7e7599ebe87e11e8ad67dcc2e63a82cd95"
  revision 1

  bottle do
    sha256 "cef54fcd5601eb5dd3b563d1a09a6cd83654a2fa46e4a83a3d3c6e6a356fe29a" => :mojave
    sha256 "36cf68d4838890e8d9122109464548a4630da0b06dcf6d4f0976ccf58b99dde2" => :high_sierra
    sha256 "8b06d6cfec84ff39a95aeb4b466c1eb62584ff019ed90331334d243501cc8398" => :sierra
  end

  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"zenity", "--help"
  end
end
