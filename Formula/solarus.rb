class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://www.solarus-games.org/downloads/solarus/solarus-1.6.0-src.tar.gz"
  sha256 "d800fdf388f860732f2d40c8dd635c34fd1c452857f75bf9b3a421e3ef5ee751"
  head "https://github.com/christopho/solarus.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f8c784ab5cc03a3bfc41cc53c9eaa037373f97046fa28044492b2286faa3e2ee" => :mojave
    sha256 "b03dd0139fb3496f90a23c2847b42908e63366c37f92ad8b219f23bada2c4422" => :high_sierra
    sha256 "03b09b647d7d940febe3405420b127567922251f493c15e96945b808a11a041d" => :sierra
    sha256 "270c69a61d8bbc33033b4ca18bc669fabbba1e58c7ad67dcd5cb1150f039160a" => :el_capitan
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
