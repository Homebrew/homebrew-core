class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      :tag      => "v1.6.4",
      :revision => "6d2a11ddd1d07d21695ab7304c3ddd462fd37c26"
  sha256 "d800fdf388f860732f2d40c8dd635c34fd1c452857f75bf9b3a421e3ef5ee751"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0592ec07de500a8922d5cc0aa76a27176ba8c8a8b18b8638321ab44b7b89c60c" => :catalina
    sha256 "c1b94329afeaa61e682257922b64f422218f1f2e3a048d95258852cd91042509" => :mojave
    sha256 "1f788bc2c2918ea0b996a45c80f7a7522c8d67df7182e6184483be2f1665c8b1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "glm"
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
      ENV.append_to_cflags "-I#{Formula["glm"].opt_include}"
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
