class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "https://github.com/vapoursynth/vs-imwri"
  url "https://github.com/vapoursynth/vs-imwri/archive/R1.tar.gz"
  sha256 "6eed24a7fda9e4ff80f5f866fa87a63c5ba9ad600318d05684eec18e40ad931f"
  license "LGPL-2.1-or-later"
  version_scheme 1

  head "https://github.com/vapoursynth/vs-imwri.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "af2367f974a7cf578dc1570fdf03722baf54b9846d6c35748c805a5c4903843e"
    sha256 cellar: :any, arm64_big_sur:  "080c31181821b981cf47e913b5b91d99e36ed648c5c0bfc8a8ea7200e297f9ab"
    sha256 cellar: :any, monterey:       "03f768ac9fc321dc96d4fda5165d967dbffd55067e7fb82ec5094de65b067620"
    sha256 cellar: :any, big_sur:        "ef9f021e687b36a382c2f589b60c5c21fec61a25b687d555162be857a607b04e"
    sha256 cellar: :any, catalina:       "6041a275aaf72e45651a334d8cbaef9f9ecccc054b2fd32d9454c1aa82ee1fc7"
    sha256 cellar: :any, mojave:         "0ece8962763da6ebc44b85e22907ae218841be3b311d6062047ce59803c6ec3d"
    sha256               x86_64_linux:   "dd97dc5792768f831374845c07b347de5cd09d1f1f68a72f72c01fb4872deab1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "imagemagick"
  depends_on "vapoursynth"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "install_dir = vapoursynth_dep.get_variable(pkgconfig: 'libdir') / 'vapoursynth'",
              "install_dir = '#{lib}/vapoursynth'"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from vapoursynth import core; core.imwri"
  end
end
