class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.18.tar.gz"
  sha256 "e5d707b37add51081fef5143fa9a00d3578fa27ac9af9e3b4ea9e25fe2ba99b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61550451e3c2ef35f7f4fa0e1f2a750b48ef9faf8ebf8bbecaa33dfc043888bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "749aaa558307b3c5f1dc328b27f0d0d356641a215aefeb3a0cba66671d4580d6"
    sha256 cellar: :any_skip_relocation, monterey:       "1b548a142c419aea45f44acce7fb4183b10f0939d0cac29f1621ade44c1750da"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecf5548ce44adffff4b0bce35e3263051823b8b175036c2f65a14e611c940ca5"
    sha256 cellar: :any_skip_relocation, catalina:       "c2c8087ff110efb1ad417765bcb51184a3edc4a18ab8acde49c9064d945fbdaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "701c4465debecabed2b526a509b9d9b5ac06c78de3fd9bcdf92b4ca050692b91"
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
