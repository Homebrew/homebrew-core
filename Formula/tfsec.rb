class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.20.0.tar.gz"
  sha256 "124c497d37cd36a29db6a4e8184f9f588a18d8d4a50226774238a9cf698813cd"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "316561b037b5c4e22a1f1dbc92dd47b56ec49a20c32af96ef115cdd04daede46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f369beec293011afeb692f7961ad6e08a07d788dd65b8241996bd6f5615f7be"
    sha256 cellar: :any_skip_relocation, monterey:       "715fd0eb4b7f846879974b0a2f996ae419805434a4b8cd94cd99ec2423aca233"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d2c70db9be3542ee85c3a2a0fd21e5978ba74060345dbb2fa9ba6314ef4d912"
    sha256 cellar: :any_skip_relocation, catalina:       "818d10c8b32983c0496b476cbb2f7f378c52b0381681874af665c58b9a3ad42c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6d7055f335503b1568c13b025f9b08a14145ed517980e7dd6e3d01e7c35db46"
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
