class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.2/SuperTux-v0.6.2-Source.tar.gz"
  sha256 "26a9e56ea2d284148849f3239177d777dda5b675a10ab2d76ee65854c91ff598"
  license "GPL-3.0-or-later"
  head "https://github.com/SuperTux/supertux.git"

  livecheck do
    url "https://github.com/SuperTux/supertux/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "671a6a888ace25b1cd8adfafea895a7bb259bee92be354e7ed4b4fbd63841f92" => :catalina
    sha256 "e96d518a12e5cd571345abd4d778a6983062daebe845ab1a0404ee1f4ae11212" => :mojave
    sha256 "3427130b27e209085a062bec0f853f765a34c6bf5d4fe6bedba4c7c5e408c400" => :high_sierra
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
