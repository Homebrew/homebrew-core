class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://launchpad.net/widelands/build21/build21/+download/widelands-build21-source.tar.gz"
  version "21"
  sha256 "601e0e4c6f91b3fb0ece2cd1b83ecfb02344a1b9194fbb70ef3f70e06994e357"
  revision 1

  bottle do
    sha256 "18c821fec9352382a1e5858e81c571348947d42e3b3366eb54d1c73e2fa8d327" => :catalina
    sha256 "c9a6d215466e8874a343348a340779fa537111a314fb040928db73eba14b0876" => :mojave
    sha256 "b8418388e4c72f68da630f69a3402d082dc51c19a1780ce4ccbf52a88980e09f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "doxygen"
  depends_on "gettext"
  depends_on "glew"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lua"
  depends_on "minizip"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..",
                      # Without the following option, Cmake intend to use the library of MONO framework.
                      "-DPNG_PNG_INCLUDE_DIR:PATH=#{Formula["libpng"].opt_include}",
                      "-DWL_INSTALL_DATADIR=#{pkgshare}/data",
                       *std_cmake_args
      system "make", "install"

      (bin/"widelands").write <<~EOS
        #!/bin/sh
        exec #{prefix}/widelands "$@"
      EOS
    end
  end

  test do
    system bin/"widelands", "--version"
  end
end
