class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "910cfc7dfceef54226184da35cdca0b117a0b08e7d97485cdc2a78e4d046fd09"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2c31ea4d7a1bf863c2ccacd759b84050619fb3f92f30e1c33b2b9975512a587"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2c31ea4d7a1bf863c2ccacd759b84050619fb3f92f30e1c33b2b9975512a587"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2c31ea4d7a1bf863c2ccacd759b84050619fb3f92f30e1c33b2b9975512a587"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b31be6b69e24589d27f631fa2fcb5332718cb7b450391f75b01e4f28d0dada69"
    sha256 cellar: :any,                 x86_64_linux:      "c5fccb9f8c546c5cc7e8e4335b37ab761c9c8f66404e8c6579d1ab5750a727c2"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/gruntwork-io/terragrunt/internal/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
