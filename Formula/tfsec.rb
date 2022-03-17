class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.9.2.tar.gz"
  sha256 "7af22af2f00ff1e02030ff14d3c93aedc723cfc32bdb1569804f976c355e4e92"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba6fd688b9f0a1342774761d81e5f327c30e995e5ac5c42a7a794af87813ea92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cadb71a272697ab52e432ebf7132076dcc5a38850761fcd08f7b4b387040a4d5"
    sha256 cellar: :any_skip_relocation, monterey:       "5e711989e054f42d8f8175da5740854c1c9a2107cc00663759d237ed89d0d038"
    sha256 cellar: :any_skip_relocation, big_sur:        "6be1c9e76bb60b40a7573a14b64caa6c3a50f3623ebeced82514350e7a907427"
    sha256 cellar: :any_skip_relocation, catalina:       "0cf7d3e10e9f5770428dba4a4aa88b1b0bf3dcfc5fa06f3d7109f0155f046dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8871ada360f5beea51746cfe6d137a5b6cd878374593b923916df02281c2fd5"
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
