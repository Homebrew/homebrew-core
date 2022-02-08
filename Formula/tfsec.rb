class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.1.2.tar.gz"
  sha256 "8ba0ae85ada8ab36c8982c5fbfe3ea2319d6319796490f5607181ebe5edebe36"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5af669f1a188fa075efa45c30cf768e14a028066e2a82b8997141a4c61830418"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d6f66df6e491ce4191fa6204f00f9028a148bd0ded01852aa58181b2bc6e586"
    sha256 cellar: :any_skip_relocation, monterey:       "6a8d4e07f54a77139c8563a0d91481d32feb0ab36b71f3b628c5f669aa876eda"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ab0c68a27f6baa9cf2d7984e682659d9bf89fe95cd5a4ac443862be6f573191"
    sha256 cellar: :any_skip_relocation, catalina:       "936ff4daf9fc5cb1cf92ceca7912656553e1d2b7f1a3a1bc955aa436f1446eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb64c6f93d02b6ff001d5a600b38f22721a64e5a231cd814c6f67469eb3cfe8f"
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
