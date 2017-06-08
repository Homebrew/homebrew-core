class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://supertuxproject.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.5.1/SuperTux-v0.5.1-Source.tar.gz"
  sha256 "c9dc3b42991ce5c5d0d0cb94e44c4ec2373ad09029940f0e92331e7e9ada0ac5"
  revision 2

  head "https://github.com/SuperTux/supertux.git"

  bottle do
    cellar :any
    sha256 "cbdfb8a82436041f076f60d487646ad43736da9efe89479d4af59924cab1802a" => :sierra
    sha256 "28b5385dad4ace16ff7f9602124f30ee87e8c031e195fae3b194350b3ed007f8" => :el_capitan
    sha256 "7353d764c9113a335235da1499194aa54da66b8538caa9432e4a2624b2b6aa3e" => :yosemite
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
    url "https://github.com/SuperTux/supertux/commit/47a353e2981161e2da12492822fe88d797af2fec.diff"
    sha256 "f5941084fbb06d88762c8793d71a5d38b521926144a62af4b01c2ce81a463577"
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
