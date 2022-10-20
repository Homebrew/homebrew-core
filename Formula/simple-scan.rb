class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/42/simple-scan-42.5.tar.xz"
  sha256 "05f5dfa4e9e206efa9d404c9861dd7c442091793e734c41719739917250e4050"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "80acb3bb82bdfc4ae6311c9a8188fcdd93a4357434248f21e47d7d9490682c22"
    sha256 arm64_big_sur:  "ac9800eb3bab125883229ed260f55c3a0b440fc03287f8d823d1fb38edfe5218"
    sha256 monterey:       "e9805d0b210633beca14b395cf8fa4d9fe182e8dde09a065403901c44796e91e"
    sha256 big_sur:        "a1cc322c0ce81cf2bc2e2e9aab706542bd52c93941c295c756c4ecfc6481ba4b"
    sha256 catalina:       "9d484fd5d6baf6180b3e6d9946dd752f4f485f029fd1e2edc8d6945e11f5ebc3"
    sha256 x86_64_linux:   "8a15d4a1a86f60b6ce011c1ef46a59d2768b05316fd76fde118375d516ef1538"
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
    # Errors with `Cannot open display`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "#{bin}/simple-scan", "-v"
  end
end
