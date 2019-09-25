class Zsxd < Formula
  desc "Zelda Mystery of Solarus XD"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-mystery-of-solarus-xd"
  url "https://gitlab.com/solarus-games/zsxd/-/archive/v1.12.2/zsxd-v1.12.2.tar.bz2"
  sha256 "656ac2033db2aca7ad0cd5c7abb25d88509b312b155ab83546c90abbc8583df1"
  head "https://gitlab.com/solarus-games/zsxd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed58fdb900b1753c2f446c19db2b2db180ef38cdc215fb08dc2b1625b5a80c69" => :mojave
    sha256 "518c8710ac28e8c3349ae5f4b02c6984d369ad1d3c6187e3d88789a9daf67673" => :high_sierra
    sha256 "51c732cdd79fb5fe9ac41c15b83e50edd3fef7e680a26fb4cd04df6c1386289c" => :sierra
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
