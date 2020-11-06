class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.26.2.tar.gz"
  sha256 "f58d9a1bba7ea5821d4b925d58c426fe3b26b39542f7eaf7cfc03aeaa71f6328"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d14cbb170bed2cc381c144f3fd905f0c280bee59cbd1473cf5d55ab0c1e8ee23" => :catalina
    sha256 "7a1ea3881605c9cd32fe1b2ca3a5098c2b23e436dd017d2bb5d0fcc8595bdc39" => :mojave
    sha256 "e1492c353cf27efb17ae7acd2159a2ba4fd955e20357945e2eaa1b6587b44b76" => :high_sierra
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
