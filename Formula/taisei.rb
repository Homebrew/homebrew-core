class Taisei < Formula
  desc "Clone of Touhou Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/laochailan/taisei.git",
      :tag => "v1.1",
      :revision => "70de1564c8ed6a626b8dbf2926ebac3ba00678ff"

  bottle do
    sha256 "555821b3df9e7cf8d5917e581e80f236dbabd95c886edececaeb9986b4ea903c" => :high_sierra
    sha256 "e41fc7a5c28ca97217135e413af393e05d09b7a4a2131a0fb292f9873f6bb326" => :sierra
    sha256 "4382fbd49e142c1fd318169ee8c91f1fff390c516b2f5fc5c6d975b330f8f472" => :el_capitan
    sha256 "3d5fa72700737fa76e87e21e6176b32f88ef4f5d464a2a0b4fa4b98b8509251b" => :yosemite
  end

  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "freealut"
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
