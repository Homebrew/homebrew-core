class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/tfsec/tfsec/archive/v0.45.0.tar.gz"
  sha256 "37de7255edb697f42924ac8809bc2be912f34bbed1afb7e4d081d0efe99d5059"
  license "MIT"
  head "https://github.com/tfsec/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47755461f495e98bb938c5b7cdd84fcedc6a0b121381ffb69aa424f095c67583"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd54f5b553b4dd14e19af291d312219834f99b3d7b82871a81890fb6831acea0"
    sha256 cellar: :any_skip_relocation, catalina:      "b634f10420979b2a3d4268cebb7e578394ba6a5c22e2f39283276a0fb7a34731"
    sha256 cellar: :any_skip_relocation, mojave:        "a70fe7d95c7b031bf5b4c7d17c98dd64526be96e629b0a3bab131fb680c7d07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff9ab5644bf4663d4c615172b162b4d622d9bae68b5cce0021f3393dcdaa893c"
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
