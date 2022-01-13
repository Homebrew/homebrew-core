class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.19.tar.gz"
  sha256 "dcbf0642ab5ebdebf98b52df71fd86e36c8f66b9f5eaf6e6c33846a91af00404"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f24a438faf868bc162e15812e1257e9b4541ef001fd95d7c5300d0690cb51eea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fc8053c0d97a6d98ad07c47452d3bde7b326e0456ba9f7afa82317de396b9bd"
    sha256 cellar: :any_skip_relocation, monterey:       "ae99e7195b212c6dba3a972d3d15b7cac025a72c690530d101ffe54840bb4f55"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa45cd6be063d3e217b62c30e312449b236ce6c034d3e45a66008f00228bd255"
    sha256 cellar: :any_skip_relocation, catalina:       "9c6678aea55a45cb4544c33adae6958fbf8051e075a9a7f3084981d706b4bcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "067918c4ed52ae9cd0457f77f1e2845290abc3cc6539309be04c6ac70f36157f"
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
