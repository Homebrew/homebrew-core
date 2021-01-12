class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.2/SuperTux-v0.6.2-Source.tar.gz"
  sha256 "26a9e56ea2d284148849f3239177d777dda5b675a10ab2d76ee65854c91ff598"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/SuperTux/supertux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "7dba4235519691bd4a1cffb0764d8e88563936ff98f88dae6db324aca59b06e8" => :big_sur
    sha256 "c5a594ef5892731a556b3956b4633c576a8450939188493556b406ed0941254c" => :arm64_big_sur
    sha256 "2180590875a08d8aa1a03303090ecf34ff3a01bca1084db4b0fba6437090d100" => :catalina
    sha256 "a3e03cceaedb6ab9dec08e4dc01882e259de440132d06f9c1f50cebd8b61c483" => :mojave
    sha256 "6f1c9c50af7ccbe9632e1211b81a6bef05ad7d1e0d9c5c20c88386ab3b07cc30" => :high_sierra
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
