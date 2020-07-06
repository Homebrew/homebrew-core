class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.36/simple-scan-3.36.3.tar.xz"
  sha256 "7083beab8cb8640225938cda76190abca91093d6960d555505b23930b13c5f3f"
  license "GPL-3.0"
  revision 2

  bottle do
    sha256 "aeef2e94520f6d1cc563a1d5f74792ad85ddacfce1888f9441a0c020ef6b99b2" => :catalina
    sha256 "273399430d9cec668be18c74b27204483c3135b740b56923dc1b26ebee889038" => :mojave
    sha256 "7fb0684ace98012471a2bb86afeb176723f0fc505c0b30bc3dc39feff0cd5356" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgusb"
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
