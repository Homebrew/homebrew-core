class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.19.0.tar.gz"
  sha256 "587067b92ccaf93aa7e7f231991f4d2f30394c527aa44b87902189cf4470a6c2"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24dce5a793eac1d29338f3ff80e95e70c81f16b3a19de7ef97c782a05e15ba69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10777bf5ce9eae1b33a1ece2ba9d74c54b89246e9efe936702a1798cc7500598"
    sha256 cellar: :any_skip_relocation, monterey:       "8d80af466573f16f4077b012472dc1343f0a0c2a95a84a6ab826a4736432fb81"
    sha256 cellar: :any_skip_relocation, big_sur:        "a37f63f2f9feccc93063e4516adbe24ed25d6c61dd86000b26837190e9f2045e"
    sha256 cellar: :any_skip_relocation, catalina:       "cd7842784cfe5e0222faed10f06e15c1db6c983d464f2d6e78987a7900ca1012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54e31b171afd275e282bd3879c0b7a33688cc1f33a19c52170560f3415261be6"
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
