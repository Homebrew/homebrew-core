class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.58.12.tar.gz"
  sha256 "43ab51d76d9b67903d3abd49863757df6d0cc8e00ff717568e918ab052f1d33d"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "265c48dc1841fc317bb6e4408cd5b9ef551a31370b398d7e996763f2ec6f4feb"
    sha256 cellar: :any_skip_relocation, big_sur:       "9d63265cbd8669a9e22b54738e994a99ebb3f55ef98648d864c5939321eef0b2"
    sha256 cellar: :any_skip_relocation, catalina:      "323f6c6d726fcb774a43d257b0822b3f94cb341c2efb5367a2a1a4a56b108a40"
    sha256 cellar: :any_skip_relocation, mojave:        "0ef5af8bed97b1b3d557d38297b7b35cf13544cd2d081335c0a6749e70e07ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5df1978d0bfbce8e7fd91e3387ed7eb84e18eba47a98c0800bca0166f4404a1b"
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
