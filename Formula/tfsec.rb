class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.23.2.tar.gz"
  sha256 "6a47f476db1cfc37f8a5c8143ae5c2e59f671297441df45677ab27e1790ac017"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd1a54ad0a0dfbddd2772850f9a68ffb2670a0842ab8209848ec1f8b03f66709"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dfe5581f8475ca96644bb374d38a5e9be23a02424002145ee8d048287db1f9a"
    sha256 cellar: :any_skip_relocation, monterey:       "a7ceebb49890f79dd0190adc9d2e9a790b996f6ed6d73a08609ae4d722edb36f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bd28420420017103c7475a5c8f709c3b611636386289575ec246d46837434fd"
    sha256 cellar: :any_skip_relocation, catalina:       "7614979361b84500505d66b2af2dc3c32e5bb2e511d4a5d140fb04419e02273a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4f6306874e4ef3903a93034c1c7f3143131451e3e6d50de500f54a49059a4ca"
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
