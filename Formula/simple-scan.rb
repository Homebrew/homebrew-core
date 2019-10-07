class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.34/simple-scan-3.34.1.tar.xz"
  sha256 "d827fec3383a565724136b6fda543a94c8f8f161782ac6edf9e91ed6fad49f3e"

  bottle do
    sha256 "cdc5762ccf853b05ee2e6137fc7659a9f39b07d6bc2928a3fc475451300ce6f3" => :catalina
    sha256 "2c0c7c6b55375fbc5991696a488c5f6e8e91a8142edc3889d91feb0f5679bb95" => :mojave
    sha256 "4f504978ec76795f48cbaa7872235e31e60e8b0d17064c8f7322c5249205911f" => :high_sierra
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
