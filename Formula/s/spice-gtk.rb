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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "71bee35673de1e8a8025679ea029a208ffc091a5a288a452ee290b6c919cf14b"
    sha256 arm64_sequoia: "2dd197fba5cb101927055736fe8cf58d926b9a6935b874993c73d5795dff464e"
    sha256 arm64_sonoma:  "3b95e14628762b0ef7967d239741aaabfcc9a22a32d14979af37969531703bc7"
    sha256 sonoma:        "8eb8bfcf89f624432c2fe2255d2d15524c97381ffdcc21e4ab580f609bca9ed3"
    sha256 arm64_linux:   "6dad0e797da0b6177b2186408a79fd20c9b5fa48836be158553d0324de554e45"
    sha256 x86_64_linux:  "ae75bbd8abc31001852903eb5d0e79afcf5a61255d6fabd13db7dfe7387341cc"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
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
  depends_on "libepoxy"
  depends_on "libsoup"
  depends_on "libusb"
  depends_on "libx11"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pango"
  depends_on "phodav"
  depends_on "pixman"
  depends_on "spice-protocol"
  depends_on "usbredir"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gobject-introspection"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "libva"
    depends_on "wayland"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  # Backport fix for "ld: unknown file type in '.../spice-gtk-0.42/src/spice-glib-sym-file'"
  patch do
    url "https://gitlab.freedesktop.org/spice/spice-gtk/-/commit/1511f0ad5ea67b4657540c631e3a8c959bb8d578.diff"
    sha256 "67c2b1d9c689dbb8eb3ed7c92996cf8c9d083d51050883593ee488957ad2a083"
  end

  # https://gitlab.com/keycodemap/keycodemapdb/-/merge_requests/18
  patch :DATA

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.14")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <spice-client.h>
      #include <spice-client-gtk.h>
      int main() {
        return spice_session_new() ? 0 : 1;
      }
    CPP
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["icu4c"].lib}/pkgconfig"
    system ENV.cc, "test.cpp",
                   *shell_output("pkgconf --cflags --libs spice-client-gtk-3.0").chomp.split,
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
