class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.31.10.tar.gz"
  sha256 "efa57adb475ac69ab19cc24a22d380b2d2700bfb6361d8a33a712cc2f191830b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18c08b73cf487b66e400f9030460f8cd205f65a8fab45a0827c021656ada64b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "b52d8c501f6e0d319d14315a9cf11dc774865aefa4496d6f064471328a618e07"
    sha256 cellar: :any_skip_relocation, catalina:      "4b132ef896d561f81fa25c4a5225a3de72b3016592488b2c3157e949ad3df2e1"
    sha256 cellar: :any_skip_relocation, mojave:        "90c044f3ec39c395fdb8b31d82689a4d2bca6738fc4fcf0e207a678371c8c502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cedf8d069cb5733ef82d39afef339e47ba4a3dffbe4e1b9588efd5b476a77fee"
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
