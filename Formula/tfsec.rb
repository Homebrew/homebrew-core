class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.42.tar.gz"
  sha256 "838b5ebd69e2046d3bd06f87915ce30ef25fe469da5d27b2f9ff519c0cb0d719"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d16e126ae68f68006b9025ce1c4efa7c193b55aea9195c909a44925bed5f5c89"
    sha256 cellar: :any_skip_relocation, big_sur:       "c30c4d5bb77fe749382cf3dc97e532d2a21ecc0c8bf16df5a91f32998ba2d64c"
    sha256 cellar: :any_skip_relocation, catalina:      "3d240a4d3f6c35295a30de83c1752c5f0e684ef7c855a327c0301a1e9df88cf7"
    sha256 cellar: :any_skip_relocation, mojave:        "3b932c85f2b46ba4ef20e81b7f58d9806f0ab147f13b1092efc0a80ede343b9e"
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
