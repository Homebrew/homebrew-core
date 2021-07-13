class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/tfsec/tfsec/archive/v0.45.8.tar.gz"
  sha256 "496dde6d46883125d59af4b8871a8a9451503bb711199303ba9b6134d138036d"
  license "MIT"
  head "https://github.com/tfsec/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "989626f52f0b52a725cd4587cf90e4a68d7c9baba25319f4764ecdf7e3ffece2"
    sha256 cellar: :any_skip_relocation, big_sur:       "d56fd5f19cc023a99a64c00818d2eb0d7c23da04c83e3c91626536b44b3163aa"
    sha256 cellar: :any_skip_relocation, catalina:      "ed197eff650a14b902dcf539abf6f27cabecb37dd5665384a94331da23079f8a"
    sha256 cellar: :any_skip_relocation, mojave:        "29e741eaac8937b9b982597e4c35a67083288b25879d2e8bf69a8be4d964ade8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "639411c70da6c38a875a676b5df896d45a6f0caefcbc954e4b87de34da51849b"
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
    assert_match "WARNING", bad_output
  end
end
