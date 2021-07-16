class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.48.6.tar.gz"
  sha256 "4bda9220391440bd465005d9bcdfc175ed915da0ef1ca2b78790f340aa34968d"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6a1a80703555d1a0dfade9389c955562a01facf8989e509e16c51c87986e671f"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec9f588b41f24d852d7f58c05572382c2dbfa9bf26fb5a4c4c33647901b37b80"
    sha256 cellar: :any_skip_relocation, catalina:      "b9d33d3f9a198e5246603cc8209bf94c4c3a8cdfc6b0430b50a5df1efd30c190"
    sha256 cellar: :any_skip_relocation, mojave:        "bd4ba351be49a349341d7b848c938a852313e06b0976505457b49dd6dc121b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05db0756e77c200bb2d68cc7547568671cac69a6fee56f740fdd0f279edbffde"
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
