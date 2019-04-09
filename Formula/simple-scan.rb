class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.32/simple-scan-3.32.1.tar.xz"
  sha256 "b3626ecd42868df06a3d8aecd0cdd7c3181e4421685f89ec00f8685d29bf9cb7"

  bottle do
    sha256 "8f5ac286207e221308ce8bfd7144e8117be9a069f6aad94a9c7ae30da8c30f9a" => :mojave
    sha256 "7c34dc8155ce02d933646f9854362a5b38cad019a297e31ee80abc37a15f3a23" => :high_sierra
    sha256 "657c53aefd1cbb40d28e242d1630c157d8a943aba1c31743ada52fa1365479d2" => :sierra
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
