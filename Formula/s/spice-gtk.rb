class SpiceGtk < Formula
  include Language::Python::Virtualenv

  desc "GTK client/libraries for SPICE"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/gtk/spice-gtk-0.42.tar.xz"
  sha256 "9380117f1811ad1faa1812cb6602479b6290d4a0d8cc442d44427f7f6c0e7a58"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]
  revision 3

  livecheck do
    url "https://www.spice-space.org/download/gtk/"
    regex(/href=.*?spice-gtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "9882ec3f69fc197c1ac475ad3422950df499d9b80a7c9bc624817d95506a0fe2"
    sha256 arm64_ventura:  "42600de9d33cc9d1c2e32eccf80cfa14f771457c3c39080d97ff3b611899dff8"
    sha256 arm64_monterey: "82ab9fac4205428b48ea403708e85e19a9a42fd6c64a114a949e773e94367bf2"
    sha256 sonoma:         "5899efc0635b8e80ed5d8500bbfb654aaaf241a457d7a817d51c066f991d73ed"
    sha256 ventura:        "25c6fdcf7449f65c449d4ef7379d80b607c6d6aabc2a5823b4bd0241394e73cf"
    sha256 monterey:       "a553e9a2c8c13b84545376374a8a1418c35bb9aa10baeeb6c536c09c106b7a5b"
    sha256 x86_64_linux:   "7ffdfb8565e07edaa4aaaed8ec4926679bfbe5242b32343e9c97dfe6ff02f69a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.12" => :build
  depends_on "vala" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libusb"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pango"
  depends_on "phodav"
  depends_on "pixman"
  depends_on "spice-protocol"
  depends_on "usbredir"

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  # Backport fix for "ld: unknown file type in '.../spice-gtk-0.42/src/spice-glib-sym-file'"
  patch do
    url "https://gitlab.freedesktop.org/spice/spice-gtk/-/commit/1511f0ad5ea67b4657540c631e3a8c959bb8d578.diff"
    sha256 "67c2b1d9c689dbb8eb3ed7c92996cf8c9d083d51050883593ee488957ad2a083"
  end

  # https://gitlab.com/keycodemap/keycodemapdb/-/merge_requests/18
  patch :DATA

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.12")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    system "meson", "setup", "build", *std_meson_args
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
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["icu4c"].lib}/pkgconfig"
    system ENV.cc, "test.cpp",
                   *shell_output("pkg-config --cflags --libs spice-client-gtk-3.0 ").chomp.split,
                   "-o", "test"
    system "./test"
  end
end
__END__
diff --git a/subprojects/keycodemapdb/tools/keymap-gen b/subprojects/keycodemapdb/tools/keymap-gen
index b6cc95b..d05e945 100755
--- a/subprojects/keycodemapdb/tools/keymap-gen
+++ b/subprojects/keycodemapdb/tools/keymap-gen
@@ -1,4 +1,4 @@
-#!/usr/bin/python3
+#!/usr/bin/env python3
 # -*- python -*-
 #
 # Keycode Map Generator
