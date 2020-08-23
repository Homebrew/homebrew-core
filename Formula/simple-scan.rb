class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.36/simple-scan-3.36.4.tar.xz"
  sha256 "56af18291a7763f763da5f0eded247d2f8ebf9112c286ef89013374969fef525"
  license "GPL-3.0"

  bottle do
    sha256 "4d96fe2a7b628fdbcb4e0133c84a345f6d46a83a17c228927cd78293389ca4ce" => :catalina
    sha256 "3a217de17627f5cacbf6026ad6727c261294a971c1a35d35964d792b74de656b" => :mojave
    sha256 "bd253f65e6ed1569b3eddbf06ad1b700cb4ac5756969bb86fb0d350a9b5c36f0" => :high_sierra
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
