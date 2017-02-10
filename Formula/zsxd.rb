class Zsxd < Formula
  desc "Zelda Mystery of Solarus XD"
  homepage "http://www.solarus-games.org/games/zelda-mystery-of-solarus-xd/"
  url "https://github.com/christopho/zsxd/archive/zsxd-1.11.0.tar.gz"
  sha256 "4c6e744ecc5b7e123f5e085ed993e8234cbef8046d2717d16121a2b711e0ccde"
  head "https://github.com/christopho/zsxd.git"

  bottle do
    cellar :any_skip_relocation
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
