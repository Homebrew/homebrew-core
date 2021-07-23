class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.51.0.tar.gz"
  sha256 "194b797c9c3f2b3e4af6479c0166d92afdaba8894e29d31f5c0276a7184607d5"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2642198a5feada824a7dbbb3ac108d2ff26282b1434fc980b56d9ca3d2824be4"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8f13881960f76caa54080418a6e75a17cfe3226a1d7fdd56e15809960f91075"
    sha256 cellar: :any_skip_relocation, catalina:      "04ddaf921e9541a69738a5de623a38a19340faf1d82cc55ef8ac723098787788"
    sha256 cellar: :any_skip_relocation, mojave:        "66ea86e0d145993237e4f4d4b1f0be2a1e43181f9ae29468c8e54d54cda5e987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985ae8124fed88b0af4e5a8fa8b784769f12fef25f0b6b0553001e652cdc5e71"
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
