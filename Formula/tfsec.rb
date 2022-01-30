class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.0.2.tar.gz"
  sha256 "5589c3d2048b366412a0a25e67d0c802e9fc8be3996502dfdec8aa7446b8a1cb"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82d2d9ad26d7e1c00c35a854c35aa50dacb1693a6e9d096772bebe9e26429114"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a68244dd2453a61e883975f03f40f79f7fb3463459fff94d31aa91200dd5d918"
    sha256 cellar: :any_skip_relocation, monterey:       "052c4864b44dbad06ecaae095a27fcc4f88f8a71c3177e093cea496dbe5a2f1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0eaa75a3e49b6578c8c1f2af19c6ed2c03edbf698743199872f99b42d13ab8fc"
    sha256 cellar: :any_skip_relocation, catalina:       "535aa4dc59771ec2b35e2b96c851223f1d8ac215c7a32ef2cf044d8f6923491c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d842962957edbb782cd349ca1c50a43361f0985bb2807515c3ed396a763291b9"
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
