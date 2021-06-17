class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/tfsec/tfsec/archive/v0.40.4.tar.gz"
  sha256 "6a8bcb9f64efe9c95130130c0f3c08b8b45595c8e1872515feed35734c1d7cf7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0cef5a0ad249303035c987cbd60eb9a7702a3c556ff073e5f8f324799cd53ce7"
    sha256 cellar: :any_skip_relocation, big_sur:       "7657953bd887a5585f3be29c9b6cb62cbd48bae844d90e48358e67e924bd3da3"
    sha256 cellar: :any_skip_relocation, catalina:      "f59e93cea346a671a86b7493b7eb6b84ecb17c1e3634fcab98964af337a48bb6"
    sha256 cellar: :any_skip_relocation, mojave:        "ec86b87409e14688b0129e2068d4e48b3d7a2982e4e7592592ebe2e2e1538c2b"
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
