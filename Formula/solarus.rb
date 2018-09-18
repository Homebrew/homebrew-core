class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "http://www.solarus-games.org/"
  head "https://github.com/christopho/solarus.git"

  stable do
    url "http://www.solarus-games.org/downloads/solarus/solarus-1.5.3-src.tar.gz"
    sha256 "7608f3bdc7baef36e95db5e4fa4c8c5be0a3f436c50c53ab72d70a92aa44cc1c"

    # Upstream patch for build issue, remove in next version
    # https://github.com/solarus-games/solarus/issues/1084
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e6a26f3d/solarus/config.patch"
      sha256 "7bb5c39dd97eca215a22a28dffe23dfac364252f7ff8221e5d76ae40d037be76"
    end
  end

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
      system "cmake", "..", "-DSOLARUS_GUI=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/solarus-run", "-help"
  end
end
