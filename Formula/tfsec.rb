class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.15.1.tar.gz"
  sha256 "2b09b64fdf33ca1aab63f51a5b24d492c0937f574bdefe5f4f4a93e898bdecc8"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2b97f887898c2dd1924b8eb9825e70a0351ebeeea5de0f1967f4c1e428797df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "193f95c18f9b980a622576c566d15bcff0ce65ceb26a5cbf6b48f3c44ed603a2"
    sha256 cellar: :any_skip_relocation, monterey:       "143889dc8d98c4de7cb20110f14c30e187886ba7e6b95e04016ab18683576318"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fd42ff1e1a849f1e68a32c5e870e0c70c9e6fe5272f06fc77ad260b381473a4"
    sha256 cellar: :any_skip_relocation, catalina:       "20a0350ac8796b2842ca4b4a660b827e275d1ca653c4fc42d4c306f0c6d68f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1d77864b2f5cfcc64a4216703e5ae90888069e0393812b7b08adc6226fc03d0"
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
