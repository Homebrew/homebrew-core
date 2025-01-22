class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.72.3.tar.gz"
  sha256 "0cb9e775f42419538f638abada39bdb22e0bb8cb2491f2d4a320b998b4ab9700"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4564d17f5fda0d10e851ec1f56f48896ca20cb62823560616403c6b37baf108"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4564d17f5fda0d10e851ec1f56f48896ca20cb62823560616403c6b37baf108"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4564d17f5fda0d10e851ec1f56f48896ca20cb62823560616403c6b37baf108"
    sha256 cellar: :any_skip_relocation, sonoma:        "694b60861d377d3951799b4d5e62ab00c34df7b6eb36c085cf318f29e2f66093"
    sha256 cellar: :any_skip_relocation, ventura:       "694b60861d377d3951799b4d5e62ab00c34df7b6eb36c085cf318f29e2f66093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "204bab9061384de86feb11ac2af7b83d3d5c659cebd009c1a08f571e455288c9"
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
