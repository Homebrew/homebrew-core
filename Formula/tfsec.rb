class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.27.2.tar.gz"
  sha256 "fe7d300aa7c66f3a48afebb55ca4ee3dbe387faac430a0d86d46417b8bd01b33"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42efeb735ed3bb924bc49eb2cd351677365c4c96747f0ff81300375d011688b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f973d00670d0fbb1f1c1c5bc63c44d4474d4b31f9b679560df9cb9e5a605d279"
    sha256 cellar: :any_skip_relocation, monterey:       "af4804bc83d4603fbeb01f700553081cd4480a2030668908d15e8fddd9fc41c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7eb1ade4f569be1c49160984d3f1914f404bbab2800c43526ce71a0760420402"
    sha256 cellar: :any_skip_relocation, catalina:       "a46699e40bf3ca876c6750fee23c81de667b9b1de5f5708bd01d5224c10e2314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4734dcd10893ddb13d9594b81b09d7c5c14e21c0d7ac3cc869bb23dbc557b75f"
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
