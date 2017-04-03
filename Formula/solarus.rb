class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "http://www.solarus-games.org/"
  url "http://www.solarus-games.org/downloads/solarus/solarus-1.5.3-src.tar.gz"
  sha256 "7608f3bdc7baef36e95db5e4fa4c8c5be0a3f436c50c53ab72d70a92aa44cc1c"
  head "https://github.com/christopho/solarus.git"

  bottle do
    cellar :any
    sha256 "fb865993c9c9a5e47bfb78dbe68e1995eee00a4aaf0a676bddb724515c5bee9b" => :sierra
    sha256 "f2cec4df4a1ed4ca192a54bfa0edcea353cdb780dbeb2a3f7b86ccd0d83f8820" => :el_capitan
    sha256 "05ba9e7ff66a89969b033315b9605f812faf42def007d14a65f618e4c9c62f51" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"
  depends_on "libvorbis"
  depends_on "libogg"
  depends_on "libmodplug"
  depends_on "physfs"
  depends_on "luajit"

  def install
    mkdir "build" do
      system "cmake", "..", "-DSOLARUS_GUI=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/solarus-run", "-help"
  end
end
