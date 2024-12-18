class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.70.2.tar.gz"
  sha256 "8ec7b4ce96bb81a5f53673b416a1e6f3a0f00b293df3801d6a1d1f624b24c39f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28d423a0f807666fa78afd438fd67b05d3fe5431f1a3df9efaf21dcf50818fb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28d423a0f807666fa78afd438fd67b05d3fe5431f1a3df9efaf21dcf50818fb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28d423a0f807666fa78afd438fd67b05d3fe5431f1a3df9efaf21dcf50818fb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "468362a173bec22957109fa2acd17f58c8040f09e7fa637c1931b4a0ad90ddea"
    sha256 cellar: :any_skip_relocation, ventura:       "468362a173bec22957109fa2acd17f58c8040f09e7fa637c1931b4a0ad90ddea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b7c8c9674d3a9606494bcb2d861a6c22e30849bea23a14edd00ddb79978853"
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
