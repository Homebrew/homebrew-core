class Zsdx < Formula
  desc "Zelda Mystery of Solarus DX"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-mystery-of-solarus-dx"
  url "https://gitlab.com/solarus-games/zsdx/-/archive/v1.12.2/zsdx-v1.12.2.tar.bz2"
  sha256 "a4d4cc9b41a4d52375e984f546cfe75736f604bc3ad194f6df1658ab6215c04f"
  head "https://gitlab.com/solarus-games/zsdx.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:     "feec47a76110128d7dd9e3c2507cf581fa451a320f506f3c32a3c5b732b9afea"
    sha256 cellar: :any_skip_relocation, catalina:    "9b245c7970507d8687420773853a820a0631eefad011cb602159007d11ee4fc7"
    sha256 cellar: :any_skip_relocation, mojave:      "dee683d31f1e6dd956c6e81351cf741e97ab0c1a4cdeb84fdc97b41e30bceeb8"
    sha256 cellar: :any_skip_relocation, high_sierra: "fe2df4c5e3c1d21dfd67acb0b98156167e2a9f79d06fae5da7527eba074a8b8c"
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
