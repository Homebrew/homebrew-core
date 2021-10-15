class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.3.tar.gz"
  sha256 "495e3d8685fbbfdb0a5d05aeab35c15199172b4b39c33a7350658ba072c28e67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3d398075539eb6dd55126550627f01ba68e0d9d0d09bd9f51b08b777062007a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c43b19c241329939b65e12200835b62dce33793f515e2d869a92ab817689ff58"
    sha256 cellar: :any_skip_relocation, catalina:      "5a7860dad97a4863ae81e69c99077e62a9f4266f9beed7393c227db235704b76"
    sha256 cellar: :any_skip_relocation, mojave:        "dff372d3af121e4d0c501272171f7f32befbabfabc5d2d8db24f02db5f51be32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0b28eba962d417f40bbdcc1870d6967e6ebd866597e4241a4372c77b38267fc"
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
