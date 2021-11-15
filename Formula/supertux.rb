class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.2/SuperTux-v0.6.2-Source.tar.gz"
  sha256 "26a9e56ea2d284148849f3239177d777dda5b675a10ab2d76ee65854c91ff598"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/SuperTux/supertux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c43cf071cc0f131af3b0e21d82eb18ef691e23905b8bd0a851218d1221a7221d"
    sha256 cellar: :any, arm64_big_sur:  "a43aa28db1ce468178567d76e8d62ecc90b7059efebf09e7486adeb7fb4fa22e"
    sha256 cellar: :any, monterey:       "416ca52bb2f3184cb76c3afd0d56429fb204f9d627d013f19c922b6418b712e5"
    sha256 cellar: :any, big_sur:        "b2a5292147a6d0f84589d699a2c5f0ffb196602640c5302f82281d021274c506"
    sha256 cellar: :any, catalina:       "59c8ea513385b6d4785c28cca54864ebdcc415d5ece4fe724d11a4a74f7f95cc"
    sha256 cellar: :any, mojave:         "2b0b76de7aa2d930df7d8b22eb3389c4dcaea132a45de9eb88907ded500c7cb3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  def install
    unless build.head?
      # Fix for `external/findlocale/VERSION` is trying to be compiled (on case-insensitive FS)
      # This mimics behaviour of https://github.com/SuperTux/supertux/commit/afbae58a61abf0dab98ffe57401dead8f7f1c0dd
      # Remove in the next release
      File.rename "external/findlocale/VERSION", "external/findlocale/VERSION.txt"
    end

    ENV.cxx11

    args = std_cmake_args
    args << "-DINSTALL_SUBDIR_BIN=bin"
    args << "-DINSTALL_SUBDIR_SHARE=share/supertux"
    # Without the following option, Cmake intend to use the library of MONO framework.
    args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
    system "cmake", ".", *args
    system "make", "install"

    # Remove unnecessary files
    (share/"applications").rmtree
    (share/"pixmaps").rmtree
    (prefix/"MacOS").rmtree
  end

  test do
    (testpath / "config").write "(supertux-config)"
    assert_equal "supertux2 v#{version}", shell_output("#{bin}/supertux2 --userdir #{testpath} --version").chomp
  end
end
