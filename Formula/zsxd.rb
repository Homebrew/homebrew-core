class Zsxd < Formula
  desc "Zelda Mystery of Solarus XD"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-mystery-of-solarus-xd"
  url "https://gitlab.com/solarus-games/zsxd/-/archive/zsxd-1.12.0/zsxd-zsxd-1.12.0.tar.bz2"
  sha256 "6b36650fb6d7ba6763115875dbb48afa6796a4175dd7198e5e9a4dd5aeae73a1"
  head "https://gitlab.com/solarus-games/zsxd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0a213d75ad15cd847505ded89379843442c726ca739c641e0fdbc89d36b37c9" => :mojave
    sha256 "49c039c401664716012b2544db5fe92a20cbd4e9e01a7a1039723c367567f6cc" => :high_sierra
    sha256 "91fa414f0ba13d8f256a8e72cce9f40e9f0aa29386039571920ef8a9fb6044ae" => :sierra
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
