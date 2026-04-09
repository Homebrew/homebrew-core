class Vipsdisp < Formula
  desc "Viewer for large images"
  homepage "https://github.com/jcupitt/vipsdisp"
  url "https://github.com/jcupitt/vipsdisp/releases/download/v4.1.3/vipsdisp-4.1.3.tar.xz"
  sha256 "4e3dbd72f8f56e0216045ef36b5097d00b3d14f2608cf856f0ecbab3d4c44ba4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f1d8149ab410b4e98de0609ccc20638687c7301e9ac2d9db74e289ccc89ea455"
    sha256 cellar: :any, arm64_sequoia: "21acc4673aa44528f22ec4809479eea073c5351426e54bbf1c6d1af01ca49690"
    sha256 cellar: :any, arm64_sonoma:  "489ec5f277560ac2739715407a7ffa73bd44885650b1c885d7ad8789d95e9fcc"
    sha256 cellar: :any, sonoma:        "b9e7e86fa6fba8bb99701646e492e315ef20dd6eb850780477509c30025ba64b"
    sha256               arm64_linux:   "22ed1327cab00506ea09028e5e3b818e23aecb95cca43df09cde10b408af4d82"
    sha256               x86_64_linux:  "6135a5be7f7cadf2294843c1a7bbe96a5539366696eac56e37533458e438ffd6"
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
