class ZeldaRothSe < Formula
  desc "Zelda Return of the Hylian SE"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-return-of-the-hylian-se"
  url "https://gitlab.com/solarus-games/zelda-roth-se/-/archive/v1.2.1/zelda-roth-se-v1.2.1.tar.bz2"
  sha256 "1cff44fe97eab1327a0c0d11107ca10ea983a652c4780487f00f2660a6ab23c0"
  head "https://gitlab.com/solarus-games/zelda-roth-se.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e2654f4d71bd00cb4d8fdd46666d079d78f2831e453cae55cc0e4edab0ed64a" => :mojave
    sha256 "ebd84dd4b4d7941f1a77cb5fa577185394f3d4bf99e64815a72b5c03389997e9" => :high_sierra
    sha256 "19f8989a85c20f77b4b2126e68af6c94221a863347c2327f009239c0536cce09" => :sierra
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
