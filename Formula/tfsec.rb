class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.26.2.tar.gz"
  sha256 "3ec29f25ff32cada76ad2467bff7a1bf56443f8d758aae7063d60ceb7a97ee4d"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e3c72324c198fb989371a3226e883c99e02622b3fb89598d1e024d5c85f25a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52a61fb7b886b8d778fc8f66c21d3b753ed63632db3fbe911c3c33111dc3948b"
    sha256 cellar: :any_skip_relocation, monterey:       "040af96053c5162d737a6b901cf4ce34ece4ed7810afa8bc7bd58b50349f8366"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c657cb570e1c0f61f3bce1c186d0d0c17a340a0397fc241cd13731bcabf3192"
    sha256 cellar: :any_skip_relocation, catalina:       "447c7392d0bbc8ad4bff05203c2bdddbdb987bd2b61582019798298ca671521b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa315e11b12825b342cf1d87799b972baa0369d1b1e23b43de8bdf3e341ba828"
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
