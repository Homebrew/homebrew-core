class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.99.3.tar.gz"
  sha256 "78b8382d45bfffd48fd7339d7ab00fa9c9dc322a0f2f5382a4cd72e7e93fb154"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "603cd334239954d8b80da45ea82d8cd5cb770e3f032311e6e215a1fd24093f47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "603cd334239954d8b80da45ea82d8cd5cb770e3f032311e6e215a1fd24093f47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603cd334239954d8b80da45ea82d8cd5cb770e3f032311e6e215a1fd24093f47"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d8153808f61c5c6ea4cb52d33cb2543ce71209bbbb830964d59a3b1c68fa32f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4622fffcaf67477b2c54f27cd0e98cfbc25f94e1683e474b31e0271d44b2b952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c18cdc3a0bc365de6943387233671dde180fa3f289666d4f69725e8acb61d1"
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
