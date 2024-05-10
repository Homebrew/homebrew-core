class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.58.4.tar.gz"
  sha256 "7774f6de2b587ef886450daea938e01b488aa4bb220a614aaaff25c9b0fa877d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e984daafcdb5fd94ed4b6511862527e97ace298bfbc2c167771de70c91efa6f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a670cb0beff9b1390099c4188c5be7cddfdbfbd06c38866a5272e86df4d42829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aacfa5bddbd3c5698484a7b402a96aa55c36968912b53b5af8bc7d43ab79ccb"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0b1871b7e9f52ed8a06f4b3801bd9f96cd4c7aee1a05c1b53f8844723baea1a"
    sha256 cellar: :any_skip_relocation, ventura:        "85a639b90e587c19cba8d2ef1bb67ffea1c47cbb539dec8d4642e06ebace50c0"
    sha256 cellar: :any_skip_relocation, monterey:       "58a039e7194d3e3e1edd204e3b9f00c953e669c8abbc474319fb944a12f3d6c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc927488773b482eb7e1fee9625e1be17dc1180bae7f4ee032c6c6efb7406b9b"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
