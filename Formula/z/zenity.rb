class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/4.0/zenity-4.0.2.tar.xz"
  sha256 "c16dcae46e29e22c2fa0b95e80e06c96b2aec93840161369c95c85ed9f093153"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia:  "236de42b38e56b0c28c42735ea43e13e407967fb1e0b35c230d2c5bb78b86fbe"
    sha256 arm64_sonoma:   "324af3731f3817b139c002ff323090fc082a0fd98d62bf7111301a9bf6b6315f"
    sha256 arm64_ventura:  "ced590fb6362f41d1ceb9783aa9ed4355991119d7775e13b5c7ca3a9ebc528b2"
    sha256 arm64_monterey: "f8f09e214c8a87f2b4b123047657e12d355a14d2c95def2b9f52f9dd5fecc04e"
    sha256 sonoma:         "90746002a9d277c8a59657a992f207cc3de2930ec3ad348883d1fc9d7f2f5bfb"
    sha256 ventura:        "df30edd6cadf89bad689859f1109f3a600631ee7ddbbf1c897ddae880e01e6ac"
    sha256 monterey:       "fb144d3c4bb1933b812a71e17a61f042c590134fe751f7be878e89187d540543"
    sha256 x86_64_linux:   "3b1e00581cd9fb4b0fa0506018c864ba34cb5a4a5db6fd67dcd06b60c7ea88d0"
  end

  depends_on "gettext" => :build
  depends_on "help2man" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

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
