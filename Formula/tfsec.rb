class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.50.5.tar.gz"
  sha256 "e3ed041b5187eccfb356eab8eb7c113638f2e155b5ffe24de2f21bcec15a0feb"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f491702d39f742fb093efa5cb61ff1c6efecb4e873b2524217ff39357fe46c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "1333b16c3aa89d93b6d1a22a8e06fcdcbbc6ca359d97e521271d8a4f32af7564"
    sha256 cellar: :any_skip_relocation, catalina:      "4f576813b01e2946905cebc83ef95acc7dde651413499c5248bc2488cfb5908b"
    sha256 cellar: :any_skip_relocation, mojave:        "bbd85931effebdb8f3f57d68cab80f59ea4fd02a7250cea9b9ef184e027aafcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e44ce276ada4590e2f7fab44a89e843940b6a102d930f9f4e58ae9f0c206241"
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
