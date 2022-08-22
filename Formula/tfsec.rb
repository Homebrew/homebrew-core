class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.27.5.tar.gz"
  sha256 "bfa657d38946d48a4b23acc9698b1148250fe344159a5af31037892e6bbe8e63"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecb2a59fe24512cc2afe414c7733c7473f0d7fb560df48e1158748295f5f27c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a6297ecd0d61af80a1218ac83310ae00a94758b03885b1dad9971d15fab2970"
    sha256 cellar: :any_skip_relocation, monterey:       "c9a3354d3457acc9926200616c4a2e62578db5dd7b9f9cc574a4404db6bbdfbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd639dfe17019fd220beca1ecf3637ab27288225dd644912203c771b3e0eb965"
    sha256 cellar: :any_skip_relocation, catalina:       "d4cc14417e893b82f7f83e7252f502caef212255e8b5d6c5199110a3647efb34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed8b5f1bbe540c295979720f04244ebbfb7266f4dd425d859f95df14277d54a6"
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
