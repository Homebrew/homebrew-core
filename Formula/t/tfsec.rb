class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://aquasecurity.github.io/tfsec/latest/"
  url "https://github.com/aquasecurity/tfsec/archive/refs/tags/v1.28.6.tar.gz"
  sha256 "dd33335bb442541a54b2d05186f91489a324a2754b2b790b423d41a8c8c2a53d"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56a7598b8aef6721c3cce248fc47ba721be5a921e4ec48effe8bec5c3b5632b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ad94eed78655df904cf66392caba1598856639bc1b1f2c212c3a69545df74f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "229c946fef11dbc658fed1ed397fe37f98e641e2389ccd6a2e7841e921f085dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c6d656aa7f4d6f265b49b80acd2d33d17dd5ee76705a483c05c8395d80f4bed"
    sha256 cellar: :any_skip_relocation, ventura:        "feb6ee6ddbfe50c2cfe50ad649cdce31a70d192b8ee69739aaa18d7a14ea1893"
    sha256 cellar: :any_skip_relocation, monterey:       "2479e43c9444830e66806b2df0fcb7e9716431ba03515c4fcab6f897b7fd7e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa4b8700d5fc52ea912eb76510994d91e74fad7f6efd68d68e64eaa5d215a24f"
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
