class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.45.11.tar.gz"
  sha256 "621f688faacab5afec7d6cb2f821ceac3539fa737b050df634a54b710d8e8330"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa2c4088ffa6d18056b97df0d77aa8749112848da77d5f50742fd161c53732eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa2c4088ffa6d18056b97df0d77aa8749112848da77d5f50742fd161c53732eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa2c4088ffa6d18056b97df0d77aa8749112848da77d5f50742fd161c53732eb"
    sha256 cellar: :any_skip_relocation, ventura:        "c16530ddd84a827aef2de423ad98478ea720c13f1f5c19be232d9d0d14a3f991"
    sha256 cellar: :any_skip_relocation, monterey:       "c16530ddd84a827aef2de423ad98478ea720c13f1f5c19be232d9d0d14a3f991"
    sha256 cellar: :any_skip_relocation, big_sur:        "c16530ddd84a827aef2de423ad98478ea720c13f1f5c19be232d9d0d14a3f991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bb863a843dd6567cae4998daf2a98ed6c94878163953b7049a983fbdf794ffa"
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
