class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.16.0.tar.gz"
  sha256 "b2f3da49863ab38de2a87be61e21aa946f69d1556344c26330b863dace19e526"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c599db9ee3f56ab5196d82c7078a6bdd97e1ad381c7669056f5e6d9534753e48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c49214800385447c3c3688d103d64f87ec481c0d24af836782a96f85f1d2f29"
    sha256 cellar: :any_skip_relocation, monterey:       "c59ddea7086d6333a5a3a9707be1bacb3c6ed2b0dd7b86e3c013fcab5c49af6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd4b5d1423b190fa39c7915c8c34468a0154c0a6760c4c5d00906994cfdeb6f9"
    sha256 cellar: :any_skip_relocation, catalina:       "772b7af789ddfd1055c7399c31453cf1faaadb046e8e7045dd5ea503407ae862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c82b3f6cd94aa924dec1eca6b1d9b810e22cd1dcec8c5c3e18313158d3f81585"
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
