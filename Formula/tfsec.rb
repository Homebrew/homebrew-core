class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.26.0.tar.gz"
  sha256 "7d6cf04dc132e1c24044953d761aaa579e2c09bd807a2e376d8a79c821fead26"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6651eea77cd9f15fdba070a471d99a61a0a9cc85b91dbcce43fb8b4f97d104c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca16587e93d5825ceff9dc957339fb3e7f3c8ed7bead52a1c738b14a4e4fae7b"
    sha256 cellar: :any_skip_relocation, monterey:       "4be2425f7ee3e0999f8d08b6fd614f37944cf67e7bf992bc9bb86151937cfb01"
    sha256 cellar: :any_skip_relocation, big_sur:        "e55b3c2a4498a845d8734d42fb0a68ba491bf9243614376f2a4a197f92fd68ee"
    sha256 cellar: :any_skip_relocation, catalina:       "10e4e2ee181cbff5b9f32d2fba8cdccf643e6355bc5c89d0324571b221df1297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66a226aff0c56be706fb197bde8fe6123831e91a38c5b4467ac6e46ffdccbd79"
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
