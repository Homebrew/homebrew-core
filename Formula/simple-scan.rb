class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/40/simple-scan-40.tar.xz"
  sha256 "49c407e1991677b9f6832d07a5a0c8a9bbf029b3d20d609dc318411e4a02b4ce"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "18cb5a5d20dd69352313d2e2a14ed272d09c58ddf5a3ed8fd4b786be25b3adab"
    sha256 big_sur:       "37c93b97dcaeb03f8bd8522b6828643caee0102f56d844757779c562c01ca08c"
    sha256 catalina:      "ebb1e3c10079ce920defbe258f1241f8c418094f566990a9076b73d467d5c857"
    sha256 mojave:        "7d733dc8188d12eec8d5e36d036e5d56b9dff3f74ea50b386d0f671c94e9ed91"
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
