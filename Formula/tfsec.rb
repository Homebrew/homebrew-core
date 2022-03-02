class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.5.0.tar.gz"
  sha256 "ebeb3393bdc5911335e5c7a1c38d34f75381d644c0964bbf8d0611b7fe9b0e4e"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50beacd13de864f26937cf3630248115d2611d30c9d12cf952637436b0bc3b83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06080c0ee1a8988af5470af5ceb13b1ab4e88dfe3ea525adbae143f206b536e5"
    sha256 cellar: :any_skip_relocation, monterey:       "8a975fb845c32a3bcd68070ccf390f1a47a8b52a33b3d623734f24414497087e"
    sha256 cellar: :any_skip_relocation, big_sur:        "05a966429e2ab4d9ddec2f78df06ef526b14dfc5f0bf390af9f6cf0d95998d09"
    sha256 cellar: :any_skip_relocation, catalina:       "b40eb83af4101411c6fcf36fd03c6cf2d74931e1f96449444c35667a8c5516c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de3c9e1caaab7f5192c16635075cca6441ac74b12f93570a78c2336f56c21473"
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
