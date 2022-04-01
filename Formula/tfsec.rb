class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.15.3.tar.gz"
  sha256 "76ab361d59d92186cfc6b38c4cea6c03209ea6a2fac099e60de896aa1d27ba03"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "483b2daab07ae95caff3ac5734962e31d6bfb74c1031732b3b3d501ce2a218e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a46773c3cc900c06e56bf84028eda25cfb859b07a7c003286bd89892f21cea8"
    sha256 cellar: :any_skip_relocation, monterey:       "f753e899592d6f5203da4d03118e773a6931016f222f56034743826d49bcd4bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc5ae7f8cdadbd7a402babe0d6576f38541cc5c6187d7ef4b9b29f00d70cb256"
    sha256 cellar: :any_skip_relocation, catalina:       "6523bde1184276348c3d39d8495886333a9d426d2d3019f035f2adc7348c0858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd8d0ca8e26d16e7412ce276ec25a1a488fcf26050aefc597a9ad1234a8f388d"
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
