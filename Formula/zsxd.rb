class Zsxd < Formula
  desc "Zelda Mystery of Solarus XD"
  homepage "http://www.solarus-games.org/games/zelda-mystery-of-solarus-xd/"
  url "https://github.com/christopho/zsxd/archive/zsxd-1.11.0.tar.gz"
  sha256 "4c6e744ecc5b7e123f5e085ed993e8234cbef8046d2717d16121a2b711e0ccde"
  head "https://github.com/christopho/zsxd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b014fef5a406ff688e2a3255b04a6dc4296f18b844f17a4b730dd4f8a332aace" => :sierra
    sha256 "4cb8677d7ce37a1cea3f3a5e5df51284d580d6190a1c168d00929c8329e582d0" => :el_capitan
    sha256 "795fa732d77f79ce4a305cd2ae0dc8ed939f8328f1f01661379892c36a481274" => :yosemite
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
