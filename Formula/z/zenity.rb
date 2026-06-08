class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://gitlab.gnome.org/GNOME/zenity"
  url "https://download.gnome.org/sources/zenity/4.2/zenity-4.2.2.tar.xz"
  sha256 "019186a996096ef4fc356e21577b5673f5baa3a29ac8e3d608b753371c18018d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "2321c1402561eb6d0ec1f3af4fd3f67a185d6c46b77c592b33c3bd5c1ebbdcba"
    sha256 arm64_sequoia: "f0d8890a0793c6d4b601a9f15b4b5d4a1f013259d9871c0ee161f08a537be304"
    sha256 arm64_sonoma:  "922cb43d744d529e2c72efa70b676890eb1acef6f4a1889372b3820ccb1a9246"
    sha256 sonoma:        "f347e55e1618ec44572b8646cc875180cce1ef003b77166c1d643ab0d32444c8"
    sha256 arm64_linux:   "90306b1c235fa9621527f6c9cd86c245780aab336faf75b3ed132f00f5b16955"
    sha256 x86_64_linux:  "be6ad7ce4ea3b7e74785d386c196c7cc2808efe951d2b9d13466162d8679545e"
  end

  depends_on "gettext" => :build
  depends_on "help2man" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-f", "-t", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    system bin/"zenity", "--help"
  end
end
