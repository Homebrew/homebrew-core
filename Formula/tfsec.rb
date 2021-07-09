class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/tfsec/tfsec/archive/v0.45.3.tar.gz"
  sha256 "022c2e8ca678b721fb2a17e090080c7f30b273ce92f953f3ef719e151af8b2a6"
  license "MIT"
  head "https://github.com/tfsec/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fe294b5fb1b4dd30f738743aa7c838bc6eea01f3505587a151ccf90cbb7af75e"
    sha256 cellar: :any_skip_relocation, big_sur:       "0620911dbb1a7fe8d2c9b7d42cfb93c1a0b876f9f51720c72bb095c4300d5e46"
    sha256 cellar: :any_skip_relocation, catalina:      "c37fb36384d34299c8c95091f9b620e2fb67b79d325526e775b15fc47e739ba4"
    sha256 cellar: :any_skip_relocation, mojave:        "7af083daa120f457cd334de9974b4daaa5e36c0bbc70b557175915149628ed26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f119407ff70bb1df4066358c8535bb3b8a4a4c8ad8dcb1c6c5589e77ca9a938d"
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
    assert_match "WARNING", bad_output
  end
end
