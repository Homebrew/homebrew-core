class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.58.6.tar.gz"
  sha256 "7b87d44bceca385188c5315e9ba2681ea809a92ffb905afad6f5fe85bc87acd7"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "72d57ecd93e69037e0189b3508a8e8c2aaccf50b452086b752047981049d35b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "44dfee60687de3adbd560a5ddea8772eb3bef86703dc045c5eb4c1c09014d2da"
    sha256 cellar: :any_skip_relocation, catalina:      "86c513fd2d3d92a3cac50ac7e24fb6710d39ba9cd238e836d77452c36a3ac1ee"
    sha256 cellar: :any_skip_relocation, mojave:        "955b58b5a9f8faf862ecdd36df794e7279b798710a364a3beb63d4139e210fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4837b470a0e079e703060891d7b476a3aa66eefc3535d633d93f877cabfe9373"
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
