class Zsdx < Formula
  desc "Zelda Mystery of Solarus DX"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-mystery-of-solarus-dx"
  url "https://gitlab.com/solarus-games/zsdx/-/archive/v1.12.2/zsdx-v1.12.2.tar.bz2"
  sha256 "a4d4cc9b41a4d52375e984f546cfe75736f604bc3ad194f6df1658ab6215c04f"
  head "https://gitlab.com/solarus-games/zsdx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "28a4b74aa6765859d5c8f6c48535a62d99b43171e8181fb416956be949ff17d7" => :mojave
    sha256 "0a391ad24a16fbd568173f3a90b81b8799d29ccff3814bcab6ae8a5944021c40" => :high_sierra
    sha256 "7f35b4009ccadc1d6f16135e18854c2d9e5ac29fc2fc05ec0d3a54f1f27de4d6" => :sierra
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
