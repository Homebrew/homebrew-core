class RRig < Formula
  desc "R Installation Manager"
  homepage "https://github.com/r-lib/rig"
  url "https://github.com/r-lib/rig/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "a0f00e7c84573c15819cf7d907dd8668ad67a31784b07e1edd59039e514675fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65b85df1c4324713324196fb256f99a49b66699dada1f040e71451610c39eae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4e421e0ab51394d40e0e8e72513a0465753840c809808c87605dd471a6b7bc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cd7e40ecc47ec03a4a9c27dfa8ca18f2dfe298d07c936e4f5d281513e505e67"
    sha256 cellar: :any_skip_relocation, sonoma:        "37d62621eb1f01413a185009e93b424efa6ed14a5de5e14e81e8f367af78cb35"
    sha256 cellar: :any,                 arm64_linux:   "78301c10dda15d1c359a552706b603ae3bd87ae66c45f95061dc89a0e62dd27a"
    sha256 cellar: :any,                 x86_64_linux:  "b278bf851710cf4251259f1870c64d3b23868eeece7fbd19d1c4456b582f187c"
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
