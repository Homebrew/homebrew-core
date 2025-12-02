class Vipsdisp < Formula
  desc "Viewer for large images"
  homepage "https://github.com/jcupitt/vipsdisp"
  url "https://github.com/jcupitt/vipsdisp/releases/download/v4.1.2/vipsdisp-4.1.2.tar.xz"
  sha256 "1f9edf4cf7b3abcccbd7cb61e63b8d9c8397db689dd3c937048fea7ca56d7b0c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e96efb520abcfe2ec3480c03967b47f9277827e1e55cd3a5d3d577245aa85ba3"
    sha256 cellar: :any, arm64_sequoia: "eaa67c33717298b5477ad9687a39e9a00a579e3850f90d1b0fb734c1093293bb"
    sha256 cellar: :any, arm64_sonoma:  "821b91ff0853e7b29ad63a002df4817bda0b387e331205540a1a65ca5cf570ab"
    sha256 cellar: :any, arm64_ventura: "10f33027b004be6cf5b6e48f1f01d8447be738e2a69b67e134a46c3c4d00914c"
    sha256 cellar: :any, sonoma:        "0966771f6ba547c06fa250505218cb3219ceb3a11dce5f6188045d2763801be3"
    sha256 cellar: :any, ventura:       "3d3fadaf0b9a14f093e00af7516b356401e927daa6dca2f815e4668c0a59b645"
    sha256               arm64_linux:   "976698d21deec523c0d69ffa2f52362d08b16f833c316fa0e81e53c79fc4699e"
    sha256               x86_64_linux:  "526f1451fd37d2b905494cdd3032d95cf3ca4a7477746a626693f6577097279b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
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
