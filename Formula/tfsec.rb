class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.15.0.tar.gz"
  sha256 "c95f704f0e71999d6d28134368b9e9093f356b930aeb066f1bcbfa32785e4845"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "027c0395cefaea15c0ecc1b5bc39e6ddb0e06ae077fc95b6c6ed018069001af6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5e604be20c23bf645d7599accd1e611ce4b8433794f2ab846e2605023068c09"
    sha256 cellar: :any_skip_relocation, monterey:       "38f7c1b41c1781a60a86b5ede45b4584e283676302e5cef135dab52cf1c7b413"
    sha256 cellar: :any_skip_relocation, big_sur:        "06d41ba72910d76ec543d18fcc2094ac8c803d2a2925abdb4b7c58af70a7721b"
    sha256 cellar: :any_skip_relocation, catalina:       "775745dde5b28cd24524c544468afae67391069bbd1caab2f6fcf2265f7edf11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c8516df081619b567ce80193969db149fb25ef93211f56f61f9fa274ce509d"
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
