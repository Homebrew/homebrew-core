class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/4.0/zenity-4.0.3.tar.xz"
  sha256 "b429d97b87bd9ce7fb72ac0b78df534725d8ad39817ddca6a4ca2ee5381b08de"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "4f153b28658b7ff4ac99ef77031d0f400e2f0b37f53f86a71011b6939ee0db26"
    sha256 arm64_sonoma:  "d4a16c2b2fe9ec7097c61417db73813b6b2e53fa9c21413e7f4226d74c9248d3"
    sha256 arm64_ventura: "0014365867ccb6ecfb231509a454655a5a2704889d059665dfb53c91c799fd2b"
    sha256 sonoma:        "6dceb146aea04c1cf0df90c6bee53a8a34938ba299e3b001f431509656ff6074"
    sha256 ventura:       "2a15e51a58f5554dffbb3a06fbe106b4e9362d02b9340031d7e5c003dc92958a"
    sha256 x86_64_linux:  "ac173dea0b73c96fd5b9ae4c4abaee499ab44299bd9e479e5e5ebd97d683f4ce"
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
