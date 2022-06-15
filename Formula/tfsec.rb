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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "317c2e224b8d937df971ace6037bbe8d391590a953a9cd9e93b4298c7eb87a4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3925f12f8d39f9dccd1aab4a6eeb8546fda8295670563b0560ecd1807ee4e5fa"
    sha256 cellar: :any_skip_relocation, monterey:       "3fe43d168d4de4833fb829e8a153d3b6155be0a85cb84dfd0e056b368b5b88db"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8c0299b18dc766f9dfd2e319954ae7dcd01045b8ee5b2ea4f18655924ea4b83"
    sha256 cellar: :any_skip_relocation, catalina:       "794d52ee25f5c654acdeb9bbf77866d66df36cbceb5cca803a54842a3d941697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "497811d5c2f512cffe007fdc7dea213f0b31ff5ad2f415f7e6e7a3133ab0418c"
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
