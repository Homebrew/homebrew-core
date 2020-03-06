class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.36/simple-scan-3.36.0.tar.xz"
  sha256 "f57d8be3c22f786efe576da04288951664e6f9fa0ec5c79afb5c2c88a11f14a5"

  bottle do
    sha256 "18aac59ffddf44639d9be271ddd6fd45a2dbd43b010e42a9b505a5cd228cd370" => :catalina
    sha256 "318a673d8a28fda2cdfc376fed25efc1a4689d9ba0f61abc7a5d0309c2cfd379" => :mojave
    sha256 "86a1651a7f08f13e1177ef00a6f0296545dcf71d014c8e85a6a450d808c1fab0" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgusb"
  depends_on "sane-backends"
  depends_on "webp"

  def install
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
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
