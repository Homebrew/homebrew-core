class Zsxd < Formula
  desc "Zelda Mystery of Solarus XD"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-mystery-of-solarus-xd"
  url "https://gitlab.com/solarus-games/zsxd/-/archive/v1.12.1/zsxd-v1.12.1.tar.bz2"
  sha256 "436c8d2860de1e947c049ed30a271d8a7c86eaaf5c889cd10b29444e1893579e"
  head "https://gitlab.com/solarus-games/zsxd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e57932a91c610939d8557bd37b4e7c21ca17d09570e855f0dda090a2fa8ee1e6" => :mojave
    sha256 "ebfcb1fdadd493874292f6924f0c012f09bb8ea3d84a7c89790cb798848d05ad" => :high_sierra
    sha256 "688c1aa54d1b058546fe3b63e13c70817fa92f7ac75e44f5b3fd6f15a7e9e6b1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "solarus"

  def install
    system "cmake", ".", *std_cmake_args, "-DSOLARUS_INSTALL_DATADIR=#{share}"
    system "make", "install"
  end

  test do
    system Formula["solarus"].bin/"solarus-run", "-help"
    system "/usr/bin/unzip", pkgshare/"data.solarus"
  end
end
