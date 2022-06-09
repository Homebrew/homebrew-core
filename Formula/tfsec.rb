class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.23.0.tar.gz"
  sha256 "656ef0e98cafe7b7b5911cd4bf22483ccd0c0de3cbf2d22208701d3478ef22fc"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d734402a7e869b4544725f00ad571ec25eb9e8302ec83334aed2ea47c96e0a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35d684126a46e4c9d5f7f590c76ceecce9b577fa306acedf792ac4925f75bf87"
    sha256 cellar: :any_skip_relocation, monterey:       "87b0973e065b0c67601e543b70f3180d9163bb8f65bf46f90185e9a12f194a0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "edd3dc8ca835b352e74af95e2f6dfb029b005054d6b6870f056504fdf435c1d9"
    sha256 cellar: :any_skip_relocation, catalina:       "01a812fd79edf442ef77c8da0df2658dfeda8baa86d858c00dc17b66449d9c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e057549c2452ff1c7515a0d026badaef2335e7171469d99a9fd11be14ef77820"
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
      resource "aws_security_group_rule" "world" {
        description = "A security group triggering tfsec AWS006."
        type        = "ingress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1", 1)
    assert_match "1 potential problem(s) detected.", bad_output
  end
end
