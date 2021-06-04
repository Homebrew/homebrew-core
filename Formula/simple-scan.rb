class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/40/simple-scan-40.1.tar.xz"
  sha256 "ebee39ab1fe4ca053c4ed2bd3a3ca76742ff109436dd0645d3415622132ba0b4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "a3682dd1d9b1f0c33f523469d8971286c6cb4300ae82eb31825bcbc0d2fd21c0"
    sha256 big_sur:       "73592584299577d4567501ff336cb23ce39b1a7d74bfc05cbb22e74326a2cec8"
    sha256 catalina:      "7a0a0234992e2dcb3e650d492456fc17bf0400c2bc36a99f4d8d3b011e0096f6"
    sha256 mojave:        "47d31029f77ad42d17899786c4159201a5536227ffe52942b1ea490dcd9a8c7c"
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
