class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.11.0.tar.gz"
  sha256 "31413d2b7ff7e412a164d93cf729ab46fe28dc9bfdd09b507d6ee709df7fa0dd"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27acc118e231c1900bec25fa17e7e383e23158010a4bc903b28f377ba7376839"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a57678d554812c7efe4f47fc7388b4edb3f8cec58f7ed3782a02a445a641ce84"
    sha256 cellar: :any_skip_relocation, monterey:       "22d4c54186b610cb6bca634b92c8ed9d4e4a2809715da5dd9e1d9c73771bd355"
    sha256 cellar: :any_skip_relocation, big_sur:        "546b3af278e9578796011de04f1e5213424a31e66701ea1e786dd15bd4f1c044"
    sha256 cellar: :any_skip_relocation, catalina:       "83e59d515f11cd533adfa8d7b9264f5a234a3dd549c570597e181b2e823e6623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a62eb996a0574210dc05b7c645726834ff401f097e871152250b8aac22f56ccf"
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
