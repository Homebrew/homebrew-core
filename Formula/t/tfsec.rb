class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://aquasecurity.github.io/tfsec/latest/"
  url "https://github.com/aquasecurity/tfsec/archive/refs/tags/v1.28.5.tar.gz"
  sha256 "fd2eb17a3fd8144888c0146f1067f0c3f5c99aa427adf85805dbd67d73f773df"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcda89be7f3a54ce85e994be3fcc15b14a701012ac63445636ef36d228f50855"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cf5a5d249829ec8654f3f4b0b138f39a958f299cff3318a3cd3c6cade427106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e2a1585404ccc02a4fe5a4096b88bd65df934cfeac4f318fa7ef5c3572339f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "658f3b31c83c5c296337c51a876e2c9422e580503a61672a35a5f2e907b18c24"
    sha256 cellar: :any_skip_relocation, ventura:        "650661276256df020d82197e138ed3568a4a4981636cd7215f3069bc65a86248"
    sha256 cellar: :any_skip_relocation, monterey:       "95878f7cac8b95ac28690097cd24352de5c0367e58f31dc87ab15cab76dccc84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c7b5805d37dc6b8ce1a9820e8aa3b53148f164fffb75ef8c19da250c28e0afb"
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
