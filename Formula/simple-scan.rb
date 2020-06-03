class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.36/simple-scan-3.36.3.tar.xz"
  sha256 "7083beab8cb8640225938cda76190abca91093d6960d555505b23930b13c5f3f"

  bottle do
    sha256 "db3cf85d32cf035c1f7daa678fe13eb15660186393c344e82c465d67a60108b3" => :catalina
    sha256 "14d429be0237bb789dff75ba1d9b30365802a1c6cf5c833c426490769ebf85cb" => :mojave
    sha256 "c334c796d131d6c64e4f778526a07c3ae64121fb7bd80eabda28e7cbed6a48a4" => :high_sierra
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
