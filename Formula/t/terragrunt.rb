class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ee2e5eb44bcfe8feb92ec655eea341e0fe1168dac076bb7a2c3c19f6d61bbf9a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22217cf42f25fc8ca3b4ff419a02ed79ca24439548c23b6bbabd36685eee539e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22217cf42f25fc8ca3b4ff419a02ed79ca24439548c23b6bbabd36685eee539e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22217cf42f25fc8ca3b4ff419a02ed79ca24439548c23b6bbabd36685eee539e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf0c821a9a1c49eb01cc875ea4f632aca0eaf08f18e9c76a5ce2a9c94e95adf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40b2c7d81ad21bc632b9a29629b64e29eb99ba29f2afd3639e6afcef3218f025"
    sha256 cellar: :any,                 x86_64_linux:  "3eb8c8b4e78e7e06362405dd2c0f71f494a4ad5d21c5912847c69368659aa399"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/terragrunt/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
