class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/4.0/zenity-4.0.5.tar.xz"
  sha256 "8a3ffe7751bed497a758229ece07be9114ad4e46a066abae4e5f31d6da4c0e9e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "e3959aa7b0410e54ec42687ce2a267f325127e4df4d481443c8698c7b953597f"
    sha256 arm64_sonoma:  "06acbffe1ce25cdb54a3714c6070ffdd0ef0001ad7df3368a5b5a42a746ba676"
    sha256 arm64_ventura: "11d64f18431ced3cfb4f78931fedc625e0466482232ef3f56694c01b8fdd1642"
    sha256 sonoma:        "33696f8b90ab2a67e2c60b8bc7d0b721898d83dff290435bc00f8ca6752a2b51"
    sha256 ventura:       "19762a7234eeed23c97d15ab8e6fdc9c87e1685f08140711b71208c1d4ccc113"
    sha256 arm64_linux:   "138458db0aa0ad29953535b8ca9d5695851002c335c70bca7e3694d9b7ee2db7"
    sha256 x86_64_linux:  "f9aa253c650051ee899f78c3bd4c616677e9e14945f893c408c73c5258b8f1b0"
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
