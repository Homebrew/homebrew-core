class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.93.12.tar.gz"
  sha256 "4cc759a7881dea08b7c04786a31b15c5324e1b02e399ffbb39128b7e798fd277"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "249153fd74b0682347e512b23c3bff6f0e24f9e8b1d197f58055313d1fc98134"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "249153fd74b0682347e512b23c3bff6f0e24f9e8b1d197f58055313d1fc98134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "249153fd74b0682347e512b23c3bff6f0e24f9e8b1d197f58055313d1fc98134"
    sha256 cellar: :any_skip_relocation, sonoma:        "93afd5a86e711d9d99d50f38c63b32bead09f70d868bd3ffb63d53112e7a8b4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "714e43cb36c895536db842c990e95ec46583d9c396464662aa5e8d96e7a04665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91eb9d8d9a6d30438a8fe9beacfc35999f63e1e560555048ce8f1a441efa684a"
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
