class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.43.1.tar.gz"
  sha256 "282179f73e4269df2311aa90d6b13f504f49bf0f3ee0c1dd573f60bc96053567"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad182ef94bb1c19d8d8d351eb366c3d1b145cc8d1be7d3251a9ab62dc6904010"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc676aff07d374b80f7da576feacaa817256f939bfe0cfda1dc23cbf78aa0976"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5046c25720b917b6a34c5107be37fd40d926fbdc0d8327046198dcdae36d1ce"
    sha256 cellar: :any_skip_relocation, ventura:        "3074dc44e5f95c910462b04c39585418ec785dd3d6488766986f2dae648f76c2"
    sha256 cellar: :any_skip_relocation, monterey:       "adced49e0545031201d9f82a7d9759c7143c5bac667d7d3f7a3fac46cdc84858"
    sha256 cellar: :any_skip_relocation, big_sur:        "34958ad8a0bf9214ff73f5ce68881ad1a9beeb222bafccf9b17e4e87e4e76e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04bb095b0f6bac0b11303241096b68f00b3d1262cfcd67ce799aa655b6208176"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
