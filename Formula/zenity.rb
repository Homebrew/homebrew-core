class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.28/zenity-3.28.1.tar.xz"
  sha256 "db179354721fb4e2d5c418e0dc41f09c831a6b2dd440e33f7743dfc266de8a6b"

  bottle do
    sha256 "5dab38ba82de1d4c39d6fa64d2bd5643b255de4f5948ea08b9e5fe8a49329b92" => :high_sierra
    sha256 "a5d79a66c453fd0052794a449fa9c7d1beff2028037149d7449e7227a1f823a8" => :sierra
    sha256 "0ed7b7cad1724fed11fa31f9afbbc327dc00983c84326dc6d944ce73c0c87275" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "itstool" => :build
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
