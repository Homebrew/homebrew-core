class SpiceGtk < Formula
  include Language::Python::Virtualenv

  desc "GTK client/libraries for SPICE"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/gtk/spice-gtk-0.41.tar.xz"
  sha256 "d8f8b5cbea9184702eeb8cc276a67d72acdb6e36e7c73349fb8445e5bca0969f"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]
  revision 1

  livecheck do
    url "https://www.spice-space.org/download/gtk/"
    regex(/href=.*?spice-gtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5376db1c3bb8e411ae9ed385060e294fff92a578235da5890aa0dfee162636ee"
    sha256 arm64_monterey: "ff19af79165ab0f40164ebdda3bfe7f43a10a79031d120fcde0341afc7f384e7"
    sha256 arm64_big_sur:  "d0bb47512168bb6b8d5a0d7f868e4eab2451a93adb3d37b3f0f39d2b82f088e4"
    sha256 ventura:        "b86579acd53e59fe0fa769d3b323450746a41866b2c555471d90ca231d343615"
    sha256 monterey:       "7d447cc1e928a6952f646f2b05baea519ecbaad6004c151394b491515829d894"
    sha256 big_sur:        "006888d49e0de92da7fd8a72e1060b2a1893fd00ed74c797ca79d3f936ea6220"
    sha256 catalina:       "09fecc7a853611827e3ead2512f7db7e7217f8d5040b7761f8be9c33c72879fe"
    sha256 x86_64_linux:   "b7fa19f888be06a726f69c2bc0a12c28b2663f0fc7b72a82073559442e5cc77d"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "six" => :build
  depends_on "vala" => :build

  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gst-libav"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gst-plugins-ugly"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libusb"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "opus"
  depends_on "pango"
  depends_on "pixman"
  depends_on "spice-protocol"
  depends_on "usbredir"

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.10")
    venv.pip_install resources
    ENV.prepend_path "PATH", buildpath/"venv/bin"

    system "meson", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <spice-client.h>
      #include <spice-client-gtk.h>
      int main() {
        return spice_session_new() ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{Formula["atk"].include}/atk-1.0",
                   "-I#{Formula["cairo"].include}/cairo",
                   "-I#{Formula["gdk-pixbuf"].include}/gdk-pixbuf-2.0",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{Formula["gtk+3"].include}/gtk-3.0",
                   "-I#{Formula["harfbuzz"].opt_include}/harfbuzz",
                   "-I#{Formula["pango"].include}/pango-1.0",
                   "-I#{Formula["spice-protocol"].include}/spice-1",
                   "-I#{include}/spice-client-glib-2.0",
                   "-I#{include}/spice-client-gtk-3.0",
                   "-L#{lib}",
                   "-lspice-client-glib-2.0",
                   "-lspice-client-gtk-3.0",
                   "-o", "test"
    system "./test"
  end
end
