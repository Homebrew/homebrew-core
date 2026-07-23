class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "acc997d59648d8d51d9b40b46321c5e88205326a4cb0a3b3a1254c205bae0ca1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67f73fb78745f07cd4894d898e63459ede9a57b208cbeb3b7e2b1a3f744cd273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67f73fb78745f07cd4894d898e63459ede9a57b208cbeb3b7e2b1a3f744cd273"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67f73fb78745f07cd4894d898e63459ede9a57b208cbeb3b7e2b1a3f744cd273"
    sha256 cellar: :any_skip_relocation, sonoma:        "eee83f74a0e0ed2d6cb40d4a7bad93fe2d3606269bacd2a2af380806f5956395"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dc9491bb8135443c32564a78142e887ac1c1e5fc4a0f82b7b1e802692230323"
    sha256 cellar: :any,                 x86_64_linux:  "cb2724aefa8a9b5eb739e61be1235cf85739c91d5686b6b0ba06abb405c71a90"
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
