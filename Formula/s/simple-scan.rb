class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/49/simple-scan-49.0.1.tar.xz"
  sha256 "e19762422663ef4bf5d39f6e75f4d61a8de1813729a96e57e04e81764e01eae2"
  license "GPL-3.0-or-later"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "cb3f3dcb3c1bc1845f225171d565c82657b3c0c02a563a8a2de56f3e656b077f"
    sha256 arm64_sequoia: "9922b64640db02308c06310cb75efdafb695a7aaf5f51b3e4c00bec38625f10a"
    sha256 arm64_sonoma:  "361657cb356b2464dbbb47fb47bfa1d122be68de0b8da4f9b685923f39564acf"
    sha256 sonoma:        "4ae5086c8bad299106ff23496bc563c71f39c6b1cdd90eb9acb67cd97790e981"
    sha256 arm64_linux:   "25456695a570e01e052695a520bda21345f98ff9b6e50e90de37cda901e14bad"
    sha256 x86_64_linux:  "3e6101666c02eb2e173ee8c7e658685e5132711cf6f9422a27680f7604299d2d"
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

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
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
    # Errors with `Cannot open display`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system bin/"simple-scan", "-v"
  end
end
