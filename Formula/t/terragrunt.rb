class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "ceb69315c9c5e62309efa6c90b9a63ca0875da23f8b98cd68ab245b1ea6eb915"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdd4f27542d77a1cb01af142c6b7fb9faa64043c33cd412c9a16e5349d18c4fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdd4f27542d77a1cb01af142c6b7fb9faa64043c33cd412c9a16e5349d18c4fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdd4f27542d77a1cb01af142c6b7fb9faa64043c33cd412c9a16e5349d18c4fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab405d6e47a994dfe672326eb289ae53ef01dba2ec4a25f6d7a9a697765a47fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11e14ebc0ca3c0a4ffbc02de2aabb54dd87e56d520b021d7f53967c32df2e67d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1ac646458779743da043d43e92c03995f8bd39695161a2c2e1233e95a23f4dc"
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
