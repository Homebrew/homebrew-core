class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://www.solarus-games.org/downloads/solarus/solarus-1.6.0-src.tar.gz"
  sha256 "d800fdf388f860732f2d40c8dd635c34fd1c452857f75bf9b3a421e3ef5ee751"
  head "https://github.com/christopho/solarus.git"

  bottle do
    cellar :any
    sha256 "90fb26824fa3cc585f483105cfa1c68da0573cd2e6b4cd80e69e22113ae6b8d4" => :mojave
    sha256 "9972343ff8beb7855da2b2f8850b648a68383c5d35b19454eaa24a4197806b03" => :high_sierra
    sha256 "ea2f4972dde9ccf2d16c1055f39c59a73469d14d2dfa99b305108f7812d15038" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit"
  depends_on "physfs"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"

  def install
    mkdir "build" do
      ENV.append_to_cflags "-I#{Formula["physfs"].opt_include}"
      system "cmake", "..",
                      "-DSOLARUS_GUI=OFF",
                      "-DVORBISFILE_INCLUDE_DIR=#{Formula["libvorbis"].opt_include}",
                      "-DOGG_INCLUDE_DIR=#{Formula["libogg"].opt_include}",
                      *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/solarus-run", "-help"
  end
end
