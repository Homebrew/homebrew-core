class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.93.10.tar.gz"
  sha256 "c4ab91f87e6bd0377916ddf19a0854433c52d955a0247ea559fd82440f72e840"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e712049430ee0a3a1fc3b144a6cb8b78a1e230d1ac9c2df5c6f0326286cd880"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e712049430ee0a3a1fc3b144a6cb8b78a1e230d1ac9c2df5c6f0326286cd880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e712049430ee0a3a1fc3b144a6cb8b78a1e230d1ac9c2df5c6f0326286cd880"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c2a09e99cddc9a89bd1c3a3790d0b6e44a433ac1152fed73ab8d86e2382c646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a285c8b5d68462ae863c14335f564d73c519553b12a0251dedc87e78291bcbc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70df7878b84011914b6cf7fcc9240da649bbf0735c4b13ff2343e8707ab33f7f"
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
