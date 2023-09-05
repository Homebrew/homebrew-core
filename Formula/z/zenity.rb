class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/3.44/zenity-3.44.2.tar.xz"
  sha256 "3fb5b8b1044d3d129262d3c54cf220eb7f76bc21bd5ac6d96ec115cd3518300e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "c0b0ac6cec4da4681d28476a5bfd07c0f84e4f073a2d24a6ebe27193ff1a5ebd"
    sha256 arm64_monterey: "145ec5865fcc3a89b28452ed75b85caa7d01bfca48817c57c812ebcebdcd429d"
    sha256 arm64_big_sur:  "e3d87028cdb1e46a8eb9dbb73644b79d6f04b31fa2e2da7389194c3710b2c8ed"
    sha256 ventura:        "f0c1669993685f85c6dbf4c43300199bc8bc52dfb0f73e36ab15bfc4dac00a3b"
    sha256 monterey:       "6a763e9bcdd607de9a97a0ec0f8a97712b47c5f08c216e3bf04a19b09140d7e2"
    sha256 big_sur:        "644ff4070c986e618f1f9d4eb75dc4cca5eff5f573d3a7cfb0d6ab3a5400ee0f"
    sha256 x86_64_linux:   "9dda53018379e140debc4d58d1ed640af76f454f536c4ada4753e9039d84e31f"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+3"

  def install
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # (zenity:30889): Gtk-WARNING **: 13:12:26.818: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"zenity", "--help"
  end
end
