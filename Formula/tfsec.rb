class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.54.0.tar.gz"
  sha256 "f7c63a3a0a1181e00bf55c5c3f61c8201b4f800c0becddf4e684e1decaf766f7"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "153db19a7c73c24b7f7f946cd9ddbe274851dca0008c4f840955cd6b386c874e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3287658df37702d152a1995f89ebfd889412508c3eaac33d7e5a0ce51dffffb"
    sha256 cellar: :any_skip_relocation, catalina:      "0c57072bdffd605e2070e4553bf5de9a821e7a904209b791d51eaa29fd3a2e6e"
    sha256 cellar: :any_skip_relocation, mojave:        "2c3fbdf8435de3a33ffa7e69467952c40352dacf1b85139839e77d5ac8b5ff5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "588c1d5e81844cbc713c9ec15b66158a72a839204c4aa987ad0d990cfcd1d8da"
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
