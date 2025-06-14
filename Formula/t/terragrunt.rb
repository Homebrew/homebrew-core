class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.81.6.tar.gz"
  sha256 "b271e5b681296f18ba4dd6adb3ee51a463fc1aca2c931f0633006382337f5a59"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37bee1a66056fad861ab40bb03509a444ab11e88875dea61c9462e3a52a4a51d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37bee1a66056fad861ab40bb03509a444ab11e88875dea61c9462e3a52a4a51d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37bee1a66056fad861ab40bb03509a444ab11e88875dea61c9462e3a52a4a51d"
    sha256 cellar: :any_skip_relocation, sonoma:        "511e12516397f95c617d8a2ac4ef5ffadb3ffd8440e3b665845a2add82c93385"
    sha256 cellar: :any_skip_relocation, ventura:       "511e12516397f95c617d8a2ac4ef5ffadb3ffd8440e3b665845a2add82c93385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c8c5b823f6fc0f9ff87770a90f088969f8adb2ff393049b8abe42fe805c1108"
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
