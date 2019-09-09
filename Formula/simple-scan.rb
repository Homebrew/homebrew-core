class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.34/simple-scan-3.34.0.tar.xz"
  sha256 "7378bb9d891f956df232eb85bda59b9551be9578bc209bff40fed47d21cfb8bb"

  bottle do
    sha256 "e2a2737218f4cb859bbd5aef5897e44aa385316197ec2f87cd511ae349119569" => :mojave
    sha256 "b00037a137dbf82604c8510452bc7d8ef67b689996117a5ac611b99929339abb" => :high_sierra
    sha256 "193aff75029a4b058153e6aa5f268e6ffe674aaed1ada77769b20eeb4132369f" => :sierra
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
