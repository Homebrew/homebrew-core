class Zsdx < Formula
  desc "Zelda Mystery of Solarus DX"
  homepage "https://www.solarus-games.org/games/the-legend-of-zelda-mystery-of-solarus-dx"
  url "https://gitlab.com/solarus-games/games/zsdx/-/archive/v1.12.3/zsdx-v1.12.3.tar.bz2"
  sha256 "29065d3280ec03176e8de0a7a26504421d43c5778b566e50c212deb25b45d66a"
  license all_of: ["CC-BY-SA-4.0", "GPL-3.0-only"]
  head "https://gitlab.com/solarus-games/games/zsdx.git", branch: "dev"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "20ad65e6c82c443373bc1532dd4f69576d433cc5135c00d90978950e6c6a225c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e04d5e80fee6fc551aa5f8107bbc563a5cd8d5a3a4c92a42cdf48673f43f49ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc51b43950a65fbd9e1a3faf0d36eba2dc3495bfb6070b3949440eb38fa894ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf9b6d3f03eea1f2ae50f831fc5df103bcbb16c10b37b19c45cae4a4da5cb2e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ed8efab9ad526d5d1f3ae89725e30f4913546a49cb4d752be453365ff99bbce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "254d66ee2050168bf9dad808272678ae1de6f89d364bf658a38e28f4bc339cf7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a6df19f8e50b836f9e8a7523d50f0b3f8809251494fb15e0cdd1b8246eb7b5f"
    sha256 cellar: :any_skip_relocation, ventura:        "70896743d2a6c62b3660d0917e1f2fad08f878bee765f863234a3d9faf07cf86"
    sha256 cellar: :any_skip_relocation, monterey:       "bffc5d27e406eb33325bfbb03330bfde3f73dc944958b5218c384167673d5643"
    sha256 cellar: :any_skip_relocation, big_sur:        "3267503e66537fe829db44b5d36d97200c78911f171659e9c5fc66912beea4fa"
    sha256 cellar: :any_skip_relocation, catalina:       "bf58b35d61058612b8497abcc7c29930b1b6d6f9ea0aa7b88bc00ae7181b1f35"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b1bba51d6059e4d5922550be0ad0f6b3ef4f1f4161421ef2c41483b6fe4cfc49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0c835e5e48efab248d3f5347d04a9ced81d0869c4fd4afa0176e2331b2c8374"
  end

  depends_on "cmake" => :build
  depends_on "solarus"

  uses_from_macos "zip" => :build
  uses_from_macos "unzip" => :test

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DSOLARUS_INSTALL_DATADIR=#{share}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system Formula["solarus"].bin/"solarus-run", "-help"
    system "unzip", pkgshare/"data.solarus"
  end
end
