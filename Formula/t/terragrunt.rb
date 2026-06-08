class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "e9708783189d704f19abea7fab85a880dd03f4f0794a0f93718d3485cfb8e79b"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce628c25e8829d21ee58477ba85a87daf387f3a76c8b63ebb8a5f1775462f4ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce628c25e8829d21ee58477ba85a87daf387f3a76c8b63ebb8a5f1775462f4ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce628c25e8829d21ee58477ba85a87daf387f3a76c8b63ebb8a5f1775462f4ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfd3e6b878f33579608e45edae21e3bb48eb2d610f40dd0aba586bbfe00fc8a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7df2afd3e3ea55134e3e07f2470d7a16c7431546bd0882def8def4036f3d2f4"
    sha256 cellar: :any,                 x86_64_linux:  "dff9c734d442c0116c23b4026abf807263badcd8606c121ff7cdb037f6e0b206"
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
