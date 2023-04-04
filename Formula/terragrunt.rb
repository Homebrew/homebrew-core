class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.45.1.tar.gz"
  sha256 "c29d446dfce2e1536d059afdc83eec704a478a1dc4756053c084d72ab824ab42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b750993c97d05d3eb390793ba404cd72704dd83304b78c01b7cc81a1ee8aa8bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b750993c97d05d3eb390793ba404cd72704dd83304b78c01b7cc81a1ee8aa8bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b750993c97d05d3eb390793ba404cd72704dd83304b78c01b7cc81a1ee8aa8bd"
    sha256 cellar: :any_skip_relocation, ventura:        "3e12f3c88ee552ecb1a2f8132db61cd4bec4984ad468ae3b70f21478a7bc0e74"
    sha256 cellar: :any_skip_relocation, monterey:       "3e12f3c88ee552ecb1a2f8132db61cd4bec4984ad468ae3b70f21478a7bc0e74"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e12f3c88ee552ecb1a2f8132db61cd4bec4984ad468ae3b70f21478a7bc0e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80e477925775c2ab289c6f5c17527277721bd2ba1e950f68d4e4d3321e85232f"
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
