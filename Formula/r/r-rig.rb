class RRig < Formula
  desc "R Installation Manager"
  homepage "https://github.com/r-lib/rig"
  url "https://github.com/r-lib/rig/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "09f020effe1e0a6bbdf57b17e5f8e1b9d5536f53bcd9de55d54aa6b2fec109f1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9a9560361b1c70fa6c0ffa1ece5d4c16516a922104314e3f14afc0236004f7e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "161eb6878816f81287e1a980c584955a8ad33aa4502732dc72b8a1dabc8824a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63f365888401081150f1b86ff6af99baca0ccbfca3f1a1e86b4646523a4f6890"
    sha256 cellar: :any,                 arm64_linux:       "334a69d7da59ec7464362d24a8b2efb12e3dcca6434e61c5833e810152de92d2"
    sha256 cellar: :any,                 x86_64_linux:      "5457f9a9a8f9b0693b045f12a7adae83b89d50bf10f86f223e737fc2a7f983e7"
  end

  depends_on "rust" => :build

  conflicts_with "rig", because: "both install `rig` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rig --version")
    output = shell_output("#{bin}/rig default 2>&1", 1)
    assert_match "No default R version is set", output
  end
end
