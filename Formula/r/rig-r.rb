class RigR < Formula
  desc "R Installation Manager"
  homepage "https://github.com/r-lib/rig"
  url "https://github.com/r-lib/rig/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "23f30bff14026141c82000b5e085f05410d30dace04ed383a6445981cebb3989"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a1036df99991fe7a75a97f9597eacdb97831ec77154fec34c5d161b1db1f70c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e4ba5e6c0c9355b7e9662fb85c6c0ce9bd2048fdca32ccee2c42205cec68202"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e47bc29145a28f48c26f72eb8769e15018a0426375255f4eb027b3cf27179f44"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b852f137a8505a9b1336e1a6b140fa43e52dde797024c00bdbc8a448225eccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0da71bb0532251d9eb59a4ee896da94f778fd1ebf3d20c001364dfed0120ee81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e1618090f52d92e8cbfcc3524933798ef54db747bcb956fa6c5df3f9a5e74d6"
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
