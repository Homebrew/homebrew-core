class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.0.2.tar.gz"
  sha256 "5589c3d2048b366412a0a25e67d0c802e9fc8be3996502dfdec8aa7446b8a1cb"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "307200c08ea045ecb261782a67491ffdd6ff8748bd9a49e7d5a91c0a2c2c2845"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25161e8a9112974f1f96cae6588b73b1485162475d73510ef629298d3115356f"
    sha256 cellar: :any_skip_relocation, monterey:       "e534bf05a56916612a7124812e1ea3c4561721d55874d9ff22373338d3b9447a"
    sha256 cellar: :any_skip_relocation, big_sur:        "496d118371903dd614a8f060a92e94254bf0774445e8e6eadb75fbdcb60b7eb8"
    sha256 cellar: :any_skip_relocation, catalina:       "01c71e89b8f1e2686f6295dc3e78d0070cd4f11de493a5b1698c10098b1a1a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d52e8de2f53275ec61ead1a0fe00828205173f1cb34b54b705533d81a5f94cb"
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
