class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  stable do
    url "https://github.com/xiph/rav1e/archive/v0.6.5.tar.gz"
    sha256 "a0d137aa40a27b308f965c4bc03a13493f6d07c888d6b52cc2ffaba36bfd5988"

    # keep the version in sync
    resource "Cargo.lock" do
      url "https://github.com/xiph/rav1e/releases/download/v0.6.5/Cargo.lock"
      sha256 "b18393b78e653eed998a53efbe0a205c26733e7043b4b9b23428893b81242649"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "063459dc66fc3dfa49807e6d7b0fc2f0ec05c96c802f5b5bc8e9bbe9e62eabfc"
    sha256 cellar: :any,                 arm64_monterey: "16cf55390ecbadde06c8ec6ae179cdb782e9265eaa14a922d12a3ee2f529480d"
    sha256 cellar: :any,                 arm64_big_sur:  "4e91f5ffdecd053655a656db91f16a750b02125e2931965127d3895f57bb27e5"
    sha256 cellar: :any,                 ventura:        "1baa03972ee6f1fd836d34bf50903a2395d275c01fa0874027ba1db9050132b7"
    sha256 cellar: :any,                 monterey:       "561f51fc81e272192d2a75999f8926e233834b05de4c03cd4c7c24b095c0cd3b"
    sha256 cellar: :any,                 big_sur:        "6c9756ba001f5b9a85d38dc6f4133cdc192cddd9080ce662fea746d63f509564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1000a41520cdbc43b5199e1e576058e8407e5c63e93fb30eebc15dfda0ae04a4"
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
