class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/50/simple-scan-50.0.tar.xz"
  sha256 "cc32b561ae227182d31a94466632e311723756e3ac90538c3c7e2a2c9aaa4a09"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "a869b0d7b8904def7e1054b7dce454df9415cd0fdf6bab2df7d9d3e53a9c1a35"
    sha256 arm64_sequoia: "deec11bead0cda8b1de5cbf92549a2837207ec94c58c5539e4c18590063c0f4a"
    sha256 arm64_sonoma:  "140753330f6fb9150a48ee983da40c620fa6d0c4755716d1c4dcdd8b804ec59b"
    sha256 sonoma:        "14d80b1475f30ae41a55c686f493d05abfd02a3d9df8be916ee75061519139b6"
    sha256 arm64_linux:   "3b07c5ccdde6168b3f39e0be2e8fb73cee7841c64542387f2664e19fac653e0d"
    sha256 x86_64_linux:  "69cd72385ad10852e92f4f3195ba6d52a8ca6c080c892d148a986a89f28ddd58"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "libgusb"
  depends_on "sane-backends"
  depends_on "webp"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Work-around for build issue with Xcode 15.3
    # upstream bug report, https://gitlab.gnome.org/GNOME/simple-scan/-/issues/386
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"simple-scan", "-v"
  end
end
