class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "7ed72aa96c67b0ca023792d69efa8b41748730543a2a58044e8ff86d58b83e6c"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afee86f7889613f2059050015422746c0de3d65f56d97bc5d7786231919655c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afee86f7889613f2059050015422746c0de3d65f56d97bc5d7786231919655c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afee86f7889613f2059050015422746c0de3d65f56d97bc5d7786231919655c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d31497c41004e797930a2b02e87c5288f45bb3e77419f637007a97d1d881e99e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc4d8c6d64732b334fdedc92da17ce684e691120b3f3436586be81d1c33c19e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b62b2f82966f3b147ac241c746c3c71b33c95ba1e28a34052ab4b0962cb04f66"
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
