class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v1.6.4",
      revision: "6d2a11ddd1d07d21695ab7304c3ddd462fd37c26"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "80970673e8217a282440a21de4e4db8fa4435f9743e94c74f300fa55f2963014" => :big_sur
    sha256 "23c646e9a69c966e0f2930ac225661dab3d8b97fbb9e34c12cb49cdfe1e56d67" => :catalina
    sha256 "6d02a298994633961ed83feb34471cf743059aa9daf90d9b5153f2613337e8d2" => :mojave
    sha256 "dedfe91badd887dfdcf0e0d55b662fde86890c1f8e287dddd224b29b0339f4b9" => :high_sierra
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
