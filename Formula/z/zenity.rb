class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/4.0/zenity-4.0.1.tar.xz"
  sha256 "0c2f537813b10f728470d9d05d6c95713db2512f9c95096e1e85b1a6739605e6"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "212ea8114fd4a8194d54901b7ffd39c0775596635c6d43d96792cee3f5d58c6f"
    sha256 arm64_ventura:  "17e3166e2e29d183fd28e6698507363ece6abd27f9a4bbed174078946340d924"
    sha256 arm64_monterey: "98b08d8479d72e2fda14722591ca57443ad0c8d14e24ad9ac8557f7e68d4c933"
    sha256 sonoma:         "a0181ae41410618b7530b9b001fa8f5173ec7201d8caa6448e879d2e3be90067"
    sha256 ventura:        "84b0b5d4903ee46ec73daee35c78c77dd5ccee2b8f7b09e3d3b5617d95f0625b"
    sha256 monterey:       "689624fa6e714ea580b2e88d1a22fdd1b1fa512e8f278fe2383b3b0b0ecb8384"
    sha256 x86_64_linux:   "6721b9d7445e31cb9f9c89d4a9733dee9eb326b0036a13dc37a4480aee992840"
  end

  depends_on "gettext" => :build
  depends_on "help2man" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libadwaita"

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
