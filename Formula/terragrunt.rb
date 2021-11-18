class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.11.tar.gz"
  sha256 "f4d00e2125f41dbf85db5c3e95557ed46dc47b314e003c7a5dde46a9a68602e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "038f5859c8a90b06a151555bf62db9add50319888640e6519c1b59e788575ba0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83a83639becf3684531ee3217306279a4bf686f1aa4694a5d1d10ae3cd6c90dd"
    sha256 cellar: :any_skip_relocation, monterey:       "1f2e9273deaa0e785215a62c1fadd76f05738be076d1842d6eb4c5a55eaf3454"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ce988c709189fbef41a01904ddd643e28bd2999113ba726cf128489bec6bf73"
    sha256 cellar: :any_skip_relocation, catalina:       "83d784b05f2e17c6a6260c81815e3d080c83430e8de9a627ddb4f2f4db8017db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "903d27ac00e3d38fed4754f099042be5dd3eca7bca4dfe86495c5bb18d6f8d33"
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
