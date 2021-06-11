class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.40.2.tar.gz"
  sha256 "83488b28f09689c0b644f5e4ed8ef4e531a1c38cafadcb1642ceb2c224235694"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b21ba63cca0fba03688063fd9b48bb2673fdcab50877694b4958a38746dd1ba1"
    sha256 cellar: :any_skip_relocation, big_sur:       "b2e002d6fe5c1f9a994a8142eca2ce65b674161f3b180ac7af2460644930ceb1"
    sha256 cellar: :any_skip_relocation, catalina:      "1972fdec4efce7069d8c3cfa64060f476fe34b37e2a839cbd9503ff4e9771b0c"
    sha256 cellar: :any_skip_relocation, mojave:        "525f34012608222c729b9ea0724b72806f070c20a0cd777ec5c3a662be52e28e"
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
