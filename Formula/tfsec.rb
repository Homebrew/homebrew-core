class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.51.4.tar.gz"
  sha256 "f33257f21666c5043d14ac9c60c497ab5928ee346f8f2f8798c3b32e36b2d1a1"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "80e992547cbafdd8484ac27b1a5868cc518e78cbf05ea39d39453f8e11d5e6a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "8663f0cd879e3b66ed282bcf16b09fa3f8845a1cab7d184afe7404b994c0edb7"
    sha256 cellar: :any_skip_relocation, catalina:      "aef8f1da229c119ae61f8b396fdf4468024554e5b0a4da068c63e8ce185775f0"
    sha256 cellar: :any_skip_relocation, mojave:        "8f286e7a562e0bf75572f3f20c3962caa9e9ce6ffcd5140287c9035b93b40d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25e2e2ccb0a3a6852921d30e8ee96678659c5353dd928ece3f2b43eed48e4bac"
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
