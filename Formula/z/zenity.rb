class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://gitlab.gnome.org/GNOME/zenity"
  url "https://download.gnome.org/sources/zenity/4.2/zenity-4.2.2.tar.xz"
  sha256 "019186a996096ef4fc356e21577b5673f5baa3a29ac8e3d608b753371c18018d"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b422f8fbb0db0178eaaa88fb933b6aa56596fb2b5e4d97fdc44b3902b7b3238f"
    sha256 arm64_sequoia: "f675d793af98c544a41763e2529a3295acf5f6bd8a8927af64d500c1446f232d"
    sha256 arm64_sonoma:  "27fcad4be82fc8df064bb7c8fce661f5b67a076abd0ae5982e9674d58f862bfc"
    sha256 sonoma:        "1c136a28e692837d869415cdee79486aa311e9e41e0f31b50791b3c00b27f0e8"
    sha256 arm64_linux:   "4eb09a52b20d1bd2628c94d98bf14875e6289a8c36c478a9f94ef0bf8693d84c"
    sha256 x86_64_linux:  "af058999ac5669aa10f134317a390c83a017a0a515efe2892279cc7144b0ee9e"
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

  post_install_steps do
    update_gtk_icon_cache
  end

  test do
    system bin/"zenity", "--help"
  end
end
