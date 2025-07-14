class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.83.1.tar.gz"
  sha256 "94cfcb2613f37a88170a9c17708476d0aee0372b93a0fb66e0bd8e7897a4374e"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5485190331eef0c5ff61dd82fe21cae435bcc5d243b511f219d5f120e303948f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5485190331eef0c5ff61dd82fe21cae435bcc5d243b511f219d5f120e303948f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5485190331eef0c5ff61dd82fe21cae435bcc5d243b511f219d5f120e303948f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef384cbe0576346c7a9bc4051b8871830e0f1432e9736c9809f733b530e60f09"
    sha256 cellar: :any_skip_relocation, ventura:       "ef384cbe0576346c7a9bc4051b8871830e0f1432e9736c9809f733b530e60f09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb2966c7b86bc6b384ebbb904d2d83c37108651550027fbca74419ae42b3831f"
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
