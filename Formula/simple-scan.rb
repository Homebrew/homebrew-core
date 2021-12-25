class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/40/simple-scan-40.7.tar.xz"
  sha256 "7c551852cb5af7d34aa989f8ad5ede3cbe31828cf8dd5aec2b2b6fdcd1ac3d53"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "f97c15f31b2e0b01343e8a2a592bc58c72af004eb0ece145758f281ec89f7517"
    sha256 monterey:      "afe2be4194d85e537dcdcaa6513b1bc1b24524d653a5e40fb205758834bc59c4"
    sha256 big_sur:       "5b871f8048b6a573e95a63b36f354892ccf0f36e0ec091d69e5021ae7c414896"
    sha256 catalina:      "c1e3a573b9caf82b04e8646111c6bbe596af0f8c16b8d28f8a12388bbb431310"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgusb"
  depends_on "libhandy"
  depends_on "sane-backends"
  depends_on "webp"

  def install
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/simple-scan", "-v"
  end
end
