class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.25.1.tar.gz"
  sha256 "7056eb349e2fe16b3ca39e6e2841be17f2d1add3b740ca43660c488a919213e1"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2abe2733279018853dcd0216088f09cdc6a10ff002f8518298a437a25f2717f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96c7f3eda0012e58749e60540aac6b4c15beac5d2b6ede78677b285cf1466c04"
    sha256 cellar: :any_skip_relocation, monterey:       "5af19e3540958c3f051e3aaf333e15b3185286af50c52d76dcd4e556468691cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef1227e83c27bf7a8d8b55219922bd4c66d913c5a0a57afaaf04b897ba59bb70"
    sha256 cellar: :any_skip_relocation, catalina:       "2ef514dcb9f221a3adc579798839bfb4c8cf2db41d83bb50f1686bf626f03160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fecfafc7d83d9f544e93f4f194e6e0c0e0060f02be13140acf7a875bea5a149"
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
