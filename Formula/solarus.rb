class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "http://www.solarus-games.org/"
  url "http://www.solarus-games.org/downloads/solarus/solarus-1.5.3-src.tar.gz"
  sha256 "7608f3bdc7baef36e95db5e4fa4c8c5be0a3f436c50c53ab72d70a92aa44cc1c"
  head "https://github.com/christopho/solarus.git"

  bottle do
    cellar :any
    sha256 "6afb8d4b5e69f2f44f9ad5df66439b98341ae9e456d081b86f8709b734b35c37" => :sierra
    sha256 "ee7d849e34c9487a3b9d4499826aeb20339801978c7120f8a7919078dde93f60" => :el_capitan
    sha256 "11db19b89a9f63fcc598949ee6e117d64a7b846bfe08a85d3b7a987b61b709f9" => :yosemite
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
