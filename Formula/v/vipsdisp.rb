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
    sha256 cellar: :any, arm64_sequoia: "24abc3fc636aeed4dfbe817e109b059a98b972dbde9ad3a0c92924cd3c021666"
    sha256 cellar: :any, arm64_sonoma:  "9a1fc5fd9b711df78d40b4f6e505ebc49ad6b58a222d8850d1300a924c4bc804"
    sha256 cellar: :any, arm64_ventura: "325f80ddc32beb2975815317ede2c67a80dd87d6be1ca3992234b4fe527d330b"
    sha256 cellar: :any, sonoma:        "175eaa989968ad777419df2a10ea3bc1b1e293bb1dd09be2bed8ee59ede5f915"
    sha256 cellar: :any, ventura:       "74c32f11635518a227400938db3d70f87b7f0f4e0213644e1a170b950ff6afad"
    sha256               arm64_linux:   "7a1e46dc923816459b9cf35e395cbf177ee8c3567b3000a00fb943c3cba03d3e"
    sha256               x86_64_linux:  "44ff82fcb3a3f9dc8f389d69306e9a755e32c69c4d37d5f0959206580d0cc609"
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
