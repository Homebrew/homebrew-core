class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://supertuxproject.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.5.1/SuperTux-v0.5.1-Source.tar.gz"
  sha256 "c9dc3b42991ce5c5d0d0cb94e44c4ec2373ad09029940f0e92331e7e9ada0ac5"
  revision 3

  head "https://github.com/SuperTux/supertux.git"

  bottle do
    cellar :any
    sha256 "5a4d9852a4796dc569cea7e31fe159b88ae85086fa96996a5c27069477a03e7d" => :sierra
    sha256 "2a1e2d20780359631f039d372c51c4ab16549b12d776a3b3e63ee366571a11f3" => :el_capitan
    sha256 "c2de71cc5011d55a3747d7909121718687250bde86dc4fe12d6fd049049055d2" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "glew"

  # Fix symlink passing to physfs
  # https://github.com/SuperTux/supertux/issues/614
  patch do
    url "https://github.com/SuperTux/supertux/commit/47a353e2981161e2da12492822fe88d797af2fec.diff?full_index=1"
    sha256 "2b12aeead4f425a0626051e246a9f6d527669624803d53d6d0b5758e51099059"
  end

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DINSTALL_SUBDIR_BIN=bin"
    args << "-DINSTALL_SUBDIR_SHARE=share/supertux"
    # Without the following option, Cmake intend to use the library of MONO framework.
    args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
    system "cmake", ".", *args
    system "make", "install"

    # Remove unnecessary files
    (share/"appdata").rmtree
    (share/"applications").rmtree
    (share/"pixmaps").rmtree
    (prefix/"MacOS").rmtree
  end

  test do
    assert_equal "supertux2 v#{version}", shell_output("#{bin}/supertux2 --version").chomp
  end
end
