class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.13.tar.gz"
  sha256 "b17dd616d7fc62918d169bb1231aa3c1448cc86ea6d98db16c91063b86ae3fcd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dd20eaee9b08fcebfaa1484cddf2d6fcb95de8b35a76552b1227df51e2e633a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afc01a3c6fb0965d2560d1e9bd36ea781315a7325bf2680bba7510d76721a6a6"
    sha256 cellar: :any_skip_relocation, monterey:       "b6a3f1d6960301ea19d07feccbd371980329431a4b15f2451afeb93558b6d800"
    sha256 cellar: :any_skip_relocation, big_sur:        "982a2bff931ac03a1a887bd9e5fa0282d1781ca12e5f66b1d46a9d09bbc45116"
    sha256 cellar: :any_skip_relocation, catalina:       "f5224f7e55d460818b4c949c1c87f492abd0cb0faf922dbfc1401cb1ed5d7332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea8806a4ca924937c8a35fb5ac11d8cbcb7c6a9af8e4d548620a8245b6ec684b"
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
