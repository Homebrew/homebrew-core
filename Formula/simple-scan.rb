class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.36/simple-scan-3.36.3.tar.xz"
  sha256 "7083beab8cb8640225938cda76190abca91093d6960d555505b23930b13c5f3f"
  revision 1

  bottle do
    sha256 "b979d465d9efd3d607ce46103958255ab7b65cc191f7f6d6bda205fc94bc09f6" => :catalina
    sha256 "3d6befb85ce58b752ef00196eb6d2a593d33bc063fb66f0580dddced28692d92" => :mojave
    sha256 "f7dca4b3f325cadd784d0f61b751eb6eb781e00e5810be5b1f5a226dc55dd4a9" => :high_sierra
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
