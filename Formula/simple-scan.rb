class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.38/simple-scan-3.38.5.tar.xz"
  sha256 "2a9293aad60cdd2b51f3d43783afa1748e74b5e7df79dd4a8ef2fc940beeb66d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "c8a8d4d6a776e226655435ecda76a31aab5e29132bc3f79b0a8a5b96aaeed051"
    sha256 big_sur:       "cccc84cfd9d0335c4edcdbd09a73a7703ae364f97ec28a8a60b90e58bfe27feb"
    sha256 catalina:      "ed897f6f5138aa644628a94087743d5a09febdad9db5fb307f65e5c5d9aea6d4"
    sha256 mojave:        "0f2d7b8e0f5456e9b687435c384abe9f88960b94e8efc377268659f5b82e7507"
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
