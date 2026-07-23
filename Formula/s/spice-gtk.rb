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
    rebuild 4
    sha256 arm64_tahoe:   "21eceed114b1e4ffa0448d21508d99d2c93ae878325b9b51c146ced4181a31fd"
    sha256 arm64_sequoia: "249a4261f91fe205b61e1636440d889def5f5e4aec5ffd19821caf0a9e743dea"
    sha256 arm64_sonoma:  "73b27a8348177262ab9e24628a0139163cfbf8cf264457c504ac1ddd145cbf8b"
    sha256 sonoma:        "aac4c0b6608b911ac73ca8960add7a8bda7f5f3a316f83430b588140c39b011a"
    sha256 arm64_linux:   "2a66a37b796347b663e8f75fafe1f47589c091b9a5267c2f78fbb361ecb0d906"
    sha256 x86_64_linux:  "83c56974836f7c0159133c7058c58fd32b087e2e0fcdd1503abf8c3d86bb55a0"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
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
  depends_on "phodav"
  depends_on "pixman"
  depends_on "spice-protocol"
  depends_on "usbredir"

  on_macos do
    depends_on "gettext"
    depends_on "gobject-introspection"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "cyrus-sasl"
    depends_on "libva"
    depends_on "wayland"
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:   "",
                extra_packages: "pyparsing"

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  # Backport fix for "ld: unknown file type in '.../spice-gtk-0.42/src/spice-glib-sym-file'"
  patch do
    url "https://gitlab.freedesktop.org/spice/spice-gtk/-/commit/1511f0ad5ea67b4657540c631e3a8c959bb8d578.diff"
    sha256 "67c2b1d9c689dbb8eb3ed7c92996cf8c9d083d51050883593ee488957ad2a083"
    type :backport
    resolves "https://gitlab.freedesktop.org/spice/spice-gtk/-/merge_requests/119"
  end

  # Backport six removal
  patch do
    url "https://gitlab.freedesktop.org/spice/spice-common/-/commit/91fc091358ac4906a05b68d70e9db94082c0749f.diff"
    sha256 "dd5ef8701bc1d97c0ff20af9ff95dffc660a5e1a3a8a0a92cd4d643d0a3553ed"
    type :backport
    resolves "https://gitlab.freedesktop.org/spice/spice-common/-/merge_requests/63"
    directory "subprojects/spice-common"
  end
  patch do
    url "https://gitlab.freedesktop.org/spice/spice-common/-/commit/29dacb5f53f5183fb089a3fb02d081dd08bde8a1.diff"
    sha256 "3c8a0adaf4b088986bef7541ffef399c7652969c5584c4a4c4055f4988ef0f7a"
    type :backport
    resolves "https://gitlab.freedesktop.org/spice/spice-common/-/merge_requests/63"
    directory "subprojects/spice-common"
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
