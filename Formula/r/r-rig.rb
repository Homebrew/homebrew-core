class RRig < Formula
  desc "R Installation Manager"
  homepage "https://github.com/r-lib/rig"
  url "https://github.com/r-lib/rig/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "e6186c4fd550f1c31323d5732c95da78e8a2f0cafcd3e505264b2ec7f5a09da2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "930e63fcb6daaeb0c0737b4872bb980f1ce4d24ae0643f441babc0d02e81e1de"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00d7873e7fe117e0851062d991c1431cc51da993d135258c504cacfdc2c9d761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a547dd661605d52f41651e9da9fff524465d0f8680da7056203508b23d5920b"
    sha256 cellar: :any,                 arm64_linux:       "c6856624e03c1e9bdb9056c3bbe66e741eb72a48b5b52bb6ea7db2f6916a675b"
    sha256 cellar: :any,                 x86_64_linux:      "afc9a23e7bbf9928d5b76e4f1610abc1e00dbdb46a9ab4bf19b1eb100401515c"
  end

  depends_on "rust" => :build

  conflicts_with "rig", because: "both install `rig` binary"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rig --version")
    output = shell_output("#{bin}/rig default 2>&1", 1)
    assert_match "No default R version is set", output
  end
end
