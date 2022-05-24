class Zsdx < Formula
  desc "Zelda Mystery of Solarus DX"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-mystery-of-solarus-dx"
  url "https://gitlab.com/solarus-games/zsdx/-/archive/v1.12.3/zsdx-v1.12.3.tar.bz2"
  sha256 "29065d3280ec03176e8de0a7a26504421d43c5778b566e50c212deb25b45d66a"
  head "https://gitlab.com/solarus-games/zsdx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ed8efab9ad526d5d1f3ae89725e30f4913546a49cb4d752be453365ff99bbce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "254d66ee2050168bf9dad808272678ae1de6f89d364bf658a38e28f4bc339cf7"
    sha256 cellar: :any_skip_relocation, monterey:       "bffc5d27e406eb33325bfbb03330bfde3f73dc944958b5218c384167673d5643"
    sha256 cellar: :any_skip_relocation, big_sur:        "3267503e66537fe829db44b5d36d97200c78911f171659e9c5fc66912beea4fa"
    sha256 cellar: :any_skip_relocation, catalina:       "bf58b35d61058612b8497abcc7c29930b1b6d6f9ea0aa7b88bc00ae7181b1f35"
    sha256 cellar: :any_skip_relocation, mojave:         "332fd78f55b41f593403d76839cd51befb586f34036c89a43446c3f39a240d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0c835e5e48efab248d3f5347d04a9ced81d0869c4fd4afa0176e2331b2c8374"
  end

  depends_on "cmake" => :build
  depends_on "solarus"

  uses_from_macos "zip" => :build
  uses_from_macos "unzip" => :test

  def install
    system "cmake", ".", *std_cmake_args, "-DSOLARUS_INSTALL_DATADIR=#{share}"
    system "make", "install"
  end

  test do
    system Formula["solarus"].bin/"solarus-run", "-help"
    system "unzip", pkgshare/"data.solarus"
  end
end
