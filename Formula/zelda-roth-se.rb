class ZeldaRothSe < Formula
  desc "Zelda Return of the Hylian SE"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-return-of-the-hylian-se"
  url "https://gitlab.com/solarus-games/zelda-roth-se/-/archive/v1.2.1/zelda-roth-se-v1.2.1.tar.bz2"
  sha256 "1cff44fe97eab1327a0c0d11107ca10ea983a652c4780487f00f2660a6ab23c0"
  head "https://gitlab.com/solarus-games/zelda-roth-se.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b474938504c1a9ac9a9f5374a6a4aa01196e0c31cf2d09fbd4c0452fc1d6900f" => :mojave
    sha256 "d8b2f8842d8ecd958f169c2f8b388fcb63859fd63a23de40ba86b0d622517c7e" => :high_sierra
    sha256 "d837cba79ce9aeea303d195a6122ec9dd213331e9ab9e25bb031cf1a4fd11424" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "solarus"

  def install
    system "cmake", ".", *std_cmake_args, "-DSOLARUS_INSTALL_DATADIR=#{share}"
    system "make", "install"
  end

  test do
    system Formula["solarus"].bin/"solarus-run", "-help"
    system "/usr/bin/unzip", share/"zelda_roth_se/data.solarus"
  end
end
