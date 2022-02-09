class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.1.3.tar.gz"
  sha256 "78d0f41eadeba2433fab890c40f6403b5153b68ac6e5cfe0f38c71ad2c1b19b9"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "393e2600f3d17a982dbb104332b4f0aea9219bb9afcaa0c240ce820bff1aa047"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82599d652b62ba940f589769f929e309c00bec6baf07ae5fee3c9ac3dace2ff2"
    sha256 cellar: :any_skip_relocation, monterey:       "e329e90db282800b92d56b1955ab5939e95804e5cc64dc85cfc0a3a846789eed"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f51e3e4dfc29ad748722bc4f8be1d84ceb88700ca7f85f5e7b5252c003ba6e0"
    sha256 cellar: :any_skip_relocation, catalina:       "f86d236abf6b2045859aff272a14e8cf53daae7ae75a585d4dd6c90a7df3c8ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d99ae2a0443c0cdb0a9d5dea725d59ddef9cb02cc8caea1b92e3ea827aa614d"
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
