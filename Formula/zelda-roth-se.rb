class ZeldaRothSe < Formula
  desc "Zelda Return of the Hylian SE"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-return-of-the-hylian-se"
  url "https://gitlab.com/solarus-games/zelda-roth-se/-/archive/v1.2.0/zelda-roth-se-v1.2.0.tar.bz2"
  sha256 "27fd5c5be969437eecdc1e8472284f74c7e2d977b7e06c4c395046f6761782e8"
  head "https://gitlab.com/solarus-games/zelda-roth-se.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9f77d702fa6c412eec4b5d1c602ae1bc0ca05d01421d792110057bd79e53742" => :mojave
    sha256 "8b76f5c62bca90258a3e0c3d930551befe9fdd0f0814d1f2026f32dae1027998" => :high_sierra
    sha256 "2db05a8f1209a0f039c6bea92ffefb362d94497bc9f659e8057eca1539fc132e" => :sierra
    sha256 "7aa852ad416766a72aad6b254f86f21a53bd67df29f20b7eaa612ba709f8c0cd" => :el_capitan
    sha256 "069a42db0b88121a77233d3860a5191af80ad335270cc4723b1bb4ef1c48ccc3" => :yosemite
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
