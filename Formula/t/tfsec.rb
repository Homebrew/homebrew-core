class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://aquasecurity.github.io/tfsec/latest/"
  url "https://github.com/aquasecurity/tfsec/archive/refs/tags/v1.28.13.tar.gz"
  sha256 "da61798e226a98e3d13de9d8c3b46d304834098e56422e6481cf58ef17891dd9"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ba29ee5620cf9caa84d5383b03bdd3652d77bb5d5d75b8e28c9a01dfd6e5863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5d8f51adbd6ec93430504d56257f40b996353e180f764fbd083027db1825c9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e939545e948611f9cb9af0e3c0493807dab898240b9a15123d1f8e355fc7b54"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b365c01dc9f6149159d6cad32feb0c9d6cbb123b8cfca3554d43713326c6ea8"
    sha256 cellar: :any_skip_relocation, ventura:       "7982570ec2ca494dae2a1f55d764fdd7216b90ac3797f0b7068fb8861eea6887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11d652ef5f0a858dfac179de3e323e82c10d9ce5cef3387756a3c6edfd386525"
  end

  depends_on "go" => :build

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath/"good/brew-validate.tf").write <<~HCL
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    HCL
    (testpath/"bad/brew-validate.tf").write <<~HCL
      resource "aws_security_group_rule" "world" {
        description = "A security group triggering tfsec AWS006."
        type        = "ingress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    HCL

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1", 1)
    assert_match "1 potential problem(s) detected.", bad_output
  end
end
