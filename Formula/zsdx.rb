class Zsdx < Formula
  desc "Zelda Mystery of Solarus DX"
  homepage "http://www.solarus-games.org/games/zelda-mystery-of-solarus-dx/"
  url "https://github.com/christopho/zsdx/archive/zsdx-1.11.0.tar.gz"
  sha256 "05a5d220bbf2439c9da2e71cd9d104240878123fff5bc702e2405d6d0712f0dc"
  head "https://github.com/christopho/zsdx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "336c19e1191e48fa0695fd6aad02642987bca12a20eed22c9ed058fff6e4a041" => :sierra
    sha256 "3d610c489f735a19990902b6a9d2552a839f206a7a41bf5ef23416680ba09351" => :el_capitan
    sha256 "db6c49e89d2e1e100673394b1c44d0d88ef454c7a82a0cac5809fb23e66d2bc6" => :yosemite
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
