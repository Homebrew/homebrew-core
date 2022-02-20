class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.4.1.tar.gz"
  sha256 "df582590e9935b3b6fb4b06738500a619a92847f29f412b642a3e4bc81f281c6"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f03a47562a66a772e90f5c5807395ede0e137d933928e2a1f2afc3adab7bec6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "315ee2353b71a1743d23da563e4eecf12aae8d1f94004188cbe6edd6659180c0"
    sha256 cellar: :any_skip_relocation, monterey:       "6841e21dded96e3417a073a6ea23efda389ffc840015a64f4ec903c7f7e3fba8"
    sha256 cellar: :any_skip_relocation, big_sur:        "92299919ea762deb5229445100ee2bcdacce8c345f3bed43d775d882d857fb04"
    sha256 cellar: :any_skip_relocation, catalina:       "e08dfe3d7758779b26cb9858919550db72c7ef3c8f36fa5534badb1c7fba1bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b1bfd731ebc5031b183cf09a738b87114c7c0a4d9e63e20b08bf492838f3bfc"
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
