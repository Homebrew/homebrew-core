class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.15.2.tar.gz"
  sha256 "1fe7168d0dc9ae5473aa4b14955d8d7f194b1afe098acfb9358b6ec44286edde"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cc9e8148aa920e775646c5f91b96f0faa7453e8f5104d0f74f02def749e6132"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b223d0e19f89146f20153bb3118f3ac2445ca4d49b5599fac74322f8e9fe6791"
    sha256 cellar: :any_skip_relocation, monterey:       "740ac7c7e127ac59f62e8b19e91ef9836bbe95446d22ffc2c7204eb8c11a76e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d25ffcd5b08f47125cbf7791525bb38c1840cf8550bf843ddb8bd1577d93ebe1"
    sha256 cellar: :any_skip_relocation, catalina:       "522888877dd9287147aa7f84c44281990f283c6345e488f6214d23e2a3044b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e8b5c74557a0fc2bd307a8639e3a190d9adb4af5e273beb9386be8164ed6564"
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
