class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.27.6.tar.gz"
  sha256 "2ec519dae2bd805ff85cabbedd796bb1f3be3762d3706f573bc9da4824e79974"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1e9a277ba897a4b375ea3f04b21d91b86eff8c2505e02164c5112e7737ca7d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "081f3358855cc199d9aa63cfb11962a4a75df5acd756ddfcd95fa1b2dbe41d65"
    sha256 cellar: :any_skip_relocation, monterey:       "8c6e831d7cfa628297e300528ff91f8a2e9a966cf665efcea42367565e915d16"
    sha256 cellar: :any_skip_relocation, big_sur:        "716fab316328684be8614472d5f7c47198d653130d3c5f60801690c52b42016e"
    sha256 cellar: :any_skip_relocation, catalina:       "28d6d07308990b3694fd7c1c44da6405a801450f792b1b8aed48b51a058b2448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e535207c6f0c7053c7c58e89279a7745883e8a5e9b7dda4c28fa38610291cd1"
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
