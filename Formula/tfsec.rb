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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab810223479f5e2f3685f2ff59b9b024d8d764b0dbca51caae2dcc4f33213506"
    sha256 cellar: :any_skip_relocation, big_sur:       "c40ab3183ca991d5457d8ae0eda8ff755a243b19aef0fba7729fd066b4e0098a"
    sha256 cellar: :any_skip_relocation, catalina:      "e3f7548c96e3edb3ba318f2a5316934b6f433309a789dc554f263a0cca4dc49e"
    sha256 cellar: :any_skip_relocation, mojave:        "f7bd366993fe835400db27ff7bd4f6f93cdd512538abed893193cbd94ee2245c"
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
