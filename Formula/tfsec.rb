class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.10.0.tar.gz"
  sha256 "72736601ac2e7828590e4646f6f962e6a343dbe2041b91523c98f4242d966959"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38c570d7809a57f3180b5f2c6b5319e319f300c09213961a476c3ca943124773"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78d7ef9f2c043c1b152cecfc31b5f5b8e2dfc05f79ea534b9f5a9786d075a0c4"
    sha256 cellar: :any_skip_relocation, monterey:       "0265656f0ddbc30ebaa99850c4943e5d852b08d069a6e271de3d0333be00d6bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "21cced65c9cff86e9cf43d51ac84b716354e1d920eac4767ff85d5d714e6b098"
    sha256 cellar: :any_skip_relocation, catalina:       "32eded10fba13e3db95701584d2398b8e6892503bd0c8aeb4a339f8039a551f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "955728bf766d1631065edb185133755874abc751f6948df330d6e83791bd0681"
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
