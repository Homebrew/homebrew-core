class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.30/simple-scan-3.30.2.tar.xz"
  sha256 "71144fa985846e974dbe486bfab825694fc2a4e728fbd1ba4d37774b65db7636"

  bottle do
    sha256 "7ef5e1f022286f0736b071f32b60b3ae9e4135c4ea7c8402489cbed466ad7d78" => :mojave
    sha256 "720a1f1e2928c1361b77804269817942c6cdd757ddd7b1becd02fb0af9dfb173" => :high_sierra
    sha256 "6c3a0cf468aff936f5c5365c31bde767cf94005bc8dc7e885f94dc8250894dca" => :sierra
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
