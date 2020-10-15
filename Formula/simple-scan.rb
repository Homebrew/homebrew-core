class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.38/simple-scan-3.38.1.tar.xz"
  sha256 "1e82f80c5ddd4855a94763a2490432bd6d550e44b06f4cd44c47f265d2673a3f"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "6b49711531ec4066744a184e2bad8b8ae11213edd8ae17649e03bfa3279e8581" => :catalina
    sha256 "bd5bdfa081cc5cfb39ab5453d9b5af8c3fe2eff9dcc8062c5015c865adb1d8b7" => :mojave
    sha256 "22646109f4b948ab2a1cc30f6a02120cbfa296859e5b1d8ed298863a11fd7d4c" => :high_sierra
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
