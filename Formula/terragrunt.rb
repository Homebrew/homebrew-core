class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.36.10.tar.gz"
  sha256 "f7ad9750320c4430f9cf55bc687f6a5ab12441c2c828055c26411af34c433464"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a09f6ea38cce90248cc1028830c3d1e326761e2f091cad9668b1f84d2c5b52d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "788bf4b04095f5a3d571481be9fd4366365f328165e3e2753f3072ee929e71a9"
    sha256 cellar: :any_skip_relocation, monterey:       "19ddfd554cd312581c00066bc4f74ac4ea6d3c26a574fd5e7e353051dbcf305a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1c6e6e39d734b366c9eb82349e05bef4d05b223b509ad313e05c537c93f6e2a"
    sha256 cellar: :any_skip_relocation, catalina:       "3fda97dbbd043ab8d687c5e1a8def00c37dfb1f9c4b97523c19d1d50aebbc0e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3291d5791f3c947fcc0040c5776ab3e2abb07fcc56143bf2136db773b7fde41a"
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
