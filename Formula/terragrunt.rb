class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.37.1.tar.gz"
  sha256 "c8bfad7cea4a165af474cff2f7386f91ee0d571a12cd897569b9641f2bbd0e93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "531721b3543b9260ad367482b3a82aafb5ce8e334fe44ba0413a3e10064e3378"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7994d2b14cbfe697a0b73725136ebf2e566b31a296ddd44e60663ca2cd71094c"
    sha256 cellar: :any_skip_relocation, monterey:       "bb6f0c2dbfbc0ef22fb5d445c8d9022c9ccc6a1b5da27d6147330ba34f926601"
    sha256 cellar: :any_skip_relocation, big_sur:        "88aa41a0c1d3530563012f6eefd378df96a9e9fc28543dd8862f66322bf0b7c6"
    sha256 cellar: :any_skip_relocation, catalina:       "1881233a7fced947ba0ba56d04f8481b1e5438072c075b30c96a287c565cb371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ef2873e4bf58dc9ee49417b7b314c8880af360b8159c68648c256fcb35e6f5c"
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
