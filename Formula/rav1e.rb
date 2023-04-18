class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  stable do
    url "https://github.com/xiph/rav1e/archive/v0.6.4.tar.gz"
    sha256 "33aaab7c57822ebda9070ace90a8161dbadf8971f73b53d4db885e8b5566a039"

    # keep the version in sync
    resource "Cargo.lock" do
      url "https://github.com/xiph/rav1e/releases/download/v0.6.4/Cargo.lock"
      sha256 "e5b8414eb3681e3f4f134625545ed9b1d6744e2278e9bef473aa74ce12632c7e"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "ba68226e5734994eb791f783647ac68bf9eb4c603161f55a8e2c9b6fe1d73f45"
    sha256 cellar: :any,                 arm64_monterey: "ee9b8f7c164e9bc2501df5cb51ec25119efe8b45fbb9e665a3d304041258c29b"
    sha256 cellar: :any,                 arm64_big_sur:  "0f1e61e09287e38bd2b5040a9ce1947401211d34b25b6357bf1e4e6a01370e53"
    sha256 cellar: :any,                 ventura:        "63adad2c2ad5169838db25b7952074fe18f0ae2da23ddd01476847513a41f52b"
    sha256 cellar: :any,                 monterey:       "0594925b53738deb24718427968847ec542d00281d07f3113c0590282b289049"
    sha256 cellar: :any,                 big_sur:        "becace9c39d1527a4651390931f9ac7e10ec7ec644f5fda2cfbc79c876b75cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "168d80c5587b6124e117fd08614302b5a09e56efc015ab903cef2b38ec27ce8a"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  resource "homebrew-bus_qcif_7.5fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_7.5fps.y4m"
    sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
  end

  def install
    buildpath.install resource("Cargo.lock") if build.stable?
    system "cargo", "install", *std_cargo_args
    system "cargo", "cinstall", "--prefix", prefix
  end

  test do
    assert_equal version, resource("Cargo.lock").version, "`Cargo.lock` resource needs updating!" unless head?
    resource("homebrew-bus_qcif_7.5fps.y4m").stage do
      system bin/"rav1e", "--tile-rows=2",
                          "bus_qcif_7.5fps.y4m",
                          "--output=bus_qcif_15fps.ivf"
    end
  end
end
