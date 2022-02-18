class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.3.0.tar.gz"
  sha256 "00059677c5e2f64acbd99df8978ecd60e7616531bdba100f563267a53827424f"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2126a40b6ca7ce072328fb488c6405df51d6e60ebe44c46fd6bc77bec00fafbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "203955aa644e1c3dccb1aed4a2f1dbf8364ffddcc99da1417f9fb59cde6dcb5b"
    sha256 cellar: :any_skip_relocation, monterey:       "8e0891e060f6e51fb08c1ff85311a455270a04a7bd07f6ee3caf9dbdee9170d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "061bcf59e5661a56b5ab165581b1589f1f5526c0b8457d7d111007f3dc592214"
    sha256 cellar: :any_skip_relocation, catalina:       "57102fd08cf67f9c57efe32efaf7de391401cb874469ad0f6f5ccbd22bba960d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3735c94659a2805d94bd6b447a6a0ef584fcb26240d863f9caec4d1dcb5436e8"
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
