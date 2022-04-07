class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.17.0.tar.gz"
  sha256 "370184e0cd25331f00124399739277abe521296107c5d9e6589fba3f6d567f33"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7bc5cedd0fbab70b3a1f7b11073a6f8b8c23cfd935cdd51e3e4d671b293edce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "576378f82567c43d9828d2ffe238616825cad0f009c074d0630c359511c73b07"
    sha256 cellar: :any_skip_relocation, monterey:       "89bf987eeaaeb30e66b50ad43fca9f81738f71498b782069da8b0fefecd35a61"
    sha256 cellar: :any_skip_relocation, big_sur:        "b34cf9bc0f58036610d6202068aa8d2dc57e820ae0ab892128a5b267c5875cbc"
    sha256 cellar: :any_skip_relocation, catalina:       "5e7b459eaed6ea707598444cd7c24b1253b909c52bdc0af41511daece8c1aa27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5903d901d9d0066e0d7a782f0fd122eb90f8a92401803aeb3d825b5007627f88"
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
