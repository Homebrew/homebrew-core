class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://aquasecurity.github.io/tfsec/latest/"
  url "https://github.com/aquasecurity/tfsec/archive/refs/tags/v1.28.10.tar.gz"
  sha256 "7eb194c8e489f198126a3e322e8b4a43226a50e544c43b6aefb6f6c4ae836e21"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9c3afb8500bd7b93914ddf71316e71954c9924fdd80b8d23c52cc9f2bbc9249"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bee5f56ad1fc4f957dff2bf5fa780ecea9b0103a86f50aa768bba30301d2a41e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "861101574abb59e17a3cb3a09105c8464bce4014ab9372ea97e711a64c802cae"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e28088877b39af2ade96049c670531c1456d1f131ced357a8b0bf03e15f4d5a"
    sha256 cellar: :any_skip_relocation, ventura:        "d2e3867d8acd7eb535af42712bb8f1650c0f30fd28543952b5f92f2eb3c785ca"
    sha256 cellar: :any_skip_relocation, monterey:       "853aeb62467d9086ca58b03bf479ba8c3f13f6b11dcc77ba0d28d0c5df7bb690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2878538074d6a1902143d6d25c12ee8a04c3ad99208f7494edf6a7dfe3f1e0e3"
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
