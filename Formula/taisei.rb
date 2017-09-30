class Taisei < Formula
  desc "Clone of Touhou Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/laochailan/taisei.git",
      :tag => "v1.1",
      :revision => "70de1564c8ed6a626b8dbf2926ebac3ba00678ff"

  bottle do
    cellar :any
    sha256 "79524e3b041c255be58be39a9bd932d0dbfab6599566c53f35ba30b415a411e5" => :high_sierra
    sha256 "64cef000c13d13137fe29b27cb09afccfd2798a8248e97bb8a040b5646011efc" => :sierra
    sha256 "cdc26356ffe5fa82ff101107bd18f2b3bce337c70d1cb4965feba039916ba276" => :el_capitan
  end

  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    mkdir "build" do
      system "cmake", "..", "-DOSX_TOOL_PREFIX=", *std_cmake_args
      system "make", "install"
    end
  end

  def caveats
    "Sound may not work."
  end
end
