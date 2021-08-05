class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.56.0.tar.gz"
  sha256 "f39ec3853b779d5642b564a8ae4af743d2fdaa3fbb360627d1f595c47aa10aa9"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d8518394dd5d56442e1ccd351995d3c9142dc26390e9464e4633186d7ba11b52"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d49ea43e781f5e5473d676cf43f00d854d4cebfcdc40445319b0a0ca88111b4"
    sha256 cellar: :any_skip_relocation, catalina:      "90f27942a448171ef5d30f8a90e8f43596e261d1bad580f5f50b30708cd9e65b"
    sha256 cellar: :any_skip_relocation, mojave:        "c222922cbbe169a4761c95ec30c6c403407f94c67a7edd187b9d9330680500d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da4137d7f27d1ea74833f1bba054783d58ada2a0a2608d60e827e047829a46ac"
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
    assert_match "1 potential problems detected.", bad_output
  end
end
