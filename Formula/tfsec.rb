class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.59.0.tar.gz"
  sha256 "0bf6488b8b4dac7c83b1175eb7d6b6786b41ca892f1678ff0b16597e45466fdd"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e20f97a7edfe3dd5a9e49067428d16ce16f83f029017dd16c0d855d33a822e25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa5adb20bec0188c59b5aa6f68ef87f150a1fe37aaf869a9e4f54a6ddaba93cb"
    sha256 cellar: :any_skip_relocation, monterey:       "7577613fffdf643ebb4c76021d9532a34a4231a9b8b6f135911d00a4a30e9f9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdb736aa546c99f2be7da32a8c97ab0abede7426887436ddb17b0c2edca2d2de"
    sha256 cellar: :any_skip_relocation, catalina:       "96a55508a126b2c8e5e5405255637682e25914df992cb0496ff8ec53fcdd8e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2afb5700103f27cabd175986c660c851ba3c7bf7f29624376685190764179c0f"
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
