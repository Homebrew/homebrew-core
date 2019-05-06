class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.32/simple-scan-3.32.2.1.tar.xz"
  sha256 "d7f7f93a93bb302aebc80bd44edb8d4c22ec774aa12d52756b5034bd04310b77"

  bottle do
    sha256 "512534babfe087c4aac4ab99b895a6da8897a5f7f3b1bc1374da08731c72e027" => :mojave
    sha256 "a340dc8d82ca01c61ea39be163efc35693dfb53a9f92385c567e4fde8cfebc54" => :high_sierra
    sha256 "5039bd4b4c51b4d6df8daab1e93ef67cf2b7a54833ff4687c3a57e63d6cab52e" => :sierra
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
