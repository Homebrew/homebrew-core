class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.27.1.tar.gz"
  sha256 "02c563e682b05c742434fdbfc14a79d1ea91071ac0f45659f973bd3e05dc394a"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e277d38c47782502a6e6c5f67fd1660ee10c8301a5b85cbb98fd2cc0d603593"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb11ef0aa0721463ec0ae544085864f9883947c7d13a576770d6c626b7ad563b"
    sha256 cellar: :any_skip_relocation, monterey:       "3ec0348c907703f309db7df676b99976bc9dfc317b32fefdf189cb1cc8a9b505"
    sha256 cellar: :any_skip_relocation, big_sur:        "73be3b6c74345750fcd9f05b06474b0655769004e9c15c37a5aaf92f93615b27"
    sha256 cellar: :any_skip_relocation, catalina:       "acaf7085b90a45dcc655561a19d8264488afd4282b6bceaaa849b8209aaea043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43ff7f4a7408a0ab8f9ebe4555e565d755d7f4f9190f0593c36fbca8a2bd04e5"
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
