class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.31.0.tar.gz"
  sha256 "85878641f3e3912948c694530fe015c8af8d1d1039f168336859ac85cb028d96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c5b5d8b74a9a940d4ca5a28691bf98b421b30e3b1e57b6a4ff18eb5fd267a0f"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c872d1ea512685db8b1ffe541e955542c0edb4df5e387926949187ccac40eef"
    sha256 cellar: :any_skip_relocation, catalina:      "ecdf4ee3b655b2603bf9a6f0ae62026222b08de1362073c4bf5da767b16917d1"
    sha256 cellar: :any_skip_relocation, mojave:        "620aa3237977725d6b96e18c1699d0eab8996c2a1508644a3502959030b50045"
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
