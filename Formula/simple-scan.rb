class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.36/simple-scan-3.36.2.1.tar.xz"
  sha256 "bb8ce5750cd0405e14e4ac8b09f4a587c2fa3a418614ad425a6694c981bb012b"
  revision 1

  bottle do
    sha256 "fb4c476289f457aabb84ba10ebad5c8443c90ebb02df82a1ecf841fe8fbf748f" => :catalina
    sha256 "7897917b47e999882cf5f786eb602f8017e1ae1ee8e9307bcf5bd42d6e2f7a98" => :mojave
    sha256 "17a2f9b27d36bcc054b6192d84af7b6b52c4e46e03a5a20dbcb8720a97c67a5b" => :high_sierra
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
