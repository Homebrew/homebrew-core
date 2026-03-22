class RRig < Formula
  desc "R Installation Manager"
  homepage "https://github.com/r-lib/rig"
  url "https://github.com/r-lib/rig/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "23f30bff14026141c82000b5e085f05410d30dace04ed383a6445981cebb3989"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d288b71263f4591641262c1f42c6811cc070a1fcc9e96c97cb3c4446c571da9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c365f2ce5205d4e60c6fe00c6d5291a6fa81ffdbc82ea251f23b6bd8a319bf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10a1d45bfb5d9135aa3aab694708b2b475dbda4d0192eb8e2a37ea059ce8fc45"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a1f545b58e6207b3be665f5a36a40e2d1ba0659648cd7e29d1a76f158f3f099"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5f965ec3c6589a9d9c3101f24c91716134df6db918845956f53f37c64475c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8f9fb4827b02f91ce993fc00131440b6344cbf27ed22e8cf2c3abfe4f107a05"
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
