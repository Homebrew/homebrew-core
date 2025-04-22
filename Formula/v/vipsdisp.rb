class Vipsdisp < Formula
  desc "Viewer for large images"
  homepage "https://github.com/jcupitt/vipsdisp"
  url "https://github.com/jcupitt/vipsdisp/releases/download/v3.1.0/vipsdisp-3.1.0.tar.xz"
  sha256 "5c40e71c9c60232dcbf2e1c389295a4a102a27603bce994dbb2e35ff4f1844db"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "c730d171fb0ff997048081609c182e91de7c462764255972070153d3f3957fcd"
    sha256 cellar: :any, arm64_sonoma:  "77e6eabacad3268d0fbbf4642b5a9860b7811d79b76223b4ea4a64b671d04191"
    sha256 cellar: :any, arm64_ventura: "04dff97da157a1807ef04cf555d74c42fceea4f63fed8f569f1b5f41d7ce2146"
    sha256 cellar: :any, sonoma:        "ab4c0f5577e3e3d12fee9d18b7d4033b3930a7b861185eaa74891e6bc954e04a"
    sha256 cellar: :any, ventura:       "b53418e567653dd0da7087a0f48c21205eb9198871e18ccc51eff0f75ffc947a"
    sha256               arm64_linux:   "0337ec69ca9d8102849c8a000b075c1f6b09cb5841c703225b8678bcaa1b6ad8"
    sha256               x86_64_linux:  "59bba41fe00cac2d5012a4a3526233f1c3d77f8d926a0160d95b63c7c4c2360d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "vips"

  def install
    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"vipsdisp", "--help"
  end
end
