class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.37.4.tar.gz"
  sha256 "f3533f36bfc1009a9bcc24505a0d2c32e6a15459312dbb1e578d2cb6444e0341"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d2a2c326e77724642bb2caf100a338f59543c2e847266774f3a698412b7b2e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90eaae02b608a8067a1f0999d5be4a59970ee204a1e2181a5d45b7f5cbd42a29"
    sha256 cellar: :any_skip_relocation, monterey:       "909de0c6fac63112263b8357e4aa58c2891831d3ff05838879fa3b4333a7d8ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c2d94c14e35f27c2d707c0d3ffd97aa71b29f948a42f6892f71eced827cdd89"
    sha256 cellar: :any_skip_relocation, catalina:       "b239b47ad1a66b9dcad813886ac5bd099ba50305f5c0f990ba464455954d8377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4412a6174b54392b20ce4346bbc358843b9977b96c7aca14759634397cf5a9b2"
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
