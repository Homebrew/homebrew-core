class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.30.3.tar.gz"
  sha256 "1b4e1949dc3e34b37da8e7cde239fa13335f06e0ef777f9e30d8363de7c05a2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5b998129d52fc4c721e6cd309140dd6130ccb42bdb811e503886fd69b6cf5e6a"
    sha256 cellar: :any_skip_relocation, big_sur:       "5abd7a176448e7fb7a6666092c5237f0ed460beb0ce1a42570082bcfc6cd27d6"
    sha256 cellar: :any_skip_relocation, catalina:      "913ebb796968352da7008151dca07eb9e786f71471cde91dd81de519607bd7ef"
    sha256 cellar: :any_skip_relocation, mojave:        "9dc3c1f490884f3b4c72e101287cbf417694e6534111d4403ffaefcedfa5cee0"
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
