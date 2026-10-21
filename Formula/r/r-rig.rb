class RRig < Formula
  desc "R Installation Manager"
  homepage "https://github.com/r-lib/rig"
  url "https://github.com/r-lib/rig/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "7db832e504371b12fd0d43611ccb4530572da3b679133a8ce33577752d374604"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2946b4edbf40eadd4e31afc87e6bc2aea43f92d40719e32afe7972a72eebcea9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ae3663a2b63f5d65c25cf54c3943c03ff1db271de5be4ba10dcc60f08cef8a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf44444b4f4e6d33c67c3dac9d72046b02182df66fde0f896a0ff83e44cc74be"
    sha256 cellar: :any,                 arm64_linux:       "1744e9828001e4bbb055780c5844641038bc9c13f3a9f9275c59b47346495642"
    sha256 cellar: :any,                 x86_64_linux:      "5d99929e9af4d5171c1238779024c10f4307cd7e5832499128e8233d90b7829b"
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
