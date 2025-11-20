class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/4.2/zenity-4.2.1.tar.xz"
  sha256 "5a9fd8d8316f90cb2e1a5a8f0d411eb9fcaf85957a8229ea3e803e81004a1ebd"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "8f857e8d696d9295e07f70eb9a5e0cc6cf719075067caa5165533bab70aeac34"
    sha256 arm64_sequoia: "cbd2e29755e0fd5a822c53cdca0e18f219bc1bddd138da1d6ceba8d9d15c1ecb"
    sha256 arm64_sonoma:  "37fc1db7eb6d4eeb9f193fa1b61c9942fbfd7865eb09f8b2db519a5a471ece8d"
    sha256 sonoma:        "ff2b7d1e22f598f6e57b680fd9be996d8bb55986dd4a6498ae4adc7b41402589"
    sha256 arm64_linux:   "5439c7552f08d0dae1241b741ed4ccff7ba6feee581651043badb3cb395f2d53"
    sha256 x86_64_linux:  "7ee597ea5175404f2aad125c99e2dbfc2108933e6e6de537089ce0b2907bc889"
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
    # (zenity:30889): Gtk-WARNING **: 13:12:26.818: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"zenity", "--help"
  end
end
