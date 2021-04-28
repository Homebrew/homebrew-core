class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.29.1.tar.gz"
  sha256 "f33da3e49d3d6b8cb989a07961c2192026bc9475e2a839070ee013c4dbc19f37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "546f94b9f81d94c1a3d87542d72ea9e62d75a842b9d3805f3d6f87681b3eb27e"
    sha256 cellar: :any_skip_relocation, big_sur:       "d0f4cc7233ab9545906a0cd686263ccb8ef8d20242753b41154b6eb54acb0ab0"
    sha256 cellar: :any_skip_relocation, catalina:      "d437a1f1525d38796848a484cc373febbfde12e9e79adb01c71f5b7d7d059470"
    sha256 cellar: :any_skip_relocation, mojave:        "1f925d9fc5714c91e0987fd3ab77f07d21f9b952b37a1e1ab37ad57408d06db0"
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
