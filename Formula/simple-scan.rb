class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.34/simple-scan-3.34.4.tar.xz"
  sha256 "7f341beebd49ea0a7477dc5c28459aa96bac04b348d56e69d3d250ffc5317e77"

  bottle do
    sha256 "376fcef4fa82352bcf2d56bd0fb1501a77b2236a30264e326233d0fffbc8703a" => :catalina
    sha256 "28b87e73a9b0e360785cb10093526440669f8c7404072c15c4be349e22efd1fd" => :mojave
    sha256 "fc0cfa2b6133bdb9679a7d5d85cb261dcefcc18b4e711f8fa89532443bac82e7" => :high_sierra
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
