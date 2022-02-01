class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.0.7.tar.gz"
  sha256 "f1c7e043263d0183410fa5768540ff2a240365d84053ede1b94f6638af4db7ab"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca47ffb805fb372906198bd9e9577a017bb3d129dc135d191a7010bcf2ba2dab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "829fca0b5bbef5b278ec196a10fee75757b79727142621565322d87fec90c2da"
    sha256 cellar: :any_skip_relocation, monterey:       "a8de953467cb1fa6390a709b0bde84ecc2c44de08d9e44a6284567ca427ab91a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d594fb40dca261bd65b8b1f162a99aee31ecf79439a0133eeb32fdb8b9126af"
    sha256 cellar: :any_skip_relocation, catalina:       "38884ca7bb30d65db9040b8fe3457be681d7a6a559453cb7b67e0a9c5b06c5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09822053c996514fe53145f51ec0e63e28c7c983cadcf13f855e471d66ba7c80"
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
