class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/50/simple-scan-50.0.tar.xz"
  sha256 "cc32b561ae227182d31a94466632e311723756e3ac90538c3c7e2a2c9aaa4a09"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "30596e583545482e3ed302507f1bf848eb62758e673acd3b9f2512244319c780"
    sha256 arm64_sequoia: "cc55f2d2bd85105945f2d5c9fa45d11d7e3ef0135b8a4981e7ab535df97c8848"
    sha256 arm64_sonoma:  "cee480b30875f61de0f962abaab0c8e8ee881405786af4fcc112885d23c5c85c"
    sha256 sonoma:        "0a33f961743392ae645d5488f16cda857bf93c4d4156f89c6d1f0fb067e40d35"
    sha256 arm64_linux:   "29b8609af62a6d93ce0d13e23f57871281f1fd03e06d330d532ef64c316beb72"
    sha256 x86_64_linux:  "9e044bd94171164c7e90ff3c0ae2765316c250c5ddebe15c0bbb37ec1fae6c2b"
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
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    gtk_update_icon_cache
  end

  test do
    system bin/"simple-scan", "-v"
  end
end
