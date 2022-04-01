class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.15.4.tar.gz"
  sha256 "ca9749a2a831183425a02cd82de494492353f43f61e594b1ad1bf6b57738a3a8"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb21e604ad66a1d302ac89adb7aeebd731050ec6ea2100fbecda1a5a560c3d69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b203c396da01a50583db5a29fb30ca2bdc3a57b903169938c3be88a18e25b7c3"
    sha256 cellar: :any_skip_relocation, monterey:       "47b74063b311c39698395f4ecaa2cc8baafb14d2ef2245935fb4df709664c50f"
    sha256 cellar: :any_skip_relocation, big_sur:        "23dabaf779d0de4e71f86bc727a33edcd52880cccfc33edc73b71909fb5c4436"
    sha256 cellar: :any_skip_relocation, catalina:       "ab727ac1823c7e8188cbcb132715e60060d7ae694cfad89a7277425da9970e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d73e913fdf27ed66d74803fe4cf648c1a40340f78f3f32e02eadc0fdcd3af6"
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
