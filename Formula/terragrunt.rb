class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.3.tar.gz"
  sha256 "82213ab29c8c0b1ca3c25ff9c6b75f6445901527dfdf078744b3215168b27dd3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "924d1b02a4287e2a159bf533e6d62e9eb3d66f6005737049a13b360397532ce3"
    sha256 cellar: :any_skip_relocation, catalina: "0f9965d32ffa043c098e02f851e212f3858bb7053bc0e28940c76038fef80ae6"
    sha256 cellar: :any_skip_relocation, mojave:   "e46b80d5a5044825fa15a3ccf01ac5c05b9974d9de2e95c6737094851f1af2ea"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
