class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.32/simple-scan-3.32.1.tar.xz"
  sha256 "b3626ecd42868df06a3d8aecd0cdd7c3181e4421685f89ec00f8685d29bf9cb7"

  bottle do
    sha256 "c2032f07da58b7fb2bbcabfbc20e9ea259cfcba695aa7d17c01184424b41b010" => :mojave
    sha256 "8aff8bf6fa9c09998dce2ba00e097887969be69560dadf87acf1313e476a731a" => :high_sierra
    sha256 "06991093210f26edcece1bfde29e496778e182f4c7a48d2269e407fba5b3a0cd" => :sierra
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
