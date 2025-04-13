class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.77.14.tar.gz"
  sha256 "2765b74ca22502182d3e7f6b4197d823b8627bc090733ab2507bdd15190a703c"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dc40c6f8f218cfc76802dc269d504a3f146ec3e0a8d95175ab6031a37cbb4a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dc40c6f8f218cfc76802dc269d504a3f146ec3e0a8d95175ab6031a37cbb4a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dc40c6f8f218cfc76802dc269d504a3f146ec3e0a8d95175ab6031a37cbb4a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "559a2a6f39595e980787b972a07b0d9d638bc06b57645354f8a06c9b8c4304cc"
    sha256 cellar: :any_skip_relocation, ventura:       "559a2a6f39595e980787b972a07b0d9d638bc06b57645354f8a06c9b8c4304cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c516d37254a2d385c57121bd9eb9ade248c28566198e115c6eb9afc2e9a19267"
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
