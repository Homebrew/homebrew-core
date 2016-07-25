class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.20/zenity-3.20.0.tar.xz"
  sha256 "02e8759397f813c0a620b93ebeacdab9956191c9dc0d0fcba1815c5ea3f15a48"

  bottle do
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
