class Vipsdisp < Formula
  desc "Viewer for large images"
  homepage "https://github.com/libvips/vipsdisp"
  url "https://github.com/libvips/vipsdisp/releases/download/v4.1.4/vipsdisp-4.1.4.tar.xz"
  sha256 "c9d29b371782b550512e36abbe9191c105837ea34af5514958e55284a86a09f3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "000ac72682a0ac53e15254b17c0cfba939758d7e9075341f0523ae9fc79ece99"
    sha256 cellar: :any, arm64_sequoia: "dbd0e4346f4add8e69ddfe174111ad6b8fd1f87696f656ccaf325ea3645effc2"
    sha256 cellar: :any, arm64_sonoma:  "957ba726222950ff0b02816425e9933dd1a57932c11fbe5ff40d7539e5d9d2d9"
    sha256 cellar: :any, sonoma:        "c358b78133a3f11a36847a490e295bc001658efb99847736f527f18dfde1b901"
    sha256               arm64_linux:   "26da77028b3a3462c27990d45c2ae7441e9d62efea90a463358b80c0616f29ba"
    sha256               x86_64_linux:  "f3fa6ae007208167234b4aae420b86c7b22aa9603ffd2f483aa6f8d970aabcde"
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

  post_install_steps do
    compile_gsettings_schemas
    gtk_update_icon_cache
  end

  test do
    system bin/"vipsdisp", "--help"
  end
end
