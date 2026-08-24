class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "1c3cf49a69de95dc7d7214ec2545be15522ca9a2e76dee0200da85f2e87a7848"
  license "MIT"
  head "https://github.com/gruntwork-io/terragrunt.git", branch: "main"
  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6aba2dabb80328fb2f8ced2eb37f102d24cd561a48a6e465df52ba629946520"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6aba2dabb80328fb2f8ced2eb37f102d24cd561a48a6e465df52ba629946520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6aba2dabb80328fb2f8ced2eb37f102d24cd561a48a6e465df52ba629946520"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd554a2bb16d4afa09f260de73335c83d695b943aebac16a98b4b8bced69a6a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "628fd985d3f9e9b2c9bf1dfc423fe72fc6a2e19b2905c3c706da2942e8e886cb"
    sha256 cellar: :any,                 x86_64_linux:  "c956473730e888c42ac103f738c2ebd4b40bcbe6d69b8a83fe80c6c768473875"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[-X github.com/gruntwork-io/terragrunt/internal/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
