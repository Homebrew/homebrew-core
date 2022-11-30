class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.42.2.tar.gz"
  sha256 "ab00413984c9ca09fe502fcb1a4d7d575ba49ff254f728918b60e7b66c167025"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae6f68827ceaff9c794e648ec862f1b664c7e7633ef06dbbd260fe3c25b8aad1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37de1377c93379879d7ade6c146fa9130202e176673653c7177de9fbf24a0936"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdf673cc1b76049035c2fc60356b58d36ab59f8fbec9a2709cb9bbdebd96898a"
    sha256 cellar: :any_skip_relocation, ventura:        "d28b7883a82903479557f07abf8ef27d166958f98ecd28a913b681c98334c3b9"
    sha256 cellar: :any_skip_relocation, monterey:       "721794c74d98e5ec64352f0b84bb65d47a89aa5bfeca774a545d3f330f961784"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d0a85bc74b9bccf3ae42d2f93258302bf89fce605751e6fc3415f3672c98745"
    sha256 cellar: :any_skip_relocation, catalina:       "9aa154f846bd18a8da03803e37bd7fc7955f13cf10afd1e10b5c29ba0330a870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1d07d00145dfeec33063e682be159437d8165736abd864bd67b164b90872c97"
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
