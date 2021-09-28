class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.58.11.tar.gz"
  sha256 "e76178c67ef959b46e331d2124bb6f411e9f056d271dae3616518e8b2e7d7595"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "acb89679b5fd6d1573702a8f72cab6655e89d5b5921e994e4dee00cb3eee9ab3"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a63db47fe3b22807d3e5b6f21a868d22997782756395e4b4708a9a09143fe6f"
    sha256 cellar: :any_skip_relocation, catalina:      "1bed51dc9f904f8fbf7c67e02640a28526445d105541375ba05614e0692e08ad"
    sha256 cellar: :any_skip_relocation, mojave:        "4cc1d7fdfe9ddabb11b008ed363650783f1a49262a3c457c9f9158d43dcbac63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94ad6959d3bbb3202b05c1fc359268dd93fbc3b6d66c9519ac0321331ef9c95c"
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
    assert_match "1 potential problems detected.", bad_output
  end
end
