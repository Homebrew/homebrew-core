class SpiceGtk < Formula
  include Language::Python::Virtualenv

  desc "GTK client/libraries for SPICE"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/gtk/spice-gtk-0.40.tar.xz"
  sha256 "23f5ff7fa80b75647ce73cda5eaf8b322f3432dbbb7f6f3a839634618adbced3"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://www.spice-space.org/download/gtk/"
    regex(/href=.*?spice-gtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b1ab5bfc60085e400a90a30e44d8b4a4f5310b3c5b53097865b10ba2c270b86c"
    sha256 arm64_big_sur:  "33653df442811987bf281eae7be51394129b2640fb934bb83a29aab64e89d9ec"
    sha256 monterey:       "f43ab21e3f982f1957031d112de7e4361e61a3a8c899e04e88bd0ffe1ac75826"
    sha256 big_sur:        "e51c47902eb3a8d5bf146330d3ed7a8965ce66b3d6d425ef5a39ebf4965c3a2c"
    sha256 catalina:       "a6346dd1e7a827900d7dbeaa647588fa56af3dfc72dec3686241eff1f94deaca"
    sha256 mojave:         "512587bfec950e40a3df1f3254427ca736af13c4e222701f32ca7a53c50d4c0f"
    sha256 x86_64_linux:   "396144a5e9cc5e36f459104d59b7223000a8f575596f253b6ead1a2ba8f31f31"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
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
  depends_on "jpeg"
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
    url "https://files.pythonhosted.org/packages/31/df/789bd0556e65cf931a5b87b603fcf02f79ff04d5379f3063588faaf9c1e4/pyparsing-3.0.8.tar.gz"
    sha256 "7bf433498c016c4314268d95df76c81b842a4cb2b276fa3312cfb1e1d85f6954"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", "python3")
    venv.pip_install resources
    ENV.prepend_path "PATH", buildpath/"venv/bin"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
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
