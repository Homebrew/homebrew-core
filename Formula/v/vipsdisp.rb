class Vipsdisp < Formula
  desc "Viewer for large images"
  homepage "https://github.com/jcupitt/vipsdisp"
  url "https://github.com/jcupitt/vipsdisp/releases/download/v4.1.4/vipsdisp-4.1.4.tar.xz"
  sha256 "c9d29b371782b550512e36abbe9191c105837ea34af5514958e55284a86a09f3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "45bae0667d6376de5112b6644cfd9bd694aa756775268bf5a8777982d5d29f15"
    sha256 cellar: :any, arm64_sequoia: "43b60bbe787ea75d16ab04fe7e489a39881445a4a0a7107b07e0dd826eebcf88"
    sha256 cellar: :any, arm64_sonoma:  "d3afafcb081a4fb46142a1e49dadc56b223c3846f14105ddf7f2b2d7ea814617"
    sha256 cellar: :any, sonoma:        "ea2103313f637b167b078adc574a214a42b501719fb3bea1205db11142a4ced7"
    sha256               arm64_linux:   "eac5bac3553876b892ef9ae02050674cd0d45cbf4f114d6707909f3fdd64184c"
    sha256               x86_64_linux:  "b81a4a08949f885abd6b95b30513a57d8e15b2f4505f85698dac286b1b1c293f"
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
