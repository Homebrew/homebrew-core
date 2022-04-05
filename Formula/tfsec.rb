class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.16.2.tar.gz"
  sha256 "d57b207e3d78e79cfe01b32a5311612b64ffcc7fd598f9ab5d18f3236c289157"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1e796176e52e96640a13251c7ba9f955ea23982770813c90a17c5ec540fdd2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2088d61ede0c2fd255cd328a9d530a8e6fcbd56713b1b24911008c809b42b6bb"
    sha256 cellar: :any_skip_relocation, monterey:       "e3198e75e731e50fd453323f338d1a09cf05c141cf28cf5f88b356c77da8b54e"
    sha256 cellar: :any_skip_relocation, big_sur:        "705431b414e8ff58b1841c567477e888989fa754f6061fe215ac397d46f6e43e"
    sha256 cellar: :any_skip_relocation, catalina:       "298449400ad6f09f07d9eddc14eb8fa476d50b58d73e15588f3fbd29d0e647ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca60849b396148406bbd6205e74d5d9efd286197c98f41bc6bfc4ae93ab1e9d8"
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
