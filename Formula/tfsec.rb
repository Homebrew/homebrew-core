class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/tfsec/tfsec/archive/v0.42.3.tar.gz"
  sha256 "84a85225d29c36e3b6942577d81136fd4fed28bc60d36ef3de121ca54042ca14"
  license "MIT"
  head "https://github.com/tfsec/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b6cf952e367782de1c0b1b5baaefbfdeafca892c2d19089551d67da68d15802"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e14509176449cfb401fcbfe39b897869ce4e20d20716de005dc4007ada74171"
    sha256 cellar: :any_skip_relocation, catalina:      "86ee20378ec7089cc96ba96063bd845d0351ad5ab00c0e8a666cbac1bf915053"
    sha256 cellar: :any_skip_relocation, mojave:        "816575ee8e21f951ec8e81e63b9db51ac98d8305ee0b722a7d89128c276d962b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf629323e76f7cf0232506b7b113085315497cd352e6e3ec6352e65b71eea3f8"
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
