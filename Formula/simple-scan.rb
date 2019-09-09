class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.34/simple-scan-3.34.0.tar.xz"
  sha256 "7378bb9d891f956df232eb85bda59b9551be9578bc209bff40fed47d21cfb8bb"

  bottle do
    sha256 "261285338c73398642a3ff587d2b961799c493a79bba377a605550faffdc364e" => :mojave
    sha256 "bc9bc91f2693a621a9fed3c8a9df0015829c573fb39bca1a2b157d359732909f" => :high_sierra
    sha256 "0cfa5ed41747987feba5703f5cce94ce6926d3bca7fe005294ab07caffcb3ede" => :sierra
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
