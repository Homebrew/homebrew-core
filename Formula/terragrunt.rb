class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.29.0.tar.gz"
  sha256 "05e7d5650196ac44af97b081c106569e084bea48956472937d33301ae0c0ba76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd9bb4e64091e7c3c5be27c1dffaa21168b48ebddae37e6d265cf807f237dbf5"
    sha256 cellar: :any_skip_relocation, big_sur:       "57b2047ef3bbe18d0fc07b57334c2d9ac258a1e2b5fdf052b0f3527e8808ffa5"
    sha256 cellar: :any_skip_relocation, catalina:      "8cd17741cd2928b7671d5ce1e67e708f517fada4faf6b1cf3ad14fcc24e7b29a"
    sha256 cellar: :any_skip_relocation, mojave:        "5ec2435dfa385d12a47f94560ea9e4af35e25dbfe0da931d2427d007108a1174"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
