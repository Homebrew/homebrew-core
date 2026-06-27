class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "a5cdd3703944646d5d3cf2ee0b168e1b5b4873fa40fc0e558f59e9286455746d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f19cf7a114e51d26c02c0fd290074da19b0c03d4665e4ec64ef5c0a97dce474"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f19cf7a114e51d26c02c0fd290074da19b0c03d4665e4ec64ef5c0a97dce474"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f19cf7a114e51d26c02c0fd290074da19b0c03d4665e4ec64ef5c0a97dce474"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bdb239635a55eeb5e9dbd6c19ccd46626eaee192a9130561586c9105936bfba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e60df16b36ae5359cf9f61ebd864e7c902c5d9a1b3e5b4fd143e26b6c1cdb7b7"
    sha256 cellar: :any,                 x86_64_linux:  "440d78b32accc203e318f5a00d44894635da87c931395b39d370b4c2aa9aa3ed"
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
