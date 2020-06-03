class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.36/simple-scan-3.36.3.tar.xz"
  sha256 "7083beab8cb8640225938cda76190abca91093d6960d555505b23930b13c5f3f"

  bottle do
    sha256 "f574cc961086f08bf3bfd6847808ea2d5680c5b3787c8481a8be436eb0ea7a94" => :catalina
    sha256 "c5f8fcc760969a1973e42c8d3bde7cf0aef1a0f86ee011a6c530949b45b55555" => :mojave
    sha256 "1f41f244e49cb45b4e2858f4b98fdf33c10112f2f3e1ba3334fedd2fdcf87b9b" => :high_sierra
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
