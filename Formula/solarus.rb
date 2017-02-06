class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "http://www.solarus-games.org/"
  url "http://www.solarus-games.org/downloads/solarus/solarus-1.5.1-src.tar.gz"
  sha256 "6cd3928a024f7c18a163a1679a92dfff3c37139c5c49fa5348704df5357e8da3"
  head "https://github.com/christopho/solarus.git"

  bottle do
    cellar :any
    sha256 "21588d712ee8bfa0047baecac8fb80157fe207f204e1900be3e0d94c28886032" => :sierra
    sha256 "93dec2fb97684a7df689af1a526ab40134d0d42cc58cb1ca0ce5a92ecfa411e6" => :el_capitan
    sha256 "66a5b11989a4ca95b66b8f504179df20995e0f822225cc7a58adada6fb5f4385" => :yosemite
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
