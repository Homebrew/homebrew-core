class Zsxd < Formula
  desc "Zelda Mystery of Solarus XD"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-mystery-of-solarus-xd"
  url "https://gitlab.com/solarus-games/zsxd/-/archive/zsxd-1.12.0/zsxd-zsxd-1.12.0.tar.bz2"
  sha256 "6b36650fb6d7ba6763115875dbb48afa6796a4175dd7198e5e9a4dd5aeae73a1"
  head "https://gitlab.com/solarus-games/zsxd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f98aa8c723cfddb79aead81d9a4c9ede96d2c7d19ea3dba87d8f2ee069f67877" => :mojave
    sha256 "771e8ae2db1b6ab59d0ecaceee0265540a9a9d7f46b0be1fc7017842e743158a" => :high_sierra
    sha256 "cf2a0976c81fd8e06116d7728804ce266265447ebede2f80182f9f07071ec2da" => :sierra
    sha256 "56bd3750bfa55261fc43cb13144d3b81db7ae6743eb14ab0d2efa0783efb7e26" => :el_capitan
    sha256 "03135d1568d306d2c7918c643f4cca1071cf463fb62ce1af28b3fcca8ed5b4cb" => :yosemite
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
