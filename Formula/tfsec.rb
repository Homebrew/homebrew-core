class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.0.1.tar.gz"
  sha256 "4d367fe7ab503933f7e4d73af18f9663fb7e7b0e9798338c633b67aeb8e9126e"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84c9ccd715e85851d21ef125f270b103575bc46515fc7205e02cd68ff2f1b381"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92042549442c652d8362dfea3497f40cab9097f8bb3bcf868e46158a498254ba"
    sha256 cellar: :any_skip_relocation, monterey:       "805857af39e86f1e67427dd8336ce10b5e82ee0a9c6effb0d38fa7e27fda5569"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d829ac549bbac28c1dce473c33a37a3216261dcc17bdd733586876fdcf0cce5"
    sha256 cellar: :any_skip_relocation, catalina:       "1d352f6e9099eb279f5b8c8ca8dbddc5d5f361e95e2438428d4252e0468064f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cff7d309fe204945f43d09757f1a60670d2ef1cc34edf100348ae217c611d3f0"
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
