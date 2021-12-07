class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.63.1.tar.gz"
  sha256 "11f4d680b9163e23ce021cd15d2016a220e97401c68a3216820ee101d68aae44"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18c6200790372542d396a8472f28913973732770944ad00bf1f245bab06c3dc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b4c29748028136d5108826238bc5034f21b4841325979143d3a39cd40211ade"
    sha256 cellar: :any_skip_relocation, monterey:       "44909a1dc4fa64a856adcf89248bf9e25c2e1f567278f68cb0f00f882d99e1af"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa9f8138d1907a37391adc34d813d3c0f6ba32e6fb382be2915cd8b3371afcf6"
    sha256 cellar: :any_skip_relocation, catalina:       "ae2cd701a6abaccaf1c16eb884f3a95ca2f1954facd514bfbf2fc13de4bf89aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0a96ecfdfc2771e7821430ce6c4dac4990774755408a333f36c77527e2bef14"
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
