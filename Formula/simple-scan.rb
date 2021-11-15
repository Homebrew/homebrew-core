class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/40/simple-scan-40.5.tar.xz"
  sha256 "eb5379e4cb6ca605092c942210c18425d036773da76541e43b89d8223f82b9a4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "28589902b7eb3965380a37e8a2566fdda48b4485bcd29b72a4f4a875d1e892b5"
    sha256 big_sur:       "29db6142111c9acaee04a3f6b17c9113b2d23b7a53188b6a21ae3a31454872ca"
    sha256 catalina:      "fe60b1d71b27e3b2cbb20edd2bd8b6d9000c4f2653edb283ab65905dbd897291"
    sha256 mojave:        "4871d0a1a1eff098b418deca15103d2f41bda91904e693e0146f109d92dbbd10"
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
