class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/49/simple-scan-49.1.tar.xz"
  sha256 "9ae8d4151ecaf95845eb9f99b436d579c838f2cf02763fba3bc03780251be334"
  license "GPL-3.0-or-later"

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "e4ff2b33c03720942a9e4c85ad6a67aab642a4c0cf4e2610b9d2bdf61ef666a3"
    sha256 arm64_sequoia: "5d23ebaecaee138bf8a565355a24986fe50d5a4624b51930245cf97e75702f29"
    sha256 arm64_sonoma:  "24679c9f519ee2748eaef1b614ddfc1323df7d563f469532fde0b7bbf1d23e7e"
    sha256 sonoma:        "86788fde5e41cbb727c779c41e7b00c6203d131dfa0860aeda940bd2169465b0"
    sha256 arm64_linux:   "6df30f86f56028f2e0060011a0271f51d224e88226c0bc4c679c907a1cc14ad7"
    sha256 x86_64_linux:  "e852c24277cf7a2e93d7730ce61de3faf5a0c3488ba26886bf32c71e3d742148"
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
