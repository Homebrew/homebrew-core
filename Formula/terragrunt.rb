class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.34.0.tar.gz"
  sha256 "21e2171fda6d2ac940c8cd46be09f02609f886e0fcaacbda6adbedd2127bc43f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3451a3c1e830cd6736b578a1f3c050e0618d212654a64a4e166554088f911e86"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e212f7875d186cac4a003c3f3e2fccc801ee77b7fd8d178f180a88c748c5e7e"
    sha256 cellar: :any_skip_relocation, catalina:      "1236ec51a107528b321e51a22a08a2547c3fdfda2f4964f0f79ad7a1b404e5c3"
    sha256 cellar: :any_skip_relocation, mojave:        "a1d8427ecffb12637331327b59f9f8aa56c2b01cdfdfb7e2bf3fd0ecd0ab5baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc6f81090f57281e7569e8f0b64dfcf42762db9c5a12def84d1a1416fd693434"
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
