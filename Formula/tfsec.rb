class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.27.3.tar.gz"
  sha256 "64279d36059991ac7231d5c52fb03efa84c3f647bf0d75d9ff200cf47a58729b"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9830f3e279ecd050839f6131458131aa494e390b3dd7a44845bc6064a381b8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25201c71944be672c9f8c91368c7b09a37562d557a119f4ba2369b6979d736bf"
    sha256 cellar: :any_skip_relocation, monterey:       "480e12a20109c8ad39331b307164534d62e18af725980cc3f93cd186ed175c4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0687907628ed361ebb6dc9e1b815effde54afda7eb2d8bf0fce8d26541634bb0"
    sha256 cellar: :any_skip_relocation, catalina:       "93aba7dfb2e34495bb83f00d4946a4b4436c911049adb2f6906c52d1cd0da833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45a18032c2e28b0273edf779fded57ccc012f1ff35a0417043fb8d6d0b332cea"
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
