class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/tfsec/tfsec/archive/v0.41.0.tar.gz"
  sha256 "e6d578264d6e316ee9136535d76d0f46292bc5a31df0831b9a9299276b456e93"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "287cd57958e2f99fca42146f63ed8df9b6fae973c65f5dde5b604857f8ac4a45"
    sha256 cellar: :any_skip_relocation, big_sur:       "a3f6b756fb9dcb50f5ef7efad5e2018c39df1004492e11d1b0140156174e62f4"
    sha256 cellar: :any_skip_relocation, catalina:      "a57754a1c8a627f43cf6b7e1f0be833c8ead97b7093c622082027d46b0ed4360"
    sha256 cellar: :any_skip_relocation, mojave:        "24323b7eb709cafe40a61230c293cc058e653f7caa4096252164e683cee496f8"
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
