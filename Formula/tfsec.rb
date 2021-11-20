class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.60.0.tar.gz"
  sha256 "64d6ec30942bfc071c3dbc4a6dd0e50a1b1ef4e63bbfbc441a76a7882c595fa8"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ca9dec8fe964ff78bddd70a0a16b1c8da885f66334e6e67b2e99b0d28bb686a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e7e22286faf406a19de0982d6529582b02638a3b1586f1a62cd4ab75842ccba"
    sha256 cellar: :any_skip_relocation, monterey:       "ae2339de2b93dc8c79ee30d6b872e4366dc0435e3cbba8316a4b646bb5fb5be5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6426b7f76b2589c7ff809fd08688cafc5992e1bdb9982a0d22fa91725b1b640c"
    sha256 cellar: :any_skip_relocation, catalina:       "8fefe4a41cf07358f6d99b16217acde729c26d9847bdf92e6b858779bd42b094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7786254fc9f2dcd94388ef31bb2068f9f22576f9d17ab67c60b3b51537400433"
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
    assert_match "1 potential problems detected.", bad_output
  end
end
