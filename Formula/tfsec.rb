class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.58.12.tar.gz"
  sha256 "43ab51d76d9b67903d3abd49863757df6d0cc8e00ff717568e918ab052f1d33d"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e0b6692c49d78d7adc03bce15b3d14d5d5faf7e6612854b89d5722a6738314df"
    sha256 cellar: :any_skip_relocation, big_sur:       "039c58d6a0fa82413adec2c471b5387ae2cb67d59346ed313ffd1bd2be72e0cc"
    sha256 cellar: :any_skip_relocation, catalina:      "fc07df66ad15def4d41e5721c3e75282313a067de1026a6b01216219bf5a8642"
    sha256 cellar: :any_skip_relocation, mojave:        "4922fc4be92da03193b7d3c29f412634a3c295b974f43c1bd09b6525ffa16372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2663dd589f0446ec69236a2127dbc101c9715e804820e744dfdbae0f8702cd4"
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
