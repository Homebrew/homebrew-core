class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.68.4.tar.gz"
  sha256 "60c259d787eb74fc8d442dad33e2f697ab8498970b7fc71ea3d2a3c45cd9fb6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e40246918037286f7f08bfe224f96667f570a2f0380c1c19c4f2637cd15403a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e40246918037286f7f08bfe224f96667f570a2f0380c1c19c4f2637cd15403a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e40246918037286f7f08bfe224f96667f570a2f0380c1c19c4f2637cd15403a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a485e275dd41a9192a93550f460a3edf8e992a41fae765ebdd806e72f9d05519"
    sha256 cellar: :any_skip_relocation, ventura:       "a485e275dd41a9192a93550f460a3edf8e992a41fae765ebdd806e72f9d05519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f6fe5c26a6e452f79cabedd80fd6e415eec555e26de1e0038fa3269b9fb0f20"
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
