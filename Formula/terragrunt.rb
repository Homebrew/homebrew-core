class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.6.tar.gz"
  sha256 "c9166789a1645f5595e4ea4f56ac9fbaa0087e8bbc4d80c6913325edb4e05faf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd980aa082ae8a35fa3e103d85a5ae76aa0a849e243cba2686332415e86aa2fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "115c3db7a8e3c216eb4007f71e2518c98995290add7b84b7482e32e95a5298ce"
    sha256 cellar: :any_skip_relocation, monterey:       "72abda93d52ef754118a89553b92af30c95d480c7cbb0bd1f28e775688f01a53"
    sha256 cellar: :any_skip_relocation, big_sur:        "3664b39da2d7c8903495f02163bc87496d914b6e74994e717af28b74901cfadd"
    sha256 cellar: :any_skip_relocation, catalina:       "2187c9bc314a86075102cd3838d8a2a7cda5a8e75d7f36ca41db57f5abb5e5bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96294e0d6437baebbe94d740d03c72974df4edb29ef5851bd1d8edef2ec4c09a"
  end

  depends_on "go" => :build
  depends_on "terraform"

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
