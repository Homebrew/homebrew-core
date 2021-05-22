class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.37.tar.gz"
  sha256 "08f9846770c78cd2b7d77dc67896ca721ccb17bcb3a1ef0d3529699be76b6059"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "efc3506f1f08784cd21c2dffb2beb5915286390861579b015f9f2b777d9181ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "6089ce0bbe5cda6b3ae670430441b84f204e1aba31ae7bc9d09694e7a23d54fb"
    sha256 cellar: :any_skip_relocation, catalina:      "c43c06dfcd16a1f0917995198a59f0f94628efd47d12e69bdff286f4b0a107ae"
    sha256 cellar: :any_skip_relocation, mojave:        "8e616fa5a3043d0a6cc0030b1b002c9ee37f2c6ff9bff9b9b87c84610e370989"
  end

  depends_on "go" => :build

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath/"good/brew-validate.tf").write <<~EOS
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    EOS
    (testpath/"bad/brew-validate.tf").write <<~EOS
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    refute_match("WARNING", good_output)
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1")
    assert_match "WARNING", bad_output
  end
end
