class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.9.tar.gz"
  sha256 "5f3952de7474dc0d14d620e0f61b51c98070b7053e7b015bbf9f981ed7990fa7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79de744f23fe350dd6b69a3e268d39e299f3ad360e81d8b7a18e13c5a49dfd03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45396817709984c9674090500f270c348cf7816331367dba0ab18c44024fb210"
    sha256 cellar: :any_skip_relocation, monterey:       "29b0777bc1789bdc7e7cc1a92dfd94c0896c83ea2403214c69dc6a9c1e10e3c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d34255f838f55a001117f72fa6f8e094bdced4973eaf6dbdbc8f7cc2d022a77"
    sha256 cellar: :any_skip_relocation, catalina:       "2916a137a0f0119ab2815d2177e7063ce2bccdfa97b9e72965635f7e67c905cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6074b07ecf612da119515b676b7e066182ad0f92a657eecd08bc82b5c0d76a58"
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
