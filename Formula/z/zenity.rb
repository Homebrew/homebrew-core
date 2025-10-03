class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/4.2/zenity-4.2.0.tar.xz"
  sha256 "5f983340c6fa55f4fab5a9769d0771b2cdf1365e2c158ac11cc16ffd892f6bcd"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "52f29d134b4bf09038c3b7f4f0f1379bd21ee829afb440ab584d4042fd3cf67b"
    sha256 arm64_sequoia: "6c3c72a9d37c5f11a47a007834398ba25fd8ab52c7b4557df0fa5d296b84a5cb"
    sha256 arm64_sonoma:  "bc4a0c294fd50b6d8df21d76b263a98a2af53028ae7395e20290acb8ddf072f9"
    sha256 sonoma:        "570c7c835edc871f19f4d8f02f9873ab7cd1f6f4b294dc5f3a27935a759ca33b"
    sha256 arm64_linux:   "13e22a75ce878137f853b79c62979fa4a97d06dac6800a8790e2ca5559d5b53f"
    sha256 x86_64_linux:  "795093321177960a0ce270c95951aae4fcfcd8cfd338b883af34e07cac444e27"
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
