class Vipsdisp < Formula
  desc "Viewer for large images"
  homepage "https://github.com/jcupitt/vipsdisp"
  url "https://github.com/jcupitt/vipsdisp/releases/download/v4.0.0/vipsdisp-4.0.0.tar.xz"
  sha256 "7bbb6740b13d0b211af2efab83d3a0d6e4646b15f57a038ac44ad67f446c5b64"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_releases
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0f455d9ae47cdd745f618db40f4b80122781d5e2a3ee8ad07e545e268882c04a"
    sha256 cellar: :any, arm64_sonoma:  "1ad7f204fcc95075e59ca963092d8dce61fab7afbb9fd0797283734a71901a35"
    sha256 cellar: :any, arm64_ventura: "380381c039fb4cfe865a47f2afe4243daa4e876b43f89b2972bc4655a4029319"
    sha256 cellar: :any, sonoma:        "eca523b5e38c37067ff551e0b7091c92a2b9f003d8bc01c9862e1291183fec9f"
    sha256 cellar: :any, ventura:       "5270221243ff26a91a7fcb84d0286dc102cbb112c5c38deb2ecd7ce78dd979a8"
    sha256               arm64_linux:   "e9e65b2c5e540a88943f22751fc3f340c962c828f2e855ae78043cf10abca538"
    sha256               x86_64_linux:  "e7b143d69ecd76a6487edc8814d42aca730b0cf1b2800fc833a2718d1c72edc1"
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
