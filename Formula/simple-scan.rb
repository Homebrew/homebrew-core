class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.36/simple-scan-3.36.1.tar.xz"
  sha256 "7427f0902253e01383941243f56ef987609943c537f92dd1043a53eb5eaaf92e"

  bottle do
    sha256 "1ea6b81c49cda076a4e6d732a2bd44a2605fb0142b1270445ec5b58f774766e6" => :catalina
    sha256 "adf2684822ba2bc4feec5ff9e6ef27a048196ba0ea7ed661701ba7ba82fc1de6" => :mojave
    sha256 "0ed5b4f964c6940badf37b84c04126863066ff6b44f13104177b2a1c49d8ee2b" => :high_sierra
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
