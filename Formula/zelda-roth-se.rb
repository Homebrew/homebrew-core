class ZeldaRothSe < Formula
  desc "Zelda Return of the Hylian SE"
  homepage "http://www.solarus-games.org/games/zelda-return-of-the-hylian-se/"
  head "https://github.com/christopho/zelda_roth_se.git"

  stable do
    url "https://github.com/christopho/zelda_roth_se/archive/v1.1.0.tar.gz"
    sha256 "95baf3ce96372b1ce78d9af8ee9723840474ac8fc51e87eb54cc35777d68f5a8"

    # Support SOLARUS_INSTALL_DATADIR variable for CMake
    patch do
      url "https://github.com/christopho/zelda_roth_se/commit/e9b5bd907f5b50b17d65ebe2fa50760d322c537c.diff"
      sha256 "e8713c2b83e86821d4ca683c2653c36d0756d97a0fd8c3529a503d44c10e9306"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f8f772c82c7739b4f0d17b14c0307e3ef71260f16c8b63cbc2ac1e563c97ac5e" => :sierra
    sha256 "2fa070bf6a0c9596a0606a5fc22e050a60d212924815e1ccaf38eab95b23fbad" => :el_capitan
    sha256 "5064335d6471ccbafcef75fc18fe5d2c360e3920ccab61bc1420cdf8f040e2fd" => :yosemite
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
