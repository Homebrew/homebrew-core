class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/3.30/zenity-3.30.0.tar.xz"
  sha256 "995ef696616492c40be6da99919851d41faed6643a97c9d24743b46bc8b537f2"

  bottle do
    sha256 "1f45ac15943a7b3493d7833072c253ffa5158aa124fcc734c890f5906496396b" => :mojave
    sha256 "ef38b762ac8036cf3055f772b661c856e04a387c5e29b4be9b108e5b19485b17" => :high_sierra
    sha256 "6efdbda681d0357aa8da3cd76fb047d2c66745b75b05a388cc56da5e7e0c5b46" => :sierra
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
