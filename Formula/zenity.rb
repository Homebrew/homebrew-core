class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.22/zenity-3.22.0.tar.xz"
  sha256 "1ecdfa1071d383b373b8135954b3ec38d402d671dcd528e69d144aff36a0e466"

  bottle do
    sha256 "a9503a92fc22a8f73cc00a472413fb693ba0766f324202f8984cd3e60dadc035" => :sierra
    sha256 "ffa980a8e878b69b027fbf1c418196732ad43fab5c37e1ffe72c0884a6b602df" => :el_capitan
    sha256 "9349b8d5c3b3dd4d22e79665389fdf8b6b6b38ecbafed0aad0abe9c22c9175cf" => :yosemite
    sha256 "4f425ef4b8f460ea99a24d495d4a973cbdd0e23c1fa9821b33104ecd2ef0d0c1" => :mavericks
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
