class Taisei < Formula
  desc "Clone of Touhou Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/laochailan/taisei.git",
      :tag => "v1.1",
      :revision => "70de1564c8ed6a626b8dbf2926ebac3ba00678ff"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cfd21592a3c32d5284b0a3fda66ed642d86eaea0654cb060ed4c043a95f4733f" => :high_sierra
    sha256 "89672790c0942e9850feae93fab843dd2ae8ff4ee160ec98e1c4196b29b5f527" => :sierra
    sha256 "0ee3f696d8811038227259846902db529de833195eb0aea1842b1b1069611289" => :el_capitan
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
